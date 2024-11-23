package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main(){

	if (len(os.Args) < 3){
		panic("usage: program a=1 b=2 t=8")
	}

        s1 := os.Args[1]
	s2 := os.Args[2]
	s3 := os.Args[3]

        nums := strings.Split(s1, "=")
	a, _ := strconv.ParseUint(nums[1], 10, 64)

	nums = strings.Split(s2, "=")
	b, _ := strconv.ParseUint(nums[1], 10, 64)
	
	nums = strings.Split(s3, "=")
	t, _ := strconv.ParseUint(nums[1], 10, 64)

	if (a > b){
		panic("it is required to have a < b")
	}

	farey(0, 1, a, b, t)
	fmt.Printf("%d/%d\n", a, b)

}

func farey(a uint64, b uint64, c uint64, d uint64, t uint64){

	if ( d + b > t ){
		fmt.Printf("%d/%d, ", a, b)
		return
	}

        farey(a, b, a + c, b + d, t)
        farey(a + c, b + d, c, d, t)
}

