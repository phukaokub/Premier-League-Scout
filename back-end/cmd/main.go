package main

import (
	"database/sql"
	"fmt"
	"net/http"

	_ "github.com/go-sql-driver/mysql"

	// "github.com/gorilla/mux"
	"back-end/internal/core/repository"
	"back-end/internal/core/services"
	"back-end/internal/handlers"
)

var db *sql.DB
var err error

func main() {

	InitDB()

	teamRepo := repository.NewTeamRepo(db)
	matchInfoRepo := repository.NewMatchInfoRepo(db)

	srv := services.NewService(teamRepo)
	matchInfoSrv := services.NewMatchInfoService(matchInfoRepo)

	httphdl := handlers.NewHTTPHandler(srv)
	matchInfohdl := handlers.NewMatchInfoHandler(matchInfoSrv)

	httphdl.SetupRoutes()
	matchInfohdl.SetupMatchInfoRoutes()

	http.ListenAndServe(":80", httphdl)
	fmt.Println("Server is running on :80")
}

func InitDB() {
	db, err = sql.Open("mysql", "root:root@tcp(localhost:3306)/eplScout") // fix this
	if err != nil {
		panic(err.Error())
	}
}
