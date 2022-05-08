package handlers

import (
	"io"
	"net/http"
)

func UpHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	io.WriteString(w, `{"status": "I'm up!"}`)
}
