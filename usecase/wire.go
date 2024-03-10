package usecase

import "github.com/google/wire"

var Set = wire.NewSet(
	NewService,
	wire.Bind(new(Usecase), new(*Service)),
)
