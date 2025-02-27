package main

import(
	"fmt"
	"os"
	"strings"
)

func main() {

	if (len(os.Args) < 2) {
		fmt.Println("usage: ./random file=input.pch")
		return
	}
	data := make(map[string]string)

	/****************************
	for _, argument := range os.Args {
		fmt.Println(argument)
	}
	****************************/

	for _, value := range os.Args {
		fmt.Println(value)
		parts := strings.Split(value, "=")
		if (len(parts) > 1) {
			 data[parts[0]] = parts[1]
		 } 
	}

	/******************************************************
	fmt.Println("Input data:")
	for name, value := range data {
		fmt.Printf("%s=%s\n",name, value)
	}
	*******************************************************/
	filename := data["file"]
	fmt.Printf("file: %s\n", filename)
	return
}
