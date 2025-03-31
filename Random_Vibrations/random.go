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
	var F []float64 //Mode shapes
	var sF []float64 //raw Mode shapes
	var grids_per_mode map[string]int64 = make(map[string]int64)
	var grids []int64
	var excitation []float64 // excitation vector 0 for the nonexcited, 1 - excited


        /*****************************************************************
	* Define as the Input from the console
	******************************************************************/
        /////var excitation_direction int = 1 // should read from the input
	var fmin float64 = 20. // initial frequency read from the input
	var fmax float64 = 2000. // maximum frequency read from the input
	var N int = 100 // number of the steps read from the input
        var ksi []float64 // vector of damping ration 1/2Q read from the input for each mode

        write_grids := true 

	input = bufio.NewScanner(f)
	for input.Scan() {
	    readline()
	    if strings.Contains(line, "$EIGENVALUE") {
	       value, err := strconv.ParseFloat(fields[2], 64)
	       if err != nil {
		       fmt.Fprintf(os.Stderr, "random: %v\n", err)
		       return
	       }
               eigenvalues = append(eigenvalues, value)
	       ksi = append(ksi, 0.05) // should read from the input for now use formula from Miles equations

	       for input.Scan() {
		  readline()
		  if strings.Contains(line, "$TITLE"){
	              write_grids = false
		      break
		   }
		  grid, _ := strconv.ParseInt(fields[0], 10, 64)
		  if write_grids {
		        grids = append(grids, grid)
	          }

		  grids_per_mode[fields[0]] = int64(dofs)
		    tx, _ := strconv.ParseFloat(fields[2], 64)
		    ty, _ := strconv.ParseFloat(fields[3], 64)
		    tz, _ := strconv.ParseFloat(fields[4], 64)

		    if input.Scan(){
		       readline()
		       rx, _ := strconv.ParseFloat(fields[1], 64)
		       ry, _ := strconv.ParseFloat(fields[2], 64)
		       rz, _ := strconv.ParseFloat(fields[3], 64)
	               ////fmt.Printf("%12d%24g%24g%24g%24g%24g%24g%24g\n", grid, value, tx, ty, tz, rx, ry, rz)
		       sF = append(sF, tx, ty, tz, rx, ry, rz)

		       var vec [dofs]float64 
		       vec[0] = 1.; vec[1] = 1.; vec[2] = 1.;

		       for i:=0; i<dofs; i++ {
		           excitation = append(excitation, vec[i])
		       }
	            }
	       }
            }
	}
        f.Close()
	
	fmt.Printf("\n\nGrid and DOFs:\n")
	for _, value := range grids {
		svalue := fmt.Sprintf("%d",value)
		fmt.Printf("grid: %16d, dofs: %12d\n", value, grids_per_mode[svalue])
	}
/***
	fmt.Printf("\n\nFile Grid\n")
	for _, value := range grids {
		fmt.Printf("%d\n", value)
	}
	fmt.Printf("\n\nModes:\n");
	for _, value := range eigenvalues {
		out := fmt.Sprintf("%.2fHz,", math.Sqrt(value) / (2. * math.Pi))
		fmt.Printf("%12s",out)
	}
	fmt.Printf("\n")
*****/
	var n int64
	var m int64
	    for _, dof := range grids_per_mode {
		    n += dof
	    }

	    m = int64(len(eigenvalues))

	for i:=0; i<int(m); i++{
		for j:=0; j<int(n); j++{
			F = append(F, 0.0)
		}
	}

	    for j:=0; j<int(m); j++ {
		    for i:=0; i<int(n); i++ {
			    F[i*int(m)+j] = sF[j*int(n)+i]
		    }
	    }
/*******************************************************
	    for i:=0; i<int(n); i++ {
		    for j:=0; j<int(m); j++ {
			    out := fmt.Sprintf("%.6f,",F[int(m)*i+j])
			    fmt.Printf("%12s",out)
		    }
		    fmt.Printf("\n")
	    }
	    ****************************************/
	    fmt.Printf("\nSummary:\n");
	    fmt.Printf("#Modes = %d, #DOFs = %d\n\n", m, n)
	    /*************************************
	    fmt.Println("\nExcitation")
	    for i:=0; i<int(n); i++ {
		    fmt.Println(excitation[i])
	    }
	    **************************************/

