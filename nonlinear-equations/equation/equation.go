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
         fmt.Println(arg)
         out := strings.Split(arg, "=")
         ////fmt.Println(out)
         if (len(out) > 1) {
             ///fmt.Println(out[0], out[1])
             data[out[0]] = out[1]
         }
     }
     //fmt.Println(data["e_2l"])
     e_2l, _ := strconv.ParseFloat(data["e_2l"],64)
     fmt.Println(e_2l)
/////////////////////////////////////////////////
     root := numlib.sect(e, -1., 1.)
     fmt.Println(root)
     return
/////////////////////////////////////////////////
     for angle := 5; angle <= 90; angle += 5 {
         //fmt.Println(math.Pi * float64(angle) / 180.)
         rad := float64(angle) * math.Pi / 180.
         // solve equation
            k := math.Sin(rad)
	    var psiL float64
         psiL = functions.BF(psiL, k)
         beta := functions.F(psiL)
         f_2L := (k/beta) * (1. - math.Cos(psiL))
         P_Pe := 4. * beta * beta / (math.Pi * math.Pi)
         fmt.Printf("%12.4f%12.4f%12.4f%12.4f\n",k, psiL, f_2L, P_Pe)
     }
}
