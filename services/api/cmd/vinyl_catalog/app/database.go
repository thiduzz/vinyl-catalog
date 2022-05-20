package app

import (
	mysqldriver "github.com/go-sql-driver/mysql"
	"github.com/thiduzz/vinyl-catalog/internal/model"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"log"
	"os"
	"time"
)

type DatabaseConnection struct {
	*gorm.DB
}

func NewMySqlDatabaseConnection(config *mysqldriver.Config) (*DatabaseConnection, error) {
	dbConnection, err := gorm.Open(mysql.New(mysql.Config{
		DSN:                       config.FormatDSN(), // data source name
		DefaultStringSize:         256,                // default size for string fields
		DisableDatetimePrecision:  true,               // disable datetime precision, which not supported before MySQL 5.6
		DontSupportRenameIndex:    true,               // drop & create when rename index, rename index not supported before MySQL 5.7, MariaDB
		DontSupportRenameColumn:   true,               // `change` when rename column, rename column not supported before MySQL 8, MariaDB
		SkipInitializeWithVersion: false,              // auto configure based on currently MySQL version
	}), &gorm.Config{
		DisableForeignKeyConstraintWhenMigrating: true,
		Logger:                                   NewGormLogger(logger.Info),
	})
	if err != nil {
		return nil, err
	}
	return &DatabaseConnection{dbConnection}, nil
}

func NewGormLogger(level logger.LogLevel) logger.Interface {
	return logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags), // io writer
		logger.Config{
			SlowThreshold:             time.Second, // Slow SQL threshold
			LogLevel:                  level,       // Log level
			IgnoreRecordNotFoundError: true,        // Ignore ErrRecordNotFound error for logger
			Colorful:                  true,        // Disable color
		},
	)
}

func (dc *DatabaseConnection) Init() error {
	return dc.DB.AutoMigrate(&model.Collection{})
}
