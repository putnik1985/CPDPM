package main

import (
	"fmt"
	"math"
	"os"
	"strings"
	"strconv"
)

var beta float64
func f(w float64) float64 {
	a1 := math.Sqrt(   math.Pow(beta, 2.) / 2 + math.Sqrt(math.Pow(beta, 4.) / 4. + math.Pow(w, 2.)))
	a2 := math.Sqrt(  -math.Pow(beta, 2.) / 2 + math.Sqrt(math.Pow(beta, 4.) / 4. + math.Pow(w, 2.)))
        return math.Pow(beta, 4.) + 2*math.Pow(w, 2.) + math.Pow(beta, 2.) * w * math.Sin(a1) * math.Sinh(a2) + 2*math.Pow(w, 2.) * math.Cos(a1) * math.Cosh(a2)
}

func main() {

	data := make(map[string]string)
	for _, value := range os.Args {
		command := strings.Split(value, "=")
		if len(command) >= 2 {
		   data[command[0]] = command[1]
	        }
	}

	a, err := strconv.ParseFloat(data["a"], 64)
	if err != nil {
		fmt.Errorf("can not read a\n")
		return
	}

	b, err := strconv.ParseFloat(data["b"], 64)
	if err != nil {
		fmt.Errorf("can not read b\n")
		return
	}

	beta, err = strconv.ParseFloat(data["beta"], 64)
	if err != nil {
		fmt.Errorf("can not read beta\n")
		return
	}

	var dx float64 = 0.0001
	var roots []float64

	for a + dx <= b {
		x, err := root(f, a, a + dx)
		if err == true {
			roots = append(roots, x)
		}
		a += dx
	}

        fmt.Printf("%12f", beta*beta)
	for _, value := range roots {
		fmt.Printf("%12.4f", value)
	}
	fmt.Printf("\n")
}

func root(f func(float64) float64, a float64, b float64) (float64, bool) {
        var err float64 = 0.0001;
	if f(a) * f(b) > 0. {
		return 0., false
	} else {

		for math.Abs(a-b)>=err {
			if f(a) * f( (a+b)/2.) <= 0. {
				b = (a+b) / 2.
			} else {
				a = (a+b) / 2.
			}
		}
	}
	return a, true
}
