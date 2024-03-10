package controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"

	"github.com/SlashNephy/discord-broadcaster/usecase"
)

type Controller struct {
	usecase usecase.Usecase
}

func NewController(usecase usecase.Usecase) *Controller {
	return &Controller{
		usecase: usecase,
	}
}

func (co *Controller) RegisterRoutes(e *echo.Echo) {
	e.GET("/status", co.GetStatus)
	e.GET("/events", co.GetEvents, middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins:  []string{"*"},
		AllowMethods:  []string{http.MethodGet},
		ExposeHeaders: []string{"Content-Type"},
	}))
}
