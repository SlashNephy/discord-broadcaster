package external

import (
	"github.com/google/wire"

	"github.com/SlashNephy/discord-broadcaster/infrastructure/external/discord"
	"github.com/SlashNephy/discord-broadcaster/usecase"
)

var Set = wire.NewSet(
	discord.NewService,
	wire.Bind(new(usecase.DiscordClient), new(*discord.Service)),
)
