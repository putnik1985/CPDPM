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
     file, err := os.Open(inputfile)
     if err != nil {
        panic(err)
     }
    
     data := make(map[string]float64)

     scanner := bufio.NewScanner(file)
     for scanner.Scan() {
         words := strings.Split(scanner.Text(),",")
         key := words[0]
         value, _ := strconv.ParseFloat(words[1],64)
         fmt.Printf("key: %12s value: %12.2f\n", key, value) 
         data[key] = value
     }
    CE := data["CE"]
    fmt.Printf("CE: %12.2f\n", CE)
    dg := data["dg"]
    dp := data["dp"]
   phi := data["phi"] * math.Pi / 180.
    CG := dg * math.Sin(phi) * math.Cos(phi) / ( 2 * (dg + dp) )
    fmt.Printf("CG: %12.3f\n", CG)
   T := data["P"] * 746.0 / (data["speed"] * math.Pi / 30. )
    fmt.Printf("Torque: %12.2f\n", T)
   Wt := 2. * T / dp
    fmt.Printf("Tangential force, kN: %12.2f\n", Wt)
   SHZ := CE * math.Sqrt( 2. * T * 1000. * data["KV"] * data["KOL"] * data["KM"] / ( data["F"] * dp * dp * CG ) )
    fmt.Printf("Hertz stress, MPa: %12.2f\n", SHZ)
   SFHZ := 2.76 * data["HB"] - 69.
   // for steels contact fatigue stress N = 10E7
   fmt.Printf("SFHZ, MPa: %12.2f\n", SFHZ)
   kn := SHZ / SFHZ
   fmt.Printf("KN: %12.2f\n", kn)
   N := math.Pow(kn / 2.466, -1. / 0.056)
   fmt.Printf("N, cycles: %12.2E\n",N)
   speed := data["speed"]
   fmt.Printf("hours: %12.2f days: %12.2f years: %12.2f\n", N / speed / 60., N / speed/ 60. / 24., N / speed / 60. / 24. / 365)
}
