package service

import (
	"github.com/thiduzz/vinyl-catalog/internal/model"
	"github.com/thiduzz/vinyl-catalog/internal/repository"
)

type CollectionServiceInterface interface {
	Paginate(page int, pageSize int) ([]model.Collection, error)
}

type CollectionService struct {
	repository *repository.CollectionRepository
}

func NewCollectionService(repository *repository.CollectionRepository) *CollectionService {
	return &CollectionService{repository: repository}
}

func (c CollectionService) Paginate(page int, pageSize int) ([]model.Collection, error) {
	return c.repository.Paginate(page, pageSize)
}
