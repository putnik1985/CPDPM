package main

import (
	"fmt"
	"os"
	"strconv"
	"slices"
)

const per_line = 10

func main(){

        s := os.Args[1]
	if len(s) < 1 {
		panic("for prime numbers maximum bound is required")
	}
	max_bound, _ := strconv.ParseUint(s, 10, 64)
	fmt.Printf("Prime numbers less or equal to %d:\n", max_bound)
	numbers := primes(max_bound)
        ///fmt.Printf("\n", numbers, len(numbers))
	count := 0
	for _, val := range numbers {
		if (count < per_line){
			fmt.Printf("%8d",val)
			count++
		} else {
			fmt.Printf("\n")
			fmt.Printf("%8d",val)
			count =1 
		}
	}
}


func primes(max_bound uint64) []uint64 {

     var numbers []uint64
     var i uint64
     var k uint64
     var factor uint64

     for i = 1; i <= max_bound; i++ {
	     numbers = append(numbers, i)
     }

     for k = 2; k <= uint64(len(numbers)); k++ {
	     a := numbers[k - 1]

	     if(a>0){
		     for factor = 2;  factor * a <= max_bound; factor++ {
			     numbers[ factor * a - 1 ] = 0
		    }
	     }
     }
     var found int
     found = slices.Index(numbers, 0)
     for found != -1 {
	     numbers = remove(numbers, found)
             found = slices.Index(numbers, 0)
     }

     return numbers
}

func remove(numbers []uint64, pos int) []uint64 {
	copy(numbers[pos:], numbers[pos+1:])
	return numbers[:len(numbers)-1]
}


