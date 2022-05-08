package main

import (
	"log"
	"net/http"

	"github.com/thiduzz/vinyl-catalog/cmd/vinyl_catalog/handlers"
)

func main() {
	log.Println("started server on 0.0.0.0:8080, url: http://localhost:8080")

	http.HandleFunc("/up", handlers.UpHandler)

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
