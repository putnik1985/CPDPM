package main

import (
       "fmt"
       "bufio"
       "os"
       "math"
       "strings"
       "strconv"
)

func main() {
     inputfile := os.Args[1]
     fmt.Printf("input file: %12s\n", inputfile)
     
     f, error := os.Open(inputfile)
     if error != nil {
        panic(error)
     }

     data := make(map[string]float64)
     scanner := bufio.NewScanner(f)
     for scanner.Scan() {
         words := strings.Split(scanner.Text(), ",")
         key := words[0]
         value, _ := strconv.ParseFloat(words[1], 64)
         fmt.Printf("%s: %12.2f\n", key, value)
         data[key] = value
     }

     D := data["D"]
     h := ( data["D"] - data["d"]) / 2.
     r := data["RHO"]
     d := data["d"]

     K_tB := K_tBend(D, h, r)
     K_tT := K_tTorque(D, h, r)

     fmt.Printf("K_tB: %12.2f K_tT: %12.2f\n", K_tB, K_tT)

     q := 1. / ( 1. + 0.51 / r) // for aluminium alloys
     K_fB := 1. + q * ( K_tB - 1.)
     K_fT := 1. + q * ( K_tT - 1.)
     fmt.Printf("q: %12.2f K_fB: %12.2f K_fT: %12.2f\n", q, K_fB, K_fT)

     T_A := (data["T_MAX"] - data["T_MIN"]) / 2.
     T_M := (data["T_MAX"] + data["T_MIN"]) / 2.

     M_A := (data["M_MAX"] - data["M_MIN"]) / 2.
     M_M := (data["M_MAX"] + data["M_MIN"]) / 2.

     S_ATRESCA := S_TRESCA(T_A, M_A, d, K_fB, K_fT)
     S_MTRESCA := S_TRESCA(T_M, M_M, d, K_fB, K_fT)
     fmt.Printf("S_A, COEFF: %12.1E S_M, COEFF: %12.2E\n", S_ATRESCA, S_MTRESCA) 
     N1 := 1000.
     N2 := 5 * 1.E+8
     S1 := data["SF_10_3"]
     S2 := data["SL_5_10_8"]
     B  := math.Log(N1/N2) / math.Log(S2/S1)
     C  := N1 * math.Pow(S1, B)
     fmt.Printf("B: %12.2f C: %12.2E\n", B, C)
     N_LIMIT := data["N_LIMIT"]
     SF_LIMIT := math.Pow(C / N_LIMIT, 1. / B)
     fmt.Printf("S, MPA: %12.2f N, cycles: %12.2E\n", SF_LIMIT, N_LIMIT)
     PHI_F := data["PHI_F"]
     SU := data["SU"]
     r  = data["MARIN_R"]
     s := data["MARIN_S"]

     fmt.Printf("\nCalculate maximum allowable torque to handle %12.2E cycles\n", N_LIMIT) 
     P := Solve_Marin(r, s, PHI_F, S_ATRESCA, S_MTRESCA, SF_LIMIT, SU)
     fmt.Printf("\nMaximum allowable torque, Nm: %12.2f\n", P / 1000.)
} 


func K_tBend(D float64, h float64, r float64) float64 {
     if ( (h/r > 0.25) && (h/r < 2.) ) {
     return (0.927 + 1.149 * math.Sqrt(h/r) - 0.086 * h / r) +
            (0.015 - 3.281 * math.Sqrt(h/r) + 0.837 * h / r) * 2 * h / D +
            (0.847 + 1.716 * math.Sqrt(h/r) - 0.506 * h / r) * math.Pow(2 * h / D, 2.) +
            (-0.79 + 0.417 * math.Sqrt(h/r) + 0.246 * h / r) * math.Pow(2 * h / D, 3.)
     }
     
     return (1.225 + 0.831 * math.Sqrt(h/r) - 0.010 * h / r) +
            (-3.79 + 0.958 * math.Sqrt(h/r) - 0.257 * h / r) * ( 2 * h / D ) +
            (7.374 - 4.834 * math.Sqrt(h/r) + 0.862 * h / r) * math.Pow( 2 * h / D, 2) +
            (-3.809 + 3.046 * math.Sqrt(h/r) - 0.595 * h / r ) * math.Pow( 2 * h / D, 3)
}

func K_tTorque(D float64, h float64, r float64) float64 {
     return (0.953 + 0.680 * math.Sqrt(h/r) - 0.053 * h / r) +
            (-0.493 - 1.82 * math.Sqrt(h/r) + 0.517 * h / r) * 2 * h / D +
            ( 1.621 + 0.908 * math.Sqrt(h/r) - 0.529 * h / r) * math.Pow( 2 * h / D, 2.) +
            (-1.081 + 0.232 * math.Sqrt(h/r) + 0.065 * h / r) * math.Pow( 2 * h / D, 3.)
}

func S_TRESCA(T float64, M float64, d float64, K_fB float64, K_fT float64) float64 {
     return math.Sqrt( K_fB * math.Pow( 32. * M / (math.Pi * math.Pow(d, 3.)), 2.) +
                       4. * K_fT * math.Pow( 16. * T / (math.Pi * math.Pow(d, 3.)), 2.) )
}

func Solve_Marin(r float64, s float64, PHI_F float64, S_ATRESCA float64, S_MTRESCA float64, SF_LIMIT float64, SU float64) float64 {
     eps := 0.001
     x0 := 1.
     x1 := 1. / math.Pow( math.Pow(PHI_F * S_ATRESCA / SF_LIMIT, r) * math.Pow(x0, r - s) + math.Pow(PHI_F * S_MTRESCA / SU, s), 1. / s) 
     iter := 0
     fmt.Printf("%12s%12s\n","Iteration","Error")

     for ( math.Abs(x0 - x1) >= eps ) {
       iter += 1
       x0 = x1
       x1 = 1. / math.Pow( math.Pow(PHI_F * S_ATRESCA / SF_LIMIT, r) * math.Pow(x0, r - s) + math.Pow(PHI_F * S_MTRESCA / SU, s), 1. / s) 
       fmt.Printf("%12d%12.4f\n", iter, math.Abs(x0 - x1))
     }
     return x1
}
     
