package discord

import (
	"context"
	"errors"
	"fmt"
	"log/slog"

	"github.com/bwmarrin/discordgo"

	"github.com/SlashNephy/discord-broadcaster/usecase"
)

type Service struct {
	session *discordgo.Session
}

type Config struct {
	Token string `env:"TOKEN,notEmpty"`
}

func NewService(config *Config) (*Service, error) {
	discord, err := discordgo.New(config.Token)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to Discord: %w", err)
	}

	discord.UserAgent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/1.0.1059 Chrome/108.0.5359.215 Electron/22.3.26 Safari/537.36"
	discord.Identify.Intents = discordgo.IntentsAllWithoutPrivileged | discordgo.IntentsMessageContent

	discord.AddHandler(func(_ *discordgo.Session, r *discordgo.Ready) {
		slog.Info("Connected to Discord")
	})

	if err := discord.Open(); err != nil {
		return nil, fmt.Errorf("failed to connect to Discord: %w", err)
	}

	return &Service{
		session: discord,
	}, nil
}

func (s *Service) AddMessageCreateHandler(handler usecase.MessageCreateHandler) {
	s.session.AddHandler(func(_ *discordgo.Session, event *discordgo.MessageCreate) {
		slog.Debug("MessageCreate", slog.Any("event", event))

		if err := handler(event); err != nil {
			slog.Error("failed to handle message create event", slog.Any("error", err))
		}
	})
}

func (s *Service) ExecuteWebhook(ctx context.Context, id, token string, params *discordgo.WebhookParams) error {
	_, err := s.session.WebhookExecute(id, token, false, params)
	if err != nil {
		return fmt.Errorf("failed to execute webhook: %w", err)
	}

	return nil
}

func (s *Service) FindGuild(ctx context.Context, id string) (*discordgo.Guild, error) {
	guild, err := s.session.State.Guild(id)
	if err != nil {
		if errors.Is(err, discordgo.ErrStateNotFound) {
			return s.session.Guild(id)
		}

		return nil, err
	}

	return guild, nil
}

func (s *Service) FindChannel(ctx context.Context, id string) (*discordgo.Channel, error) {
	channel, err := s.session.State.Channel(id)
	if err != nil {
		if errors.Is(err, discordgo.ErrStateNotFound) {
			return s.session.Channel(id)
		}

		return nil, err
	}

	return channel, nil
}

func (s *Service) FindGuildMember(ctx context.Context, guildID string, userID string) (*discordgo.Member, error) {
	member, err := s.session.State.Member(guildID, userID)
	if err != nil {
		if errors.Is(err, discordgo.ErrStateNotFound) {
			return s.session.GuildMember(guildID, userID)
		}

		return nil, err
	}

	return member, nil
}

var _ usecase.DiscordClient = new(Service)
