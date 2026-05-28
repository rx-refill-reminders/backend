package handler

import (
	"fmt"

	"github.com/danielgtaylor/huma/v2"
	"github.com/rx-refill-reminders/backend/api/src/internal/envconfig"
	"github.com/rx-refill-reminders/lambda-go/humaserverless"
)

type Handler interface {
	huma.API
}

type handler struct {
	envconfig.Config

	huma.API
}

func NewHandlerFromEnv() (Handler, error) {
	cfg, err := envconfig.Load()
	if err != nil {
		return nil, fmt.Errorf("error parsing environment: %w", err)
	}

	return NewHandler(*cfg), nil
}

func NewHandler(cfg envconfig.Config) Handler {
	h := &handler{
		Config: cfg,
	}

	h.API = humaserverless.NewServerless(humaserverless.ApiOpts{
		Name:    "Rx Refill Reminders Backend API",
		Version: "undefined",

		Servers: []*huma.Server{
			{
				Description: h.Env,
				URL:         h.ServerURL,
			},
		},
	})

	huma.AutoRegister(h.API, h)

	return h
}