/******************************************************************************
	    A := []float64{2., 1., 1., 1., 1., 1., 1., 4., 1.}
	    B := []float64{6., 3., 0.}
            x := gauss(A, B)
	    fmt.Println(x)
	    iA := inverse(A)
	    fmt.Println("Initial Matrix:")
	    for i:=0; i<len(x); i++ {
		    for j:=0; j<len(x); j++ {
			    fmt.Printf("%12f,",A[i*len(x)+j])
		    }
		    fmt.Printf("\n")
	    }
	    fmt.Println("Inverse Matrix:")
	    for i:=0; i<len(x); i++ {
		    for j:=0; j<len(x); j++ {
			    fmt.Printf("%12f,",iA[i*len(x)+j])
		    }
		    fmt.Printf("\n")
	    }
	    fmt.Printf("Check:\n")
	    for i:=0; i<len(x); i++{
		    for j:=0; j<len(x); j++{
			    var s float64 = 0.
			    for k:=0; k<len(x); k++{
				    s+=A[i*len(x)+k] * iA[k*len(x)+j]
			    }
			    fmt.Printf("%12f,",s)
		    }
		    fmt.Printf("\n")
	    }
******************************************************************************/

        mFTFinvFT := FTFinvFT(int(m),int(n),F) // output is matrix m x n

        fmt.Println("\nDisplacement Velocity Acceleration Spectrum Density:")
	var a []float64
	for i:=0; i<int(m); i++ {
		var s float64 = 0.
		for j:=0; j<int(n); j++{
			s += mFTFinvFT[i*int(n)+j] * excitation[j]
		}
		a = append(a, s)
	}
	var df float64 = (fmax - fmin) / float64(N)
	for freq := fmin; freq <= fmax; freq += df {
	       w := 2. * math.Pi * freq
	       fmt.Printf("%12f,",freq)
	       fmt.Printf("%12.6g,",DSpectrum(w))
	       for k:=0; k<int(n); k++{ // calculate for each DOF
	           var Sx float64 = 0.
	           for mode, eig := range eigenvalues{
		       w0 := math.Sqrt(eig) 
		       Sq := DSpectrum(w) * a[mode] * a[mode] / (math.Pow(w0 * w0 - w * w, 2.) + 4. * w0 * w0 * ksi[mode] * ksi[mode] * w * w)
		       ///fmt.Println(a[mode],Sq,w0,w,ksi[mode])
                       Sx += F[k*int(m)+mode] * F[k*int(m)+mode] * Sq
	            }
	            fmt.Printf("%12.6f,",Sx)
               }
	       fmt.Printf("\n")
	}
	return
}

func readline(){
    line = input.Text()
    fields = strings.Fields(line)
}

func change_precision(in float64) float64 {
	out := fmt.Sprintf("%.6f",in)
	number, _:= strconv.ParseFloat(out, 64)
	return number
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
	 fmt.Printf("Gauss: cA symmetry: %t\n", symmetry(cA))

	 for i:=0; i<n-1; i++{
		 for j:=i+1; j<n; j++{
			 factor := cA[j*n+i] / cA[i*n+i]
			 for k:=i; k<n; k++{
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

func inverse(A []float64) []float64 {
	nxn := len(A)
        n := math.Sqrt(float64(nxn))
        dim := int(n)	
	//////fmt.Printf("A symmetry: %t\n", symmetry(A))
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

func FTF(m, n int, F []float64) []float64 {
	// m - number of modes - columns
	// n - number of DOFs - rows
        var output []float64 
	    for i:=0; i<m; i++{
		    for j:=0; j<m; j++{
			output = append(output, 0.)
		    }
	    }
	    for i:=0; i<m; i++{
		    for j:=0; j<m; j++{
			    var s float64 = 0.
			    for k:=0; k<n; k++{
				s+=F[k*m+i] * F[k*m+j]
			    }
			    output[i*m+j]  = s
		    }
	    }
	return output
}

func FTFinvFT(m, n int, F []float64) []float64 {
	// m - number of modes - columns
	// n - number of DOFs - rows
        var output []float64
            A := FTF(m, n, F)
	    /**************************************************************************
	    fmt.Printf("\n\nMatrix to Inverse:\n")
	    for i:=0; i<m; i++ {
		    for j:=0; j<m; j++{
			    fmt.Printf("%24.6f", A[i*m+j])
		    }
		    fmt.Printf("\n")
	    }
            ***********************************************************************/

	    iA := inverse(A) // m x m matrix

	    /**************************************************************************
	    fmt.Printf("\n\nInversed Matrix:\n")
	    for i:=0; i<m; i++ {
		    for j:=0; j<m; j++{
			    fmt.Printf("%24.6f", iA[i*m+j])
		    }
		    fmt.Printf("\n")
	    }
  
            ***********************************************************************/

	    /////fmt.Printf("\nMultiplication Inverse Check:\n")
       	    var sum float64 = 0.
	    for i:=0; i<m; i++{
		    for j:=0; j<m; j++{
			    var s float64 = 0.
			    for k:=0; k<m; k++{
				    s += A[i*m+k] * iA[k*m+j]
			    }
			    if (i != j){
				    sum += math.Abs(s)
			    }
		    }
	   }
	    fmt.Printf("\nSymmetry Check Summary:\n");
	    fmt.Printf("   Direct Matrix: %t\n", symmetry(A))
	    fmt.Printf("  Inverse Matrix: %t\n", symmetry(iA))

	    fmt.Printf("\nMatrix Product Check Summary:\n");
	    fmt.Printf("Off Diagonal Sum: %t\n\n", sum < 1.E-6)

	   for i:=0; i<m; i++ {
		   for j:=0; j<n; j++ {
			   output = append(output, 0.)
		   }
	   }

           for i:=0; i<m; i++ {
		   for j:=0; j<n; j++{
			   var s float64 = 0.
			   for k:=0; k<m; k++ {
				   s += iA[i*m+k] * F[j*m+k]
			   }
			   //fmt.Println(i, j, m, i*m+j)
			   output[i*n+j] = s
		   }
	   }
	return output
	// for the output
	// m - number of modes - rows
	// n - number of DOFs - columns
}

func DSpectrum(w float64) float64 {
	return 1.0
}

func max_elem(n, m int, A []float64) float64 {
	var maxel float64
	for i:=0; i<n; i++{
		for j:=0; j<m; j++ {
			if math.Abs(A[i*m+j]) > maxel {
				maxel = math.Abs(A[i*m+j])
			}
		}
	}
	return maxel
}

func symmetry(A []float64) bool {
	nxn := len(A)
	n := int(math.Sqrt(float64(nxn)))
	for i:=0; i<n; i++{
		for j:=i+1; j<n; j++ {
			if math.Abs(A[i*n+j] - A[j*n+i]) > 1.E-6 {
				return false
			}
		}
	}
	return true
}
