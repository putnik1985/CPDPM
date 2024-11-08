package main

import (
	"fmt"
	"os"
	"strconv"
)

func main(){

        s := os.Args[1:]
	if len(s) < 2 {
		panic("for gcd at least 2 numbers are required")
	}

	numbers := make([]uint64, len(s))
	fmt.Printf("(")
	for i, val := range s {
              numbers[i], _ = strconv.ParseUint(val, 10, 64) 
	      fmt.Printf("%d,",numbers[i])
	}
	fmt.Printf(") = %d\n", mgcd(numbers...))
}


func gcd(a uint64, b uint64) uint64 {

	if (a<b){
		a, b = b, a
	}

	q := a / b
	r := a - b * q

	for (r > 0 ){
		a = b
		b = r
		q = a / b
		r = a - b * q
	}
	return b
}

func mgcd(numbers...uint64) uint64 {

     a := numbers[0]
     i := 1

     for i < len(numbers) {
	 b := numbers[i]
	 a = gcd(a, b)
	 i++
     }
     return a
}
