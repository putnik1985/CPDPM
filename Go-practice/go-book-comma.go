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
	    //fmt.Printf("%T\n",main)
	    decimal := ""
            sign := ""

	    if (len(parts) > 1){
	        decimal = parts[1]
	     }
         ///fmt.Printf("%t\n",main[0]=='-')
         if (main[0] == '-'){
		 main = main[1:]
		 sign = "-"
	 }

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

         temp := buf.String()
	 //fmt.Printf("%s\n", temp)
	 if (temp[len(temp)-1] == ','){
		 temp = temp[:len(temp)-1]
	 }

	 //fmt.Printf("%s\n", temp)
	 rs := reverse(temp)
	 return sign + rs + "." + decimal
}

func reverse(s string) string {
     var buf bytes.Buffer

     l := len(s)
     for i, _ := range s {
         buf.WriteByte(s[l - 1 - i])
     }
     return buf.String()
}
