package functions

import "math"
import "gonum.org/v1/gonum/mathext"

type Stability_Equation struct {
	E_2l float64
    K float64
}

func (eq Stability_Equation) F(x float64) float64 {
	k := eq.K
 e_2l := eq.E_2l
     
    return k * math.Cos(x) / F(x,k) + e_2l *  (1.- 2. * k*k * math.Sin(x) * math.Sin(x))  
}

func F(x float64, k float64) float64 {
	return mathext.EllipticF(x, k*k)
}
