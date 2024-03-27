package usecase

import (
	"context"
	"fmt"
	"log/slog"
	"slices"
	"strings"
	"time"

	"github.com/bwmarrin/discordgo"
	mapset "github.com/deckarep/golang-set/v2"
	"golang.org/x/sync/errgroup"

	"github.com/SlashNephy/discord-broadcaster/domain/entity"
)

type Service struct {
	config  *Config
	store   MessageStore
	discord DiscordClient
}

type Config struct {
	Topics          map[entity.Topic]string `env:"TOPICS"`
	DiscordWebhooks map[entity.Topic]string `env:"DISCORD_WEBHOOKS"`
}

func NewService(ctx context.Context, config *Config, store MessageStore, discord DiscordClient) *Service {
	service := &Service{
		config:  config,
		store:   store,
		discord: discord,
	}
	discord.AddMessageCreateHandler(service.onMessageCreate(ctx))

	return service
}

func (s *Service) onMessageCreate(ctx context.Context) func(event *discordgo.MessageCreate) error {
	return func(event *discordgo.MessageCreate) error {
		go func() {
			messageTopics := s.DetectTopics(event.Message)
			if !messageTopics.IsEmpty() {
				_ = s.forwardMessage(ctx, event.Message, messageTopics)
			}
		}()

		return s.store.PublishMessage(ctx, event.Message)
	}
}

func (s *Service) SubscribeEvent(ctx context.Context, topics mapset.Set[entity.Topic], channel chan<- *entity.EventFrame) {
	go func() {
		messages := make(chan *entity.Message, 1)
		defer close(messages)
		s.store.SubscribeMessage(ctx, messages)

		for {
			select {
			case <-ctx.Done():
				return
			case message := <-messages:
				messageTopics := s.DetectTopics(message).Intersect(topics)
				if messageTopics.IsEmpty() {
					continue
				}

				channel <- &entity.EventFrame{
					ID:    message.ID,
					Event: "message",
					Data: &entity.EventData{
						Topics:  messageTopics.ToSlice(),
						Payload: message,
					},
				}
			}
		}
	}()

	go func() {
		ticker := time.NewTicker(5 * time.Second)
		defer ticker.Stop()

		for {
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
				channel <- &entity.EventFrame{
					Comment: "keepalive",
				}
			}
		}
	}()
}

func (s *Service) forwardMessage(ctx context.Context, message *discordgo.Message, topics mapset.Set[entity.Topic]) error {
	guild, err := s.discord.FindGuild(ctx, message.GuildID)
	if err != nil {
		return fmt.Errorf("failed to find guild: %w", err)
	}

	channel, err := s.discord.FindChannel(ctx, message.ChannelID)
	if err != nil {
		return fmt.Errorf("failed to find channel: %w", err)
	}

	member, err := s.discord.FindGuildMember(ctx, message.GuildID, message.Author.ID)
	if err != nil {
		return fmt.Errorf("failed to find guild member: %w", err)
	}

	effectiveMemberName := member.User.Username
	if member.Nick != "" {
		effectiveMemberName = member.Nick
	}

	eg, egCtx := errgroup.WithContext(ctx)
	for _, topic := range topics.ToSlice() {
		topic := topic
		eg.Go(func() error {
			if webhook, ok := s.config.DiscordWebhooks[topic]; ok {
				webhookID, token, ok := strings.Cut(webhook, "/")
				if !ok {
					return fmt.Errorf("failed to parse webhook URL: %s", webhook)
				}

				err := s.discord.ExecuteWebhook(egCtx, webhookID, token, &discordgo.WebhookParams{
					Content:   message.Content,
					Username:  fmt.Sprintf("%s (%s #%s)", effectiveMemberName, guild.Name, channel.Name),
					AvatarURL: message.Author.AvatarURL(""),
					Embeds:    message.Embeds,
				})
				if err != nil {
					slog.ErrorContext(egCtx, "failed to send webhook",
						slog.String("topic", topic),
						slog.String("webhook_id", webhookID),
						slog.Any("message", message),
						slog.Any("err", err),
					)
					return err
				}

				slog.InfoContext(egCtx, "sent webhook",
					slog.String("topic", topic),
					slog.String("webhook_id", webhookID),
					slog.Any("message", message),
				)
			}

			return nil
		})
	}

	return eg.Wait()
}

func (s *Service) DetectTopics(message *entity.Message) mapset.Set[entity.Topic] {
	topics := mapset.NewSet[entity.Topic]()
	for topic, channelID := range s.config.Topics {
		if message.ChannelID == channelID {
			topics.Add(topic)
		}
	}

	for topic, channelIDs := range entity.TopicChannelIDs {
		if slices.Contains(channelIDs, message.ChannelID) {
			topics.Add(topic)
		}
	}

	return topics
}

var _ Usecase = new(Service)
