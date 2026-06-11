package functions

import "math"

func BF(x float64, k float64) float64 {
	return k * math.Cos(x) / (F(x) * (1.- 2. * k*k * math.Sin(x) * math.Sin(x)))
}

func F(x float64) float64 {
	return 1.;
}
