package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	"math"
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
            frequencies := read_frequencies(data["modes"])
	    //fmt.Println(frequencies)
	    //fmt.Printf("#Modes = %d\n\n", len(frequencies))

            F := read_modes(data["modes"])
	    m := len(F)
	    n := len(F[0])
	    //fmt.Printf("#Modes = %d, #DOFs = %d\n\n", m, n)

            S := read_modes(data["stress"])
	    m = len(S)
	    n = len(S[0])
	    //fmt.Printf("#Modes = %d, #DOFs = %d\n\n", m, n)

	    disp_labels := read_labels(data["modes"])
        // input from the command file
        var direction string = "100-DISPZ"
	stress_output := []string{"41835-TOP-SXX", "41835-TOP-SYY", "41835-TOP-SXY"}
	 accel_output := []string{"33772-DISPX", "33772-DISPY", "33772-DISPZ"}

	    fmt.Println("Excitation Grid:")
            fmt.Println(disp_labels[direction])
            fmt.Println("Output Accelerations:")
	    for i:=0; i<len(accel_output); i++ {
		fmt.Println(disp_labels[accel_output[i]])
	    }
	    stress_labels := read_labels(data["stress"])

            fmt.Println("Output Stresses:")
	    for i:=0; i<len(stress_output); i++ {
		fmt.Println(stress_labels[stress_output[i]])
	    }

	var excitation []float64    
	m = len(F)
	n = len(F[0])

        for i:=0; i< n; i++ {
		excitation = append(excitation, 0.)
	}
		excitation[disp_labels[direction]] = 1.

	    fmt.Println("\nExcitation")
	    fmt.Println(len(excitation))
	    fmt.Println(excitation)

	var p []float64

	for i:=0; i<m; i++ {
		var s float64 = 0.
		for j:=0; j<n; j++{
			s += F[i][j] * excitation[j]
		}
		p = append(p, s)
	////////fmt.Printf("%12g,",s)
	}
	fmt.Printf("\n")
        /////return
	fmt.Println("Excitation Vector:,")
	fmt.Println(p)
	fmt.Println(len(p))

	var rms []float64
	for i:=0; i<int(n); i++ {
	rms = append(rms, 0.)
	}

	var input_rms float64 = 0.
        // input from the command file
	var G float64 = 9.81
	var M float64 = 1.e+8
	var Gstress float64 = 1.E+6 // convert to MPa
	fmin := 20.
	fmax := 2000.
	N := 1980
	var df float64 = (fmax - fmin) / float64(N)
	var ksi []float64 // input from the command file
	for i:=0; i < m; i++ {
		ksi = append(ksi, 0.05)
	}

	var Sx []float64
	for i:=0; i<n; i++ {
		Sx = append(Sx, 0.)
	}

        fmt.Println("\nAcceleration Spectrum Density(g^2/Hz):,")
	fmt.Printf("%16s,%16s,","Freq(Hz)", "Input")

	       for i:=0; i<len(accel_output); i++ {
		   channel := accel_output[i]
	           fmt.Printf("%16s,", channel)
	       }
               fmt.Printf("\n")

	for freq := fmin; freq <= fmax; freq += df {
	       w := 2. * math.Pi * freq
	       fmt.Printf("%16f,",freq)
	       fmt.Printf("%16.6g,",FSpectrum(w) / (M * M))
	       input_rms += FSpectrum(w) / (M*M) * df 
	       for k:=0; k<n; k++{ // calculate for each DOF only densities on the main diagonal, cross densities Sij = Fsi Sqs Fsj should be added
		   Sx[k] = 0.
	           for mode, freq := range frequencies{
		       w0 := 2. * math.Pi * freq

                       ///fmt.Println(w0) 			   
		       Sq := FSpectrum(w) * p[mode] * p[mode] / (math.Pow(w0 * w0 - w * w, 2.) + 4. * w0 * w0 * ksi[mode] * ksi[mode] * w * w)
                       Sx[k] += w * w * w * w * F[mode][k] * F[mode][k] * Sq
	            }
	            //fmt.Printf("%12.6f,",Sx)
				rms[k] += Sx[k] * df 
               }

	       for i:=0; i<len(accel_output); i++ {
		   k := disp_labels[accel_output[i]]
	           fmt.Printf("%16.6f,",Sx[k] / (G * G))
	       }

	       fmt.Printf("\n")
	}

	fmt.Printf("\nRMS:\n")
	fmt.Printf("%16s,%16.6f,","Total:", math.Sqrt(input_rms) / G)
	for i:=0; i<len(accel_output); i++ {
	    k := disp_labels[accel_output[i]]
	    val := rms[k]
	    fmt.Printf("%16.6f,", math.Sqrt(val) / G)
	}
	fmt.Printf("\n")

	m = len(S)
	n = len(S[0])
	rms = nil
	for i:=0; i<int(n); i++ {
	    rms = append(rms, 0.)
	}

        Sx = nil
	for i:=0; i<n; i++ {
		Sx = append(Sx, 0.)
	}

        fmt.Println("\nStress Spectrum Density(MPa^2/Hz):,")
	fmt.Printf("%16s,%16s,","Freq(Hz)", "Input(g^2/Hz)")

	       for i:=0; i<len(stress_output); i++ {
		   channel := stress_output[i]
	           fmt.Printf("%16s,", channel)
	       }
               fmt.Printf("\n")


	input_rms = 0.
	for freq := fmin; freq <= fmax; freq += df {
	       w := 2. * math.Pi * freq
	       fmt.Printf("%16f,",freq)
	       fmt.Printf("%16.6g,",FSpectrum(w) / (M * M))
	       input_rms += FSpectrum(w) / (M*M) * df 
	       for k:=0; k<n; k++{ // calculate for each DOF only densities on the main diagonal, cross densities Sij = Fsi Sqs Fsj should be added
		   Sx[k] = 0.
	           for mode, freq := range frequencies{
		       w0 := 2. * math.Pi * freq

                       ///fmt.Println(w0) 			   
		       Sq := FSpectrum(w) * p[mode] * p[mode] / (math.Pow(w0 * w0 - w * w, 2.) + 4. * w0 * w0 * ksi[mode] * ksi[mode] * w * w)
                       Sx[k] += S[mode][k] * S[mode][k] * Sq
	            }
	            //fmt.Printf("%12.6f,",Sx)
				rms[k] += Sx[k] * df 
               }

	       for i:=0; i<len(stress_output); i++ {
		   k := stress_labels[stress_output[i]]
	           fmt.Printf("%16.6f,",Sx[k] / (Gstress * Gstress))
	       }

	       fmt.Printf("\n")
	}

	fmt.Printf("\nRMS:\n")
	fmt.Printf("%16s,%16.6f,","Total:", math.Sqrt(input_rms) / G)
	for i:=0; i<len(stress_output); i++ {
	    k := stress_labels[stress_output[i]]
	    val := rms[k]
	    fmt.Printf("%16.6f,", math.Sqrt(val) / Gstress)
	}
	fmt.Printf("\n")
    /***************************
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
    ****************************/
    return
}

