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

const (
	dofs = 6 
)

func main() {

	if (len(os.Args) < 2) {
		fmt.Println("usage: ./random file=input.dat")
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

	var A []float64
	var B []float64

	input = bufio.NewScanner(f)
	if input.Scan() {
	    line = input.Text()
	    fields = strings.Fields(line) 
        }

	n := len(fields)
	fmt.Printf("Dimension: %d\n\n", n)
	for i:=0; i<n; i++{
		for j:=0; j<n; j++{
			A = append(A, 0.)
		}
		B = append(B, 0.)
	}

	for j:=0; j<n; j++{
		A[0 * n + j], _ = strconv.ParseFloat(fields[j], 64)
	}
	B[0] = 1.

	i := 1
	for input.Scan() {
	    line = input.Text()
	    fields = strings.Fields(line) 

	    for j:=0; j<n; j++{
		A[i * n + j], _ = strconv.ParseFloat(fields[j], 64)
	    }
	    i++
	}
        f.Close()

        x := gauss(A, B)
	for i:=0; i<n; i++{
		for j:=0; j<n; j++{
			fmt.Printf("%12.6f,",A[i*n+j])
		}
		fmt.Printf("%24.6f, %16.6f\n", x[i], B[i])
	}

	 var check []float64
         for i:=0; i<n; i++ {
		 var s float64 = 0.
		 for j:=0; j<n; j++ {
			 s += A[i*n + j] * x[j]
		 }
		 check = append(check, s)
	 }
	 fmt.Printf("\nGauss Check:\n")
	 var sum float64 = 0.
	 for i:=0; i<n; i++{
		 sum = math.Pow(B[i] - check[i], 2.)
	 }
	 fmt.Printf("Norm: %.4f\n", math.Sqrt(sum))

	 iA := inverse(A)
	 fmt.Printf("\nInverse Matrix:\n")
         for i:=0; i<n; i++{
		 for j:=0; j<n; j++{
			 fmt.Printf("%24.6f,", iA[i*n+j])
		 }
		 fmt.Printf("\n")
	 }
}

func inverse(A []float64) []float64 {
	nxn := len(A)
        n := math.Sqrt(float64(nxn))
        dim := int(n)	

	var inv []float64
        for i:=0; i<nxn; i++ {
		inv = append(inv, 0.)
	}
        for k:=0; k<dim; k++ {
		var x []float64
		for i:=0; i<dim; i++{
		    x = append(x, 0.)
		}
		x[k] = 1.
		column := gauss(A, x)
		for j:=0; j<dim; j++{
			inv[j*dim+k] = column[j]
		}
	}
	return inv
}

func gauss(A []float64, B []float64) []float64 {
	 // A[i][j] = A[i*n+j]

	 n := len(B) // define number of equations assume A is square
	 var cA []float64
	 var cB []float64

	 for _, value := range A {
		 cA = append(cA, value)
	 }

	 for _, value := range B {
		 cB = append(cB, value)
	 }


	 for i:=0; i<n-1; i++{
		 for j:=i+1; j<n; j++{
			 factor := cA[j*n+i] / cA[i*n+i]
			 for k:=i; k<n; k++ {
				 cA[j*n+k] -= factor * cA[i*n+k]
			 }
			 cB[j] -= factor * cB[i]
		 }
	 }

	 var x []float64
	 for k:=0; k<n; k++ {
		 x = append(x, 0.)
	 }

	 for k:=n-1; k>=0; k--{
		 s := float64(0.0)
		 for j:=k+1; j<n; j++{
			 s += cA[k*n+j] * x[j]
		 }
		 x[k] = (cB[k] - s) / cA[k*n+k]
	 }
	 return x
}
