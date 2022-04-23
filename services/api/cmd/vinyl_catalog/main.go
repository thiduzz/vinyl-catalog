package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	log.Println("Starting server at port 8080")

	http.HandleFunc("/up", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "God save the Queen!")
	})

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