func readline(){
    line = input.Text()
    fields = strings.Fields(line)
}

func DSpectrum(w float64) float64 {
	return 1.0
}

func FSpectrum(w float64) float64 {
	var accel_sigma float64 = 8.
	var G float64 = 9.81
	var M float64 = 1.e+8
	var df float64 = 2000. - 20.

	return G * G * accel_sigma * accel_sigma * M * M / df
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
	/*********************************
	fmt.Println("Modes")
        fmt.Println(F)
	fmt.Println("\nFrequencies")
	fmt.Println(frequencies)
	*********************************/
	return F
}
func  read_labels(filename string) map[string]int {

	f, err := os.Open(filename)//f becomes *os.File
	if err != nil {
		  fmt.Fprintf(os.Stderr, "random: %v\n", err)
	}

	var F map[string]int //Mode shapes
        var index int
	index = 0
        F = make(map[string]int)

	input = bufio.NewScanner(f)
	for input.Scan() {
	    readline()
	    ///fmt.Println(line, fields)
	    var label string 
	    label = fields[0]
	    if strings.Contains(line, "Frequency") {
		    if len(F) > 0 {
			   break 
		    }
	    } else {
		    F[label] = index
		    index++
	    }
        }
        f.Close()
        //fmt.Println(mode)
	//fmt.Println("Labels:")
        //fmt.Println(F)
	return F
}
func  read_frequencies(filename string) []float64 {

	f, err := os.Open(filename)//f becomes *os.File
	if err != nil {
		  fmt.Fprintf(os.Stderr, "random: %v\n", err)
	}

	var frequencies []float64

	input = bufio.NewScanner(f)
	for input.Scan() {
	    readline()
	    ///fmt.Println(line, fields)
	    var disp float64
	    disp, _ = strconv.ParseFloat(fields[1], 64)
	    if strings.Contains(line, "Frequency") {
		    frequencies = append(frequencies, disp)
	    }
        }
        f.Close()
        //fmt.Println(mode)
	/*********************************
	fmt.Println("Modes")
        fmt.Println(F)
	fmt.Println("\nFrequencies")
	fmt.Println(frequencies)
	*********************************/
	return frequencies 
}
