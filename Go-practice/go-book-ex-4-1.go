package main

import (
	"crypto/sha256"
	"fmt"
	"os"
	"strconv"
)

func main() {
	s := 256;

	if (len(os.Args) > 1){
        	flag := os.Args[1];
	        fmt.Printf("flag: %s\n", flag);
                s, _ = strconv.Atoi(flag);
	        fmt.Printf("flag: %d\n", s);
        }

	var count int;
	c1 := sha256.Sum256([]byte("x"))
	c2 := sha256.Sum256([]byte("X"))
	fmt.Printf("%x\n%x\n%t\n%T\n", c1, c2, c1 == c2, c1)
	for i, _ := range c1 {
		fmt.Printf("%d = %b, %b\n", i, c1[i], c2[i]);
		// split on bits and comparer bit by bit, if different ++count
		count++;
	}
}
