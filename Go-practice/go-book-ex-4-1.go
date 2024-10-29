package main

import (
	"crypto/sha256"
	"fmt"
)

func main() {
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
