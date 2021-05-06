package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/mattn/go-oci8"
)

func main() {
	db, err := sql.Open("oci8", "TEST/1234@localhost:1521/ORCL18")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	//res, err := db.Query("execute insertar_depto(:1,:2,:3) ", 11, "Baja Verapaz", "Occidente")
	//----SINTAXIS

	res, err := db.Exec("begin insertar_depto(:1,:2,:3);end;", 22, "Guatemala", "Interior")
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(res)

	//---llamada a funcion
	if err != nil {
		log.Fatal(err)
	}
	rows, err := db.Query("select producto_mas_vendido from dual")
	if err != nil {
		log.Fatal(err)
	}

	for rows.Next() {
		var i string
		err = rows.Scan(&i)
		if err != nil {
			log.Fatal(err)
		}
		println(i)

	}

	//fmt.Println(res.LastInsertId())
}
