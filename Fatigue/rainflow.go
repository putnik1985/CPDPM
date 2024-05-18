package main

import (
       "fmt"
       "os"
       "bufio"
       "strings"
       "strconv"
       "math"
)


func main() {

     inputfile := os.Args[1]
     fmt.Printf("input file: %12s\n", inputfile)
     sigma := read_sigma(inputfile)
     fmt.Printf("input load spectrum:\n")
     fmt.Printf("%12s%12s\n","point", "sigma")
     for i:= range sigma {
         fmt.Printf("%12d%12.2f\n", i, sigma[i])
     }

     n := len(sigma) - 1
     var i int = 0
     var k int = 0
     var s []float64
     s = append(s, 0.)
     fmt.Printf("\nRainflow algorithm (count cycles)\n") 
     fmt.Printf("%12s%12s%12s\n","cycles", "range", "mean") 

     for {
             i += 1

         if  ( i <= n  ) {
             s = append(s, sigma[i])
             k += 1
             if ( k < 3 ) {
                  continue
             }  
         } else {
            break
         }

//         fmt.Println(s, k)
         for ( k >= 3) {

            if !( ( s[k-1] < s[k-2] && s[k-2] <= s[k] ) ||
                  ( s[k-1] > s[k-2] && s[k-2] >= s[k] ) ) {
               break
            } 
         
         if ( k > 3 ) {
            cycle := 1.
            sigma_a := math.Abs(s[k-2] - s[k-1]) / 2.
            sigma_m := (s[k-2] + s[k-1]) / 2. 
//            fmt.Println("K>3 cycle")
            fmt.Printf("%12.2f%12.2f%12.2f\n", cycle, sigma_a, sigma_m)
            s = remove(s, k-2)
            k -= 1
            s = remove(s, k-2)
            k -= 1
         } else {
            cycle := 0.5
            sigma_a := math.Abs(s[k-2] - s[k-1])/ 2.
            sigma_m := (s[k-2] + s[k-1])/2.
//            fmt.Println("K>3 ELSE cycle")
            fmt.Printf("%12.2f%12.2f%12.2f\n", cycle, sigma_a, sigma_m)
            s = remove(s, k-2)
            k -= 1
            break
         }

         }
         continue
     } // main loop

     for (k >= 2 ) {
       cycle := 0.5
       sigma_a := math.Abs(s[k-1] - s[k]) / 2.
       sigma_m := (s[k-1] + s[k]) / 2.
//       fmt.Println("K >= 2 cycle")
       fmt.Printf("%12.2f%12.2f%12.2f\n", cycle, sigma_a, sigma_m)
       s = remove(s, k)
       k -= 1
    }
}


func read_sigma(inputfile string) []float64 {
     f, error := os.Open(inputfile)
     if (error != nil) {
         panic(error)
     }

     scanner := bufio.NewScanner(f)
     var sigma []float64
     for scanner.Scan() {
         words := strings.Split(scanner.Text(), ",")
         n := len(words)
         for i:= 0; i < n; i++  {
             number, _:= strconv.ParseFloat(words[i], 64)
             sigma = append(sigma, number)
         }
     }
     return sigma
}

func remove(s []float64, index int) []float64 {
     return append(s[:index], s[index+1:]...)
}
