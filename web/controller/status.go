package controller

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func (co *Controller) GetStatus(c echo.Context) error {
	return c.JSON(http.StatusOK, map[string]any{
		"success": true,
	})
}
