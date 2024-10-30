package main

import (
	"crypto/sha256"
	"fmt"
)

func main() {
            var count byte
	    count = 0

	    c1 := sha256.Sum256([]byte("x"))
	    c2 := sha256.Sum256([]byte("X"))
	    fmt.Printf("%x\n%x\n%t\n%T\n", c1, c2, c1 == c2, c1)
            for i, _ := range c1 {
		code1 := convert(c1[i])
		code2 := convert(c2[i])
		fmt.Printf(" first: %b\n", code1);
		fmt.Printf("second: %b\n", code2);
		diff := count_different_bits(code1, code2)
		fmt.Printf("bits: %d\n", diff)
		count += diff
            }
	    fmt.Printf("number of different bits: %d\n", count)
}

func convert(x uint8) [8]byte {
     var code [8]byte
     var i byte;
     i = 7;
     for x>0 {
	     code[i] = x % 2;
	     x >>= 1;
	     i--;
     }
     return code;
}

func count_different_bits(code1 [8]byte, code2 [8]byte) byte {
     var count byte
     count = 0

     for i, _ := range code1 {
	     if (code1[i] != code2[i]){
	         count++
	     }
	 }

     return count
}

