package repository

import (
	"github.com/thiduzz/vinyl-catalog/cmd/vinyl_catalog/app"
	"github.com/thiduzz/vinyl-catalog/internal/db"
	"github.com/thiduzz/vinyl-catalog/internal/model"
)

type CollectionRepositoryInterface interface {
	Paginate(page int, pageSize int) ([]model.Collection, error)
}

type CollectionRepository struct {
	db *app.DatabaseConnection
}

func NewCollectionRepository(databaseConnection *app.DatabaseConnection) *CollectionRepository {
	return &CollectionRepository{databaseConnection}
}

func (cr CollectionRepository) Paginate(page int, pageSize int) ([]model.Collection, error) {
	var collections []model.Collection
	tx := cr.db.Scopes(db.Paginate(page, pageSize)).
		Find(&collections)
	if tx.Error != nil {
		return nil, tx.Error
	}
	return collections, nil
}
