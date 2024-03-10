package repository

import (
	"github.com/google/wire"

	"github.com/SlashNephy/discord-broadcaster/usecase"
)

var Set = wire.NewSet(
	NewMessageRepository,
	wire.Bind(new(usecase.MessageStore), new(*MessageRepository)),
)
