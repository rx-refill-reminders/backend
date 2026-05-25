package envconfig

import "github.com/caarlos0/env/v11"

type Config struct {
	Env       string `env:"ENV"`
	ServerURL string `env:"SERVER_URL"`
}

func Load() (*Config, error) {
	cfg := Config{}
	err := env.Parse(&cfg)
	if err != nil {
		return nil, err
	}

	return &cfg, nil
}
