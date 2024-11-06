package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	    var s1 string = os.Args[1]
	    var pos int
	    pos, err := strconv.Atoi(os.Args[2])

	    if err != nil {
		    panic("not a number")
	    }

	    fmt.Printf("%s: %s\n", s1, rotate(s1, pos))
}

func rotate(s string, pos int) string {

	    n := len(s)
	    buf := make([]byte, n)
	    for i:= 0; i < n; i++{
	         buf[i] = s[i]
            }

	    for i:=0; i < pos; i++ {
		    a := buf[0]
		    //fmt.Printf("%c\n",a)
		    for k:=0; k < n - 1; k++ {
			    buf[k] = buf[k+1]
		    }
                  
		    buf[n-1] = a
		    //fmt.Printf("%q\n",buf)
	    }
	    return string(buf)
}
