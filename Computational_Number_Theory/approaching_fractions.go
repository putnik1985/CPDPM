package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main(){

	if (len(os.Args) < 2){
		panic("usage: program a=12 b=2")
	}

        s1 := os.Args[1]
	s2 := os.Args[2]
        nums := strings.Split(s1, "=")
	a, _ := strconv.ParseUint(nums[1], 10, 64)

	nums = strings.Split(s2, "=")
	b, _ := strconv.ParseUint(nums[1], 10, 64)

	////fmt.Printf("a = %d, b = %d\n", a, b)
	q := create_q(a, b)
	/*
	for _, val := range q {
		fmt.Printf("%d ", val)
	}
	*/
	fmt.Printf("\n")
	var P []uint64 = []uint64{1, q[0]}
	var Q []uint64 = []uint64{0, 1}

	for j:= 2; j <= len(q); j++{
		i := j - 1
		val := q[i]
		P = append(P, val * P[j-1] + P[j-2])
		Q = append(Q, val * Q[j-1] + Q[j-2])
	}
	fmt.Printf("%8s%8s","q", "")
	for _, val := range q {
		fmt.Printf("%8d", val)
	}
	fmt.Printf("\n");

	fmt.Printf("%8s","P")
	for _, val := range P {
		fmt.Printf("%8d", val)
	}
	fmt.Printf("\n");

	fmt.Printf("%8s","Q")
	for _, val := range Q {
		fmt.Printf("%8d", val)
	}
	fmt.Printf("\n");
}


func create_q(a uint64, b uint64) []uint64 {

	q := a / b
	r := a - b * q
        var list []uint64
        list = append(list, q)

	for (r > 0 ){
		a = b
		b = r
		q = a / b
		r = a - b * q
		list = append(list, q)
	}
	return list
}
