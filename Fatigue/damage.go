package main

import (
       "fmt"
       "bufio"
       "os"
       "strings"
       "strconv"
       "math"
)

func main() {
     inputfile := os.Args[1]
     datafile  := os.Args[2]
   
     data := read_data(datafile)
     gamma := data["GAMMA"]
         C := data["C"]
         B := data["B"]
         s := data["MARIN_S"]
         r := data["MARIN_R"]
        SM := data["SM"]

     f, error := os.Open(inputfile)
     if (error != nil) {
         panic(error)
     }

     fmt.Printf("%12s%12s%12s%12s%12s%12s\n","cycle", "range", "mean", "equiv", "N", "D")
     scanner := bufio.NewScanner(f)
     damage := 0.0
     for scanner.Scan() {
         words := strings.Split(scanner.Text(), ",")
         cycles, _ := strconv.ParseFloat(words[0], 64)
         delta, _ := strconv.ParseFloat(words[1], 64)
         mean, _ := strconv.ParseFloat(words[2], 64)

         sigma_eqv := delta / math.Pow(1. - gamma * math.Pow(mean/SM, s), 1. / r)
         N := C / math.Pow(sigma_eqv, B)
         fmt.Printf("%12.2f%12.2f%12.2f%12.2f%12.2E%12.2E\n", cycles, delta, mean, sigma_eqv, N, cycles / N)
         damage += cycles / N
     }
     fmt.Printf("\nTotal damage: %12.2E\n", damage)
     fmt.Printf("\nNb, blocks: %12.2E\n", 1. / damage)
}

func read_data(datafile string) map[string]float64 {
     data := make(map[string]float64)
     f, error := os.Open(datafile)
     if ( error != nil ) {
        panic(error)
     }

     scanner := bufio.NewScanner(f)
     for scanner.Scan() {
         words := strings.Split(scanner.Text(), ",")
         key := words[0]
         value, _ := strconv.ParseFloat(words[1], 64)
         data[key] = value
     }
     return data
}
