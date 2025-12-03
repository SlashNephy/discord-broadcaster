package config

import (
	"github.com/caarlos0/env/v11"
	_ "github.com/joho/godotenv/autoload"

	"github.com/SlashNephy/discord-broadcaster/infrastructure/external/discord"
	"github.com/SlashNephy/discord-broadcaster/infrastructure/redis"
	"github.com/SlashNephy/discord-broadcaster/logger"
	"github.com/SlashNephy/discord-broadcaster/usecase"
	"github.com/SlashNephy/discord-broadcaster/web"
)

type Config struct {
	LoggerConfig  logger.Config  `envPrefix:"LOG_"`
	ServerConfig  web.Config     `envPrefix:"SERVER_"`
	RedisConfig   redis.Config   `envPrefix:"REDIS_"`
	DiscordConfig discord.Config `envPrefix:"DISCORD_"`
	UsecaseConfig usecase.Config
}

func LoadConfig() (*Config, error) {
	var config Config
	if err := env.Parse(&config); err != nil {
		return nil, err
	}

	return &config, nil
}
