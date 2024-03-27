package usecase

import (
	"context"

	"github.com/bwmarrin/discordgo"
	mapset "github.com/deckarep/golang-set/v2"

	"github.com/SlashNephy/discord-broadcaster/domain/entity"
)

type Usecase interface {
	SubscribeEvent(ctx context.Context, topics mapset.Set[entity.Topic], channel chan<- *entity.EventFrame)
}

type MessageCreateHandler func(event *discordgo.MessageCreate) error

type DiscordClient interface {
	AddMessageCreateHandler(handler MessageCreateHandler)
	ExecuteWebhook(ctx context.Context, id, token string, params *discordgo.WebhookParams) error
	FindGuild(ctx context.Context, id string) (*discordgo.Guild, error)
	FindChannel(ctx context.Context, id string) (*discordgo.Channel, error)
	FindGuildMember(ctx context.Context, guildID string, userID string) (*discordgo.Member, error)
}

type MessageStore interface {
	PublishMessage(ctx context.Context, message *entity.Message) error
	SubscribeMessage(ctx context.Context, channel chan<- *entity.Message)
}
