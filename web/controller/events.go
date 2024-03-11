package controller

import (
	"log/slog"
	"net/http"
	"strings"

	mapset "github.com/deckarep/golang-set/v2"
	"github.com/labstack/echo/v4"

	"github.com/SlashNephy/discord-broadcaster/domain/entity"
)

func (co *Controller) GetEvents(c echo.Context) error {
	rawTopics := c.QueryParam("topics")
	if rawTopics == "" {
		return echo.NewHTTPError(http.StatusBadRequest, "No topics specified")
	}

	topics := mapset.NewSet(strings.Split(rawTopics, ",")...)
	slog.InfoContext(c.Request().Context(), "connected", slog.Any("topics", topics))

	// write HTTP headers
	c.Response().Header().Set("Content-Type", "text/event-stream")
	c.Response().Header().Set("Cache-Control", "no-cache")
	c.Response().Header().Set("Connection", "keep-alive")

	events := make(chan *entity.EventFrame, 1)
	defer close(events)
	co.usecase.SubscribeEvent(c.Request().Context(), topics, events)

	for {
		select {
		case <-c.Request().Context().Done():
			return nil
		case event := <-events:
			if _, err := c.Response().Write([]byte(event.String())); err != nil {
				return err
			}

			slog.DebugContext(c.Request().Context(), "emit", slog.Any("frame", event))
			c.Response().Flush()
		}
	}
}
