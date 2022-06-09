package handlers

import (
	"fmt"
	"github.com/julienschmidt/httprouter"
	"net/http"
)

type AppHandler struct{}

func NewAppHandler() *AppHandler {
	return &AppHandler{}
}

func (receiver *AppHandler) Up(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprintf(w, "God save the Queen!")
}
