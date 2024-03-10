package web

import (
	"github.com/google/wire"

	"github.com/SlashNephy/discord-broadcaster/web/controller"
)

var Set = wire.NewSet(
	NewServer,
	controller.NewController,
)
