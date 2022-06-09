package app

import (
	"github.com/thiduzz/vinyl-catalog/internal/handlers"
)

type App struct {
	*handlers.AppHandler
	*handlers.CollectionHandler
}

func NewApp(dbConnection *DatabaseConnection) *App {
	return &App{
		handlers.NewAppHandler(),
		handlers.NewCollectionHandler(dbConnection),
	}
}
