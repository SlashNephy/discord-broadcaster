package main

import (
	"context"
	"errors"
	"log"
	"net/http"
	"os/signal"
	"syscall"

	"github.com/SlashNephy/discord-broadcaster/config"
	"github.com/SlashNephy/discord-broadcaster/infrastructure/redis"
	"github.com/SlashNephy/discord-broadcaster/logger"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("failed to load config: %v", err)
	}

	logger.InitLogger(&cfg.LoggerConfig)

	red, err := redis.Connect(&cfg.RedisConfig)
	if err != nil {
		log.Fatalf("failed to connect to redis: %v", err)
	}

	server, err := InitializeServer(ctx, cfg, red)
	if err != nil {
		log.Fatalf("failed to initialize server: %v", err)
	}

	go func() {
		if err = server.Start(); err != nil {
			if !errors.Is(err, http.ErrServerClosed) {
				log.Fatalf("failed to listen and serve: %v", err)
			}
		}
	}()

	<-ctx.Done()
	log.Println("got interruption signal")

	if err = server.Stop(context.TODO()); err != nil {
		log.Fatalf("failed to shutdown server: %v", err)
	}
}
