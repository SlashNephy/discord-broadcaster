package redis

import "github.com/redis/go-redis/v9"

type Config struct {
	URL string `env:"URL,notEmpty"`
}

func Connect(config *Config) (*redis.Client, error) {
	opt, err := redis.ParseURL(config.URL)
	if err != nil {
		return nil, err
	}

	return redis.NewClient(opt), nil
}
