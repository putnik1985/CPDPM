package main

import (
	"fmt"
	"os"
	"bytes"
	"strings"
)

func main() {
	    var s1 string = os.Args[1]
	    fmt.Printf("%s: %s\n", s1, comma(s1))
}

func comma(s string) string {

         var buf bytes.Buffer
         var parts []string = strings.Split(s,".")

	    main := parts[0]
	 decimal := parts[1]
	 var pos int = 0

         l := len(main)
         for i, _ := range main {
		 if (pos < 2){
		 buf.WriteByte(main[l - 1 - i])
		 pos++
	         } else {
			 buf.WriteByte(main[l - 1 - i])
			 buf.WriteByte(',')
			 pos = 0
		 }
	 }

	 buf.WriteByte('.')
	 buf.WriteString(decimal)
	 return buf.String()
}
