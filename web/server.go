package web

import (
	"context"
	"log/slog"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"

	"github.com/SlashNephy/discord-broadcaster/web/controller"
)

type Server struct {
	e          *echo.Echo
	controller *controller.Controller
	config     *Config
}

type Config struct {
	Address string `env:"ADDRESS" envDefault:":8080"`
}

func NewServer(config *Config, controller *controller.Controller) (*Server, error) {
	e := echo.New()
	e.IPExtractor = echo.ExtractIPFromXFFHeader()

	e.Use(
		middleware.RequestLoggerWithConfig(middleware.RequestLoggerConfig{
			Skipper: func(c echo.Context) bool {
				// ヘルスチェックはログしない
				return c.Request().RequestURI == "/status"
			},
			LogURI:       true,
			LogStatus:    true,
			LogLatency:   true,
			LogMethod:    true,
			LogRemoteIP:  true,
			LogUserAgent: true,
			LogValuesFunc: func(c echo.Context, v middleware.RequestLoggerValues) error {
				slog.InfoContext(c.Request().Context(), "request",
					slog.Int("status", v.Status),
					slog.String("method", v.Method),
					slog.String("uri", v.URI),
					slog.String("remote_ip", v.RemoteIP),
					slog.String("user_agent", v.UserAgent),
				)
				return nil
			},
		}),
		middleware.Secure(),
		middleware.Recover(),
	)

	controller.RegisterRoutes(e)

	return &Server{
		e:          e,
		controller: controller,
		config:     config,
	}, nil
}

func (s *Server) Start() error {
	return s.e.Start(s.config.Address)
}

func (s *Server) Stop(ctx context.Context) error {
	return s.e.Shutdown(ctx)
}
