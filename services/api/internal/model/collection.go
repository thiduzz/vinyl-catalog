package model

import (
	"gorm.io/gorm"
	"time"
)

type Collection struct {
	ID        uint           `gorm:"primaryKey" json:"id"`
	Name      string         `gorm:"primaryKey" json:"name"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"deleted_at,omitempty"`
}
