package main

import (
	"fmt"
	"math"
	_ "os"
)

func main() {
	fmt.Println("Please input diameter, Shear Load, Shera Yield, Shear Ultimate and Factors of safety for the Yield and Ultimate")
	var d, P, Ys, Us, FSy, FSu float64
	fmt.Scanf("%f%f%f%f%f%f",&d, &P, &Ys, &Us, &FSy, &FSu)

	stress := 2. * P / (math.Pi * d * d / 4.)
	fmt.Println("---------------------------------------------------------------------------------------------------------------")
	fmt.Println("One dowel analysis")
	fmt.Println("---------------------------------------------------------------------------------------------------------------")
	fmt.Printf("%18s%18s%18s%18s%18s%18s%18s\n", "D", "P", "Stress", "Yield Shear", "Ultimate Shear", "MoS Yield", "Mos Ultimate")
	fmt.Printf("%18s%18s%18s%18s%18s%10sFSy=%4.2f%10sFSu=%4.2f\n", "", "", "", "", "", "", FSy, "", FSu)
	fmt.Printf("%18.6f%18.1f%18.2f%18.1f%18.1f%18.2f%18.2f\n\n", d, P, stress, Ys, Us, Ys/(FSy * stress) - 1., Us/(FSu * stress) - 1.)

	fmt.Println("---------------------------------------------------------------------------------------------------------------")
	fmt.Println("Two dowels analysis")
	fmt.Println("---------------------------------------------------------------------------------------------------------------")
	stress /= 2.
	fmt.Printf("%18s%18s%18s%18s%18s%18s%18s\n", "D", "P", "Stress", "Yield Shear", "Ultimate Shear", "MoS Yield", "Mos Ultimate")
	fmt.Printf("%18s%18s%18s%18s%18s%10sFSy=%4.2f%10sFSu=%4.2f\n", "", "", "", "", "", "", FSy, "", FSu)
	fmt.Printf("%18.6f%18.1f%18.2f%18.1f%18.1f%18.2f%18.2f\n\n", d, P, stress, Ys, Us, Ys/(FSy * stress) - 1., Us/(FSu * stress) - 1.)
}
