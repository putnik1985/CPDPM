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

	if (len(os.Args) < 4) {
		fmt.Println("usage: ./random modes=input stress=stressfile command=command-file")
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

            F := read_modes(data["modes"])
	    m := len(F)
	    n := len(F[0])
	    fmt.Printf("#Modes = %d, #DOFs = %d\n\n", m, n)

            S := read_modes(data["stress"])
	    m = len(S)
	    n = len(S[0])
	    fmt.Printf("#Modes = %d, #DOFs = %d\n\n", m, n)

    /***************************
        for i:=0; i<int(n); i++{
		excitation = append(excitation, 0.)
	}
		excitation[0] = 1.
		excitation[1] = 1.
		excitation[2] = 1.
	}

	    fmt.Println("\nExcitation")
	    for i:=0; i<int(n); i++ {
		    fmt.Println(excitation[i])
	    }

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

        fmt.Println("\nAcceleration Spectrum Density:,")
	fmt.Println("Excitation Vector:,")
	var a []float64
	for i:=0; i<int(m); i++ {
		var s float64 = 0.
		for j:=0; j<int(n); j++{
			s += F[j*int(m)+i] * excitation[j]
		}
		a = append(a, s)
	////////fmt.Printf("%12g,",s)
	}
	fmt.Printf("\n")
        /////return
	var rms []float64
	for i:=0; i<int(n); i++ {
	rms = append(rms, 0.)
	}
	var df float64 = (fmax - fmin) / float64(N)
	for freq := fmin; freq <= fmax; freq += df {
	       w := 2. * math.Pi * freq
	       fmt.Printf("%12f,",freq)
	       fmt.Printf("%12.6g,",FSpectrum(w))
	       for k:=0; k<int(n); k++{ // calculate for each DOF
	           var Sx float64 = 0.
	           for mode, eig := range eigenvalues{
		       w0 := math.Sqrt(math.Abs(eig))
                       ///fmt.Println(w0) 			   
		       Sq := FSpectrum(w) * a[mode] * a[mode] * w * w * w * w/ (math.Pow(w0 * w0 - w * w, 2.) + 4. * w0 * w0 * ksi[mode] * ksi[mode] * w * w)
                       Sx += F[k*int(m) + mode] * F[k*int(m) + mode] * Sq
	            }
	            fmt.Printf("%12.6f,",Sx)
				rms[k] += Sx * df 
               }
	       fmt.Printf("\n")
	}
	fmt.Printf("\nRMS:\n")
	fmt.Printf("%25s,","Total:")
	for _, val := range rms {
	    fmt.Printf("%12.6f,", math.Sqrt(val))
	}
	fmt.Printf("\n")
        fmt.Println("\nAcceleration Harmonic Analysis:")
	for freq := fmin; freq <= fmax; freq += df {
	       w := 2. * math.Pi * freq
	       fmt.Printf("%12f,",freq)
	       fmt.Printf("%12.6g,",Force(w))
	       for k:=0; k<int(n); k++{ // calculate for each DOF
	           var Sx complex128 = 0.+0i
	           for mode, eig := range eigenvalues{
		           w0 := math.Sqrt(math.Abs(eig))
                   ///fmt.Println(w0) 			   
		           Sq := complex(Force(w),0.) * complex(a[mode],0.) * complex(w, 0.) * complex(w, 0.) / complex(w0 * w0 - w * w, 2.* w0 * ksi[mode] * w)
                   Sx += complex(F[k*int(m) + mode], 0.) * Sq
	            }
	            fmt.Printf("%12.6f,",cmplx.Abs(Sx))
               }
	       fmt.Printf("\n")
	}
	return
	********************************************************/
}

func readline(){
    line = input.Text()
    fields = strings.Fields(line)
}

func DSpectrum(w float64) float64 {
	return 1.0
}

func FSpectrum(w float64) float64 {
	var accel_sigma float64 = 2.
	var M float64 = 1.e+8
	var df float64 = 2000. - 20.

	return accel_sigma * accel_sigma * M * M / df
}

func Force(w float64) float64 {
	return 2.e+8
}

func  read_modes(filename string) [][]float64 {

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
	return F
}
