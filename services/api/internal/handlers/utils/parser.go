package utils

import (
	"net/http"
	"strconv"
)

func ParsePaginationParams(r *http.Request) (int, int) {
	q := r.URL.Query()

	page, _ := strconv.Atoi(q.Get("page"))
	if page == 0 {
		page = 1
	}

	pageSize, _ := strconv.Atoi(q.Get("page_size"))
	switch {
	case pageSize > 100:
		pageSize = 100
	case pageSize <= 0:
		pageSize = 10
	}
	return page, pageSize
}
