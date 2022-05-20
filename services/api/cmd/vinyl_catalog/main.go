package main

import (
	"fmt"
	driver "github.com/go-sql-driver/mysql"
	"github.com/thiduzz/vinyl-catalog/cmd/vinyl_catalog/app"
	"log"
	"net/http"
)

func main() {
	log.Println("Setting Database connection...")
	databaseConnection, err := app.NewMySqlDatabaseConnection(databaseConfig())
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Setting Application and Dependencies...")
	application := app.NewApp(databaseConnection)
		log.Fatal(err)
	}
}

func databaseConfig() *driver.Config {
	config := driver.NewConfig()
	config.User = os.Getenv("DB_USER_NAME")
	config.Passwd = os.Getenv("DB_USER_PASSWORD")
	config.Net = "tcp"
	config.Addr = fmt.Sprintf("%s:%s", os.Getenv("DB_HOST"), os.Getenv("DB_PORT"))
	config.DBName = os.Getenv("DB_SCHEMA_NAME")
	config.Params = map[string]string{"charset": "utf8"}
	config.Loc = time.UTC
	config.ParseTime = true
	return config
}
