package main

import (
	"fmt"
	"os"
)

func main() {
	    var s1 string = os.Args[1]
	    var s2 string = os.Args[2]

	    fmt.Printf("%s vs. %s: %t\n", s1, s2, anagram(s1, s2))
}

func anagram(s1 string, s2 string) bool {

	if (len(s1) != len(s2)){
	     return false
        }

         l := len(s1)
	 //fmt.Printf("%d\n",l)
         for i, _ := range s1 {
		 //fmt.Printf("%c -- %c\n", s1[i], s2[l-1-i])
		 if ( s1[i] != s2[l - 1 - i]){
		      return false
	      }
	 }
   
	return true
}
