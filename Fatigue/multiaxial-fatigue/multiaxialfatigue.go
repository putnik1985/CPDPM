package main

import(
       "fmt"
       "os"
       "math"
       "bufio"
       "strings"
       "strconv"
      )

func main(){

  inputfile := os.Args[1]
  parameters := read_data(inputfile)

  sxmin := parameters["_sxmin"]
  sxmax := parameters["_sxmax"]

  symin := parameters["_symin"]
  symax := parameters["_symax"]

  szmin := parameters["_szmin"]
  szmax := parameters["_szmax"]

  sxymin := parameters["_sxymin"]
  sxymax := parameters["_sxymax"]

  sxzmin := parameters["_sxzmin"]
  sxzmax := parameters["_sxzmax"]

  syzmin := parameters["_syzmin"]
  syzmax := parameters["_syzmax"]

  freq := parameters["_freq"]
     T := parameters["_T"]
    SU := parameters["_SU"]
    SL := parameters["_SL"]
    TL := parameters["_TL"]
    TC := parameters["_TC"]
    bg := parameters["_bg"]

  fmt.Println(parameters)
  fmt.Println("")

    as := 1. / math.Sqrt(3) * SL / SU
    bs := SL / math.Sqrt(3)

    dsx := sxmax - sxmin
    dsy := symax - symin
    dsz := szmax - szmin
   dsxy := sxymax - sxymin
   dsxz := sxzmax - sxzmin
   dsyz := syzmax - syzmin

   dsmises := math.Sqrt( 0.5*math.Pow(dsx - dsy, 2.) + 0.5*math.Pow(dsx - dsz, 2.) + 0.5*math.Pow(dsy - dsz, 2.) + 3 * (math.Pow(dsxy, 2.) + math.Pow(dsxz, 2.) + math.Pow(dsyz, 2.)))
   dtmises := dsmises / math.Sqrt(3)

   sxmean := (sxmax + sxmin) / 2.
   symean := (symax + symin) / 2.
   szmean := (szmax + szmin) / 2.

   smean := (sxmean + symean + szmean) / 3.

   cycles := freq * T
   N := 0.5 * math.Pow( (dtmises / 2. + as * 3 * smean ) * TL / (bs * TC), 1./bg)
   damage := cycles / N
   fmt.Printf("Sine invarian-based muliaxial fatigue model\n")
   fmt.Println("bs = ", bs)  
   fmt.Println("as = ", as)     
   fmt.Println((dtmises / 2. + as * 3 * smean ))
   fmt.Println(N)
   fmt.Printf("Accumulated damage: %12.4f\n", damage)
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
 