package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func main() {
	log.Println("started server on 0.0.0.0:8080, url: http://localhost:8080")

	http.HandleFunc("/up", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode("I'm up!")
	})

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
