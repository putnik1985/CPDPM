package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

const per_line = 10

func main(){

        s := os.Args[1]
	if len(s) < 1 {
		panic("usage: ./program_name number=3")
	}
	command := strings.Split(s, "=")
	a, _ := strconv.ParseUint(command[1], 10, 64)
	fmt.Printf("%d = \n", a)
	numbers, deg := decomposition(a)

	if (len(numbers) == 0) {
		fmt.Printf("%8d\n", a)
	} else {
		var power_string string
		for _, val := range deg {
			power_string += fmt.Sprintf("%8d",val)
		}
		var number_string string
		for _, val := range numbers {
			number_string += fmt.Sprintf("%8d",val)
		}
		fmt.Printf(" %s\n",power_string)
		fmt.Printf("%s\n",number_string)
	}
}


func decomposition(a uint64) ([]uint64, []uint64) {

     var numbers []uint64
     var degrees []uint64

     var val uint64
     a_copy := a
     for  val = 2; val < a_copy; val++ {
		 ///fmt.Printf("%8d,", val)
		 var deg uint64 = 0
		 var r uint64 = a%val
		 for (r==0){
			 deg++
			 a/=val
			 r = a%val
		 }

		 if (deg>0) {
			 numbers = append(numbers, val)
			 degrees = append(degrees, deg)
		 }
	 }
     return numbers, degrees
}
