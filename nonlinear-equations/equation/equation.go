// usage: go run equation.go e_2l=0.02

package main

import (
       "os"
       "fmt"
       "strings"
       "math"
       "strconv"

       "github.com/CPDPM/functions"
       "github.com/CPDPM/numlib"

       _ "gonum.org/v1/gonum/graph/simple"
       )
	   

func e(x float64) float64 {
     return x;
}

func main() {

     data := make(map[string]string)
     for _, arg := range os.Args {
         //fmt.Println(arg)
         out := strings.Split(arg, "=")
         ////fmt.Println(out)
         if (len(out) > 1) {
             ///fmt.Println(out[0], out[1])
             data[out[0]] = out[1]
         }
     }
     //fmt.Println(data["e_2l"])
     e_2l, _ := strconv.ParseFloat(data["e_2l"],64)
	 var eq functions.Stability_Equation
	 eq.E_2l = e_2l
	 eq.K = 0.
	 
	 fmt.Printf("%12s%12s%12s%12s(e/2l=%3.2f)%12s\n","k", "psiL(deg)", "beta", "P/P_e", e_2l, "f/2L")
     for angle := 5; angle <= 90; angle += 5 {
         //fmt.Println(math.Pi * float64(angle) / 180.)
         rad := float64(angle) * math.Pi / 180.
         // solve equation
         k := math.Sin(rad)
	     eq.K = k
	     var psiL float64
         		 
         psiL = numlib.Sect(eq.F, 80. * math.Pi / 180., 120. * math.Pi / 180.)
         beta := functions.F(psiL, k)
         f_2L := (k/beta) * (1. - math.Cos(psiL))
         P_Pe := 4. * beta * beta / (math.Pi * math.Pi)
         fmt.Printf("%12.4f%12.4f%12.4f%23.4f%12.4f\n",k, 180. * psiL / math.Pi, beta, P_Pe, f_2L)
     }
	 /***************
	 x := 80. * math.Pi / 180.;
	 angle := 5
     rad := float64(angle) * math.Pi / 180.
     k := math.Sin(rad)
	 eq.K = k	
	 
	 for (x<=120. * math.Pi / 180.) {
		 fmt.Println(x, eq.F(x))
		 x+=0.001
	 }
	 **********************/
}
