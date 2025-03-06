package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	"math"
)

var line string
var fields []string
var input *bufio.Scanner
var filename string

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
        var eigenvalues []float64
	////var F []float64 //Mode shapes

	input = bufio.NewScanner(f)
	/////fmt.Printf("%T\n", input)
	for input.Scan() {
	    ///line = input.Text()
	    ///fields = strings.Fields(line) 
            /////line, fields := readline(input) 
	    readline()
	    if strings.Contains(line, "$EIGENVALUE") {
	       ////fields := strings.Fields(line)
	       /*****************************************************************
	       for index, value := range fields {
	           fmt.Printf("%d = %s, ", index, value)
	       }
	       fmt.Printf("\n");
	       ******************************************************************/
	       value, err := strconv.ParseFloat(fields[2], 64)
	       if err != nil {
		       fmt.Fprintf(os.Stderr, "random: %v\n", err)
		       return
	       }
               eigenvalues = append(eigenvalues, value)
	       for input.Scan() {
		  readline()
                  //line = input.Text()
		  if strings.Contains(line, "$TITLE"){
		      break
		   }

		  //fields = strings.Fields(line)
		  grid, _ := strconv.ParseInt(fields[0], 10, 64)
		    tx, _ := strconv.ParseFloat(fields[2], 64)
		    ty, _ := strconv.ParseFloat(fields[3], 64)
		    tz, _ := strconv.ParseFloat(fields[4], 64)

		    if input.Scan(){
                       //line = input.Text()
		       //fields = strings.Fields(line)
		       readline()
		       rx, _ := strconv.ParseFloat(fields[1], 64)
		       ry, _ := strconv.ParseFloat(fields[2], 64)
		       rz, _ := strconv.ParseFloat(fields[3], 64)
	               fmt.Printf("%12d%24g%24g%24g%24g%24g%24g%24g\n", grid, value, tx, ty, tz, rx, ry, rz)
	            }

	       }
	       fmt.Println("Next Eigenvalue")
            }
	}
        f.Close()
	fmt.Printf("Frequencies:\n");
	for index, value := range eigenvalues {
	    fmt.Printf("#%d = %g\n", index, math.Sqrt(value) / (2. * math.Pi))
	}
	return
}

func readline(){
    line = input.Text()
    fields = strings.Fields(line)
}
