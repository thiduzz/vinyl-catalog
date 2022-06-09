package handlers

import (
	"github.com/thiduzz/vinyl-catalog/cmd/vinyl_catalog/app"
	"github.com/thiduzz/vinyl-catalog/internal/repository"
	"github.com/thiduzz/vinyl-catalog/internal/service"
)

type CollectionHandler struct {
	Service *service.CollectionService
}

func NewCollectionHandler(databaseConnection *app.DatabaseConnection) *CollectionHandler {
	return &CollectionHandler{service.NewCollectionService(repository.NewCollectionRepository(databaseConnection))}
}
