//go:build wireinject
// +build wireinject

package main

import (
	"context"

	"github.com/google/wire"
	"github.com/redis/go-redis/v9"

	"github.com/SlashNephy/discord-broadcaster/config"
	"github.com/SlashNephy/discord-broadcaster/infrastructure/external"
	"github.com/SlashNephy/discord-broadcaster/infrastructure/repository"
	"github.com/SlashNephy/discord-broadcaster/usecase"
	"github.com/SlashNephy/discord-broadcaster/web"
)

func InitializeServer(ctx context.Context, cfg *config.Config, redis *redis.Client) (*web.Server, error) {
	wire.Build(
		config.Set,
		repository.Set,
		external.Set,
		usecase.Set,
		web.Set,
	)

	return nil, nil
}
