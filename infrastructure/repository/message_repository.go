package repository

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/redis/go-redis/v9"

	"github.com/SlashNephy/discord-broadcaster/domain/entity"
	"github.com/SlashNephy/discord-broadcaster/usecase"
)

const MessageChannel = "message"

type MessageRepository struct {
	redis *redis.Client
}

func NewMessageRepository(redis *redis.Client) *MessageRepository {
	return &MessageRepository{
		redis: redis,
	}
}

func (r *MessageRepository) PublishMessage(ctx context.Context, message *entity.Message) error {
	payload, err := json.Marshal(message)
	if err != nil {
		return fmt.Errorf("failed to marshal message: %w", err)
	}

	_, err = r.redis.Publish(ctx, MessageChannel, payload).Result()
	return err
}

func (r *MessageRepository) SubscribeMessage(ctx context.Context, channel chan<- *entity.Message) {
	subscription := r.redis.Subscribe(ctx, MessageChannel)

	go func() {
		defer subscription.Close()

		for m := range subscription.Channel() {
			var message entity.Message
			if err := json.Unmarshal([]byte(m.Payload), &message); err != nil {
				continue
			}

			select {
			case <-ctx.Done():
				return
			case channel <- &message:
			}
		}
	}()
}

var _ usecase.MessageStore = new(MessageRepository)
