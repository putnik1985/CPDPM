package main

import "fmt"
import "gonum.org/v1/gonum/mat"
import "log"

func main(){
        ///var input []float64={1., -1., 1., 1.,}

	a := mat.NewDense(2, 2, []float64 { 1., -1.,
                                            1., 1.})
        fmt.Printf("A = %v\n\n", mat.Formatted(a, mat.Prefix("     ")))
	var eig mat.Eigen
	ok := eig.Factorize(a, mat.EigenLeft)

	if !ok {
		log.Fatal("Eigendecomposition failed")
	}
	fmt.Printf("Eigenvalues of A:\n%v\n", eig.Values(nil))
}
