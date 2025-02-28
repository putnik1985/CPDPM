package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	"math"
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
	////fmt.Printf("Input file: %s\n", filename)

	f, err := os.Open(filename)//f becomes *os.File
	if err != nil {
		  fmt.Fprintf(os.Stderr, "random: %v\n", err)
	}
        var eigenvalues []float64
	input := bufio.NewScanner(f)
	/////fmt.Printf("%T\n", input)
	for input.Scan() {
            line, fields := readline(input) 
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
            }
	    fmt.Printf("\n")
	}
        f.Close()
	fmt.Printf("Frequencies:\n");
	for index, value := range eigenvalues {
	    fmt.Printf("#%d = %g\n", index, math.Sqrt(value) / (2. * math.Pi))
	}
	return
}

func readline(s *bufio.Scanner) (string, []string) {
	line := s.Text()
	return line, strings.Fields(line)
}
