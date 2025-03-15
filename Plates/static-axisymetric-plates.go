package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	"math"
)

type InputData struct{
     r float64 // radius
     q float64 // pressure
     D float64 // stiffness
    nu float64 // Poisson 
   rho float64 // density
     h float64 // thickness
     E float64 // Young
}

func main(){
	//fmt.Println(os.Args[1:])
	data := make(map[string]string)
	boundary := make(map[string](func(r float64) (float64, float64, float64, float64)))

	boundary["moment"] = moment
	 boundary["angle"] = angle
	  boundary["disp"] = disp

	 if len(os.Args) > 1 {
             for _, value := range os.Args {
		     /////fmt.Println(value)
		     parts := strings.Split(value, "=")
		     //fmt.Println(parts)
		     if len(parts) > 1 {
		         data[parts[0]] = parts[1]
	             }
	     }
	     input := "moment"
	     boundary[input](0.1)
         } else {
	    fmt.Println("usage: ./static.. file=input.txt")
	    return
         }

	 filename := data["file"]
	 fmt.Printf("input file: %s\n", filename)
	 f, err := os.Open(filename)
	 if err != nil {
		 fmt.Fprintf(os.Stderr, "can not open file: %s\n", filename)
		 return
	 }
	 scanner := bufio.NewScanner(f)
	 for scanner.Scan() {
	     ////////fmt.Println(scanner.Text())
	     parts := strings.Split( scanner.Text(), ",")
	     data[parts[0]] = parts[1]
	 }
	    E, _ := strconv.ParseFloat(data["E"], 64)
	    h, _ := strconv.ParseFloat(data["h"], 64)
	   nu, _ := strconv.ParseFloat(data["nu"], 64)
	  rho, _ := strconv.ParseFloat(data["rho"], 64)
	    q, _ := strconv.ParseFloat(data["q"], 64)

	  fmt.Printf("\nInput Data:\n")
	  fmt.Printf("E = %g, h = %f, rho = %g, nu = %f, q = %f\n", E, h, rho, nu, q)

}

func moment(r float64) (float64, float64, float64, float64) {
	fmt.Println("calculate moment")
	//q := float64(1.0)
	D := float64(1.0)
        nu := float64(1.0)
        c1, c2, c3, b := dangle_over_dr(r)
	d1, d2, d3, c :=   angle_over_r(r)
	return D*(c1 + nu*d1), D*(c2 + nu*d2), D*(c3 + nu*d3), D*(b + nu*c) 
}

func shear(r float64) (float64, float64, float64, float64) {
	fmt.Println("calculate share")
	q := float64(1.0)
	//D := float64(1.0)
	return 0., 0., 0., q*r/2.
}

func angle(r float64) (float64, float64, float64, float64) {
	fmt.Println("calculate angle")
	q := float64(1.0)
	D := float64(1.0)
	return -r/2., -1/r, 0., -q*r*r*r/(16.*D)
}

func disp(r float64) (float64, float64, float64, float64) {
	fmt.Println("calculate displacement")
	q := float64(1.0)
	D := float64(1.0)
	return r * r / 4., math.Log(r), 1., q*r*r*r*r/(64.*D)
}

func dangle_over_dr(r float64) (float64, float64, float64, float64) {
	fmt.Println("calculate angle")
	q := float64(1.0)
	D := float64(1.0)
	return -1./2., 1./(r*r), 0., -3.*q*r*r/(16.*D)
}

func angle_over_r(r float64) (float64, float64, float64, float64) {
	fmt.Println("calculate angle")
	q := float64(1.0)
	D := float64(1.0)
	return -1/2., -1./(r*r), 0., -q*r*r/(16.*D)
}
