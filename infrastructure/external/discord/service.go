package discord

import (
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

var _ usecase.DiscordClient = new(Service)
