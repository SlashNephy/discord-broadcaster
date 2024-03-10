package controller

import (
	"net/http"
	"strings"

	mapset "github.com/deckarep/golang-set/v2"
	"github.com/labstack/echo/v4"

	"github.com/SlashNephy/discord-broadcaster/domain/entity"
)

func (co *Controller) GetEvents(c echo.Context) error {
	topics := mapset.NewSet(strings.Split(c.QueryParam("topics"), ",")...)
	if topics.IsEmpty() {
		return echo.NewHTTPError(http.StatusBadRequest, "No topics specified")
	}

	// write HTTP headers
	c.Response().Header().Set("Content-Type", "text/event-stream")
	c.Response().Header().Set("Cache-Control", "no-cache")
	c.Response().Header().Set("Connection", "keep-alive")

	events := make(chan *entity.EventFrame, 1)
	defer close(events)
	co.usecase.SubscribeEvent(c.Request().Context(), topics, events)

	for event := range events {
		select {
		case <-c.Request().Context().Done():
			return nil
		default:
			if _, err := c.Response().Write([]byte(event.String())); err != nil {
				return err
			}

			c.Response().Flush()
		}
	}

	return nil
}
