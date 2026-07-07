package main

import "gonum.org/v1/gonum/mat"
import "fmt"

func main(){
	a := mat.Dense(2, 2, []float64 {
		1., -1.,
		1.,  1.,
	})
        fmt.Printf("A = %v\n\n", mat.Formatted(a, mat.Prefix("     ")))
	var eig mat.Eigen
	ok := eig.Factorize(a, mat.EigenLeft)

	if !ok {
		log.Fatal("Eigendecomposition failed")
	}
	fmt.Printf("Eigenvalues of A:\n%v\n", eig.Values(nil))
}
