package numlib

import "math"
import "fmt"

func test(x float64) float64 {
     return x;
}

func Sect(f func(float64) float64, a float64, b float64) float64 {
      var x0, x1 float64
      var error float64
      error = 1.e-8

      x0 = a
      x1 = b
      if (f(x0) * f(x1) > 0) {
                  fmt.Println("solution does not exist")
                  return -1.
      }

      for (math.Abs(x0-x1) > error) {
           x := (x0 + x1) / 2.
           if (f(x0) * f(x) > 0) {
               x0 = x
               x1 = x1
           } else {
               x0 = x0
               x1 = x
           }
       }
       return x0
}
