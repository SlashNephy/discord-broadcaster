package logger

import (
	"log/slog"
	"os"
)

type Config struct {
	Level slog.Level `env:"LEVEL" envDefault:"info"`
}

func NewLogger(config *Config) *slog.Logger {
	return slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: config.Level,
	}))
}

func InitLogger(config *Config) {
	slog.SetDefault(NewLogger(config))
}
