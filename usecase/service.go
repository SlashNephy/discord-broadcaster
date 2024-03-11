package usecase

import (
	"context"
	"slices"
	"time"

	"github.com/bwmarrin/discordgo"
	mapset "github.com/deckarep/golang-set/v2"

	"github.com/SlashNephy/discord-broadcaster/domain/entity"
)

type Service struct {
	config  *Config
	store   MessageStore
	discord DiscordClient
}

type Config struct {
	Topics map[entity.Topic]string `env:"TOPICS"`
}

func NewService(ctx context.Context, config *Config, store MessageStore, discord DiscordClient) *Service {
	discord.AddMessageCreateHandler(func(event *discordgo.MessageCreate) error {
		return store.PublishMessage(ctx, event.Message)
	})

	return &Service{
		config:  config,
		store:   store,
		discord: discord,
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
