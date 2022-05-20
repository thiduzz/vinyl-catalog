package app

import (
	"github.com/julienschmidt/httprouter"
	"net/http"
)

type Server struct {
	*http.Server
	*App
}

func NewServer(address string, app *App) *Server {
	return &Server{&http.Server{Addr: address}, app}
}

func (sv *Server) Start() error {
	routing, err := sv.setRouting()
	if err != nil {
		return err
	}
	sv.Handler = routing
	if err := sv.ListenAndServe(); err != nil {
		return err
	}
	return nil
}

func (sv *Server) setRouting() (*httprouter.Router, error) {
	router := httprouter.New()
	router.GET("/up", sv.Up)
	router.GET("/v1/collections", sv.CollectionHandler.Get)
	return router, nil
}
