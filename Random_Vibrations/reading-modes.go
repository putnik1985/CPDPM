package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	//"math"
	//"math/cmplx"
)

var line string
var fields []string
var input *bufio.Scanner
var filename string

const (
	dofs = 6 
	tolerance = 1.E-24
	max_iter = 1.E+6
)

func main() {

	if (len(os.Args) < 2) {
		fmt.Println("usage: ./modes file=input")
		return
	}

	data := make(map[string]string)

	/****************************
	for _, argument := range os.Args {
		fmt.Println(argument)
	}
	****************************/

	for _, value := range os.Args {
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

	filename = data["file"]
	////fmt.Printf("Input file: %s\n", filename)

	f, err := os.Open(filename)//f becomes *os.File
	if err != nil {
		  fmt.Fprintf(os.Stderr, "random: %v\n", err)
	}

	var F [][]float64 //Mode shapes
        var mode []float64
	var frequencies []float64

	input = bufio.NewScanner(f)
	for input.Scan() {
	    readline()
	    ///fmt.Println(line, fields)
	    var disp float64
	    disp, _ = strconv.ParseFloat(fields[1], 64)
	    if strings.Contains(line, "Frequency") {
		    frequencies = append(frequencies, disp)
		    if len(mode) > 0 {
			    //fmt.Println(mode)
			    F = append(F, mode)
			    mode = nil
		    }
	    } else {
		    mode = append(mode, disp)
	    }
        }
        f.Close()
        //fmt.Println(mode)
        F = append(F, mode)
        mode = nil
	fmt.Println("Modes")
        fmt.Println(F)
	fmt.Println("\nFrequencies")
	fmt.Println(frequencies)
	return
}

func readline(){
    line = input.Text()
    fields = strings.Fields(line)
}

