package handlers

import (
	"encoding/json"
	"github.com/julienschmidt/httprouter"
	"github.com/thiduzz/vinyl-catalog/internal/handlers/utils"
	"net/http"
)

func (h *CollectionHandler) Get(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	collections, err := h.Service.Paginate(utils.ParsePaginationParams(r))
	jsonResponse, err := json.Marshal(collections)
	if err != nil {
		http.Error(w, "Fail to marshall response", 500)
	}
	_, err = w.Write(jsonResponse)
	if err != nil {
		http.Error(w, "Fail to write response", 500)
	}
}
