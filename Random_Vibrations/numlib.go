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
	tolerance = 1.E-6
	max_iter = 1.E+6
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
	}

	for j:=0; j<n; j++{
		A[0 * n + j], _ = strconv.ParseFloat(fields[j], 64)
	}

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

	 fmt.Printf("\nInput Matrix:\n")
         for i:=0; i<n; i++{
		 for j:=0; j<n; j++{
			 fmt.Printf("%24.6f,", A[i*n+j])
		 }
		 fmt.Printf("\n")
	 }

	 iA := inverse(A)
	 fmt.Printf("\nInverse Matrix:\n")
         for i:=0; i<n; i++{
		 for j:=0; j<n; j++{
			 fmt.Printf("%24.6f,", iA[i*n+j])
		 }
		 fmt.Printf("\n")
	 }

	    fmt.Printf("\nMultiplication Inverse Check:\n")
       	    var sum float64 = 0.
	    for i:=0; i<n; i++{
		    for j:=0; j<n; j++{
			    var s float64 = 0.
			    for k:=0; k<n; k++{
				    s += A[i*n+k] * iA[k*n+j]
			    }
			    fmt.Printf("%24.6f,", s)
			    if (i != j){
				    sum += math.Abs(s)
			    }
		    }
		    fmt.Printf("\n")
	   }

	   fmt.Printf("\nSum of off Diagonal Elements(must be within tolerance): %f,\n", sum)
           var jA []float64
	   for i:=0; i<n; i++ {
		   for j:=0; j<n; j++ {
			   jA = append(jA, A[i*n+j])
		   }
	   }

	   fmt.Printf("\nJacobi Eigenvalues:\n");
	   vec := jacobi(jA)
	   for i:=0; i<n; i++ {
		   for j:=0; j<n; j++{
			   fmt.Printf("%24.6f,", jA[i*n+j])
		   }
		   fmt.Printf("\n")
	   }

	   fmt.Printf("\nJacobi Eigenvectors:\n");
	   for i:=0; i<n; i++ {
		   for j:=0; j<n; j++{
			   fmt.Printf("%24.6f,", vec[i*n+j])
		   }
		   fmt.Printf("\n")
	   }

	   fmt.Printf("\nJacobi Check Vector Orthogonality:\n")
	   for i:=0; i<n; i++ {
		   for j:=0; j<n; j++ {
			   var s float64
			   for k:=0; k<n; k++ {
				   s += vec[k*n+i]*vec[k*n+j]
			   }
			   fmt.Printf("%24.6f,",s)
		   }
		   fmt.Printf("\n")
	   }

	   fmt.Printf("\nJacobi Check XT.A.X:\n")
	   for i:=0; i<n; i++ {
		   for j:=0; j<n; j++ {
			   var s float64
			   for k:=0; k<n; k++ {
				   for t:=0; t<n; t++ {
				       s += vec[k*n+i] * A[k*n+t] * vec[t*n+j]
			           }
			   }
			   fmt.Printf("%24.6f,",s)
		   }
		   fmt.Printf("\n")
	   }
	   fmt.Printf("\nJacobi Invesre Calculation:\n")
           var invjA []float64
	   for i:=0; i<n; i++ {
		   for j:=0; j<n; j++ {
			   invjA = append(invjA, 0.)
		   }
		   invjA[i*n+i] = 1. / jA[i*n+i]
	   }

	   for i:=0; i<n; i++ {
		   for j:=0; j<n; j++ {
			   var s float64
			   for k:=0; k<n; k++ {
				   for t:=0; t<n; t++ {
				       s += vec[i*n+k] * invjA[k*n+t] * vec[j*n+t]
			           }
			   }
			   fmt.Printf("%24.6f,",s)
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


func jacobi(A []float64) []float64 {

     var eigenvectors []float64

     nxn := len(A)
     n := int(math.Sqrt(float64(nxn)))
     var iter int64

     for i:=0; i<n; i++ {
	     for j:=0; j<n; j++ {
	         eigenvectors = append(eigenvectors, 0.)
             }
	     eigenvectors[i*n + i] = 1.
     }

     a, i, j := max_off_diagonal(A)
     for a>tolerance && iter<max_iter {
	     aii := A[i*n+i]
	     ajj := A[j*n+j]
	     aij := A[i*n+j]
	       ///fmt.Printf("aii=%f\n", (aii-ajj)*aij)

	       d := math.Sqrt((aii-ajj)*(aii-ajj) + 4. * aij * aij)
	       c := math.Sqrt(1./2. * (1. + math.Abs(aii-ajj)/d))
	       s := sign(aij * (aii - ajj)) * math.Sqrt(1./2. * (1. - math.Abs(aii - ajj) / d))
	       ///fmt.Printf("c=%f, s=%f,\n", c, s)

	       A[i*n+i] = c*c*aii + 2.*c*s*aij + s*s*ajj
	       A[j*n+j] = s*s*aii - 2.*c*s*aij + c*c*ajj

	       A[i*n+j] = 0.
	       A[j*n+i] = 0.

	       for k:=0; k<n; k++ {
		       aki := A[k*n+i]
		       akj := A[k*n+j]

		       if (k != i && k != j) {
                           A[k*n+i] =  c*aki + s*akj
			   A[k*n+j] = -s*aki + c*akj

                           A[i*n+k] = A[k*n+i]
			   A[j*n+k] = A[k*n+j]
		       }

		       eki := eigenvectors[k*n+i]
		       ekj := eigenvectors[k*n+j]
		       eigenvectors[k*n+i] =  c*eki + s*ekj
		       eigenvectors[k*n+j] = -s*eki + c*ekj
	       }
	       iter++
               a, i, j = max_off_diagonal(A)
     }

    return eigenvectors
}

func max_off_diagonal(A []float64) (float64, int, int) {
	nxn := len(A)
	n := int(math.Sqrt(float64(nxn)))
	var maximum float64 = 0.
        var row, col int

  	for i:=0; i<n; i++{
		for j:=i+1; j<n; j++ {
			if math.Abs(A[i*n+j]) > maximum {
				maximum = math.Abs(A[i*n+j])
				row = i
				col = j
			}
		}
	}
	return maximum, row, col
}

func sign(x float64) float64 {
	if x>=0 {
		return  1.
	} else {
		return -1. 
	}
}
