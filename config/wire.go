package config

import "github.com/google/wire"

var Set = wire.NewSet(
	wire.FieldsOf(
		new(*Config),
		"LoggerConfig",
		"ServerConfig",
		"DiscordConfig",
		"RedisConfig",
		"UsecaseConfig",
	),
)
