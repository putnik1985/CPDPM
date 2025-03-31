package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	"math"
)

type InputData struct{
     r float64 // radius
     q float64 // pressure
     D float64 // stiffness
    nu float64 // Poisson 
   rho float64 // density
     h float64 // thickness
     E float64 // Young
     a float64 //minimum radius
     b float64 //maximum radius
}

const (
       rtolerance =  1.E-5
        rmaxnumber = 1.E+16
                N =    100
       )

func main(){
	//fmt.Println(os.Args[1:])
	data := make(map[string]string)
	boundary := make(map[string](func(data InputData) (float64, float64, float64, float64)))

	boundary["moment"] = moment
	 boundary["angle"] = angle
	  boundary["disp"] = disp

	var rmin, rmax float64
	var inputbc [3]string //three boundaries are expected for the symmetric circular plates
        var current_bc int = -1 //position to write the boundary

	 if len(os.Args) > 1 {
             for _, value := range os.Args {
		     /////fmt.Println(value)
		     parts := strings.Split(value, "=")
		     //fmt.Println(parts)
		     if len(parts) > 1 {
		         data[parts[0]] = parts[1]
	             }
	     }
         } else {
	    fmt.Println("usage: ./static.. file=input.txt")
	    return
         }

	 filename := data["file"]
	 fmt.Printf("input file: %s\n", filename)
	 f, err := os.Open(filename)
	 if err != nil {
		 fmt.Fprintf(os.Stderr, "can not open file: %s\n", filename)
		 return
	 }
	 scanner := bufio.NewScanner(f)
	 for scanner.Scan() {
	     /////fmt.Println(scanner.Text())
	     line := scanner.Text()
	     parts := strings.Split( line, ",")

	     if len(parts) < 2 {
		 continue
	     }

	     data[parts[0]] = parts[1]

	     if (parts[0] == "r") {
		     //fmt.Println("Found Range")
		     //fmt.Println(parts)
		     rmin, _ = strconv.ParseFloat(parts[1], 64)
		     rmax, _ = strconv.ParseFloat(parts[2], 64)
	     }

	     if (strings.Contains(parts[0], "angle") || strings.Contains(parts[0], "disp") || strings.Contains(parts[0], "moment")) {
		     //fmt.Println("Found Range")
		     //fmt.Println(parts)
		     current_bc++
		     //fmt.Println(current_bc)
		     if (current_bc < 3) {
			     inputbc[current_bc] = line 
		     }
	     }
	 }
	    f.Close()
	    E, _ := strconv.ParseFloat(data["E"], 64)
	    h, _ := strconv.ParseFloat(data["h"], 64)
	   nu, _ := strconv.ParseFloat(data["nu"], 64)
	  rho, _ := strconv.ParseFloat(data["rho"], 64)
	    q, _ := strconv.ParseFloat(data["q"], 64)

	  fmt.Printf("\nInput Data:\n")
	  fmt.Printf("E=,%g,h=,%f,rho=,%g,nu=,%f,q=,%f\n", E, h, rho, nu, q)

	  fmt.Printf("\nCalculated Data:\n")
	  fmt.Printf("D=,%g,\n", E*h*h*h/(12.*(1-nu*nu)))
	  var input InputData
	  input.r = -1.
	  input.q = q
	  input.D = E * h * h * h / (12. * (1. - nu*nu)) 
	  input.nu = nu
	  input.rho = rho
	  input.h = h
	  input.E = E

	  fmt.Printf("\nRadius Range:\n")
	  fmt.Printf("r: %f, %f\n", rmin, rmax)
	  input.a = rmin
	  input.b = rmax

	  var A [3][3]float64
	  var B [3]float64

	  fmt.Println("\nBoundary Conditions Found:")
	  for i:=0; i<current_bc+1; i++ {

		  fmt.Println(inputbc[i])
		  parts := strings.Split(inputbc[i], ",")
		  // work with the item value
		  values := strings.Split(parts[0],"=")
		  //fmt.Printf("name = %s, value = %f\n", values[0], value)
		  name := values[0]
		  value, _ := strconv.ParseFloat(values[1], 64)

		  // work with the radius value
		  values = strings.Split(parts[1],"=")
		  input.r, _ = strconv.ParseFloat(values[1], 64)
		  ///fmt.Printf("name = %s, value = %f\n", values[0], input.r)

		  //input.r += rtolerance
		  var number float64
		  A[i][0], A[i][1], A[i][2], number = boundary[name](input)
		  B[i] = value - number 

		  /////fmt.Printf("%12.4f%12.4f%12.4f%12.4f\n", A[i][0], A[i][1], A[i][2], B[i])
	  }

	  var C [3]float64
	  /*********************************************
		  var a [2][2]float64
                  var det [3]float64

		  a[0][0] = A[0][0]; a[0][1] = A[0][1]
		  a[1][0] = A[1][0]; a[1][1] = A[1][1]
		  det[0] = det2(a)

		  a[0][0] = B[0]; a[0][1] = A[0][1]
		  a[1][0] = B[1]; a[1][1] = A[1][1]
		  det[1] = det2(a)

		  a[0][0] = A[0][0]; a[0][1] = B[0]
		  a[1][0] = A[1][0]; a[1][1] = B[1]
		  det[2] = det2(a)

		  if det[0] == 0. {
			  fmt.Println("Coefficient: Can not find solution")
			  return
		  }

		  C[0] = det[1] / det[0]
		  C[1] = det[2] / det[0]

		  C[2] = (B[2] - A[2][0] * C[0] - A[2][1] * C[1]) / A[2][2]
	  ****************************************************/

                  C = gauss(A,B)
                  if math.Abs(C[1]) < rtolerance {
			  C[1] = 0.
		  }
		  //fmt.Println("\nSolution:")
		  //fmt.Printf("%12f,%12f,%12f,\n",C[0], C[1], C[2])
		  //fmt.Printf("\n")
		  fmt.Printf("\n%12s,%12s,%12s,%12s,%12s,%12s,%12s\n","radius(mm)","Disp(mm)","Angle(rad)","Moment_r(kgs.mm)","Moment_t(kgs.mm)","Sr(kgs/mm2)","St(kgs/mm2)")
		  dr := (rmax - rmin) / N
		  var max_d, max_a, max_mr, max_mt, max_sr, max_st float64
		  for r:=rmin; r<=rmax; r+=dr {
			  input.r = r
			  d1, d2, d3, d4 := boundary["disp"](input)
			  a1, a2, a3, a4 := boundary["angle"](input)
			  m1, m2, m3, m4 := boundary["moment"](input)

                          //fmt.Printf("%12f,%12f,%12f,%12f\n", m1, m2, m3, m4)
		          //fmt.Printf("%12f,%12g,%12f,%12f,=,%12f\n\n", C[0], C[1], C[2], 1., mvalue)

			  dvalue := C[0] * d1 + C[1] * d2 + C[2] * d3 + d4
			  avalue := C[0] * a1 + C[1] * a2 + C[2] * a3 + a4
			  mvalue := C[0] * m1 + C[1] * m2 + C[2] * m3 + m4
                          sigma_r := mvalue * 6. / (h*h)

			  m1, m2, m3, m4 = moment_t(input)
			  mvalue_t := C[0] * m1 + C[1] * m2 + C[2] * m3 + m4
                          sigma_t := mvalue_t * 6. / (h*h)
			  fmt.Printf("%12.6f,%12.3f,%12.6f,%12.2f,%12.2f,%12.2f,%12.2f\n", r, dvalue, avalue, mvalue, mvalue_t, sigma_r, sigma_t)

			  if math.Abs(dvalue) > max_d {
				  max_d = math.Abs(dvalue)
			  }

			  if math.Abs(avalue) > max_a {
				  max_a = math.Abs(avalue)
			  }

			  if math.Abs(mvalue) > max_mr {
				  max_mr = math.Abs(mvalue)
			  }

			  if math.Abs(mvalue_t) > max_mt {
				  max_mt = math.Abs(mvalue_t)
			  }

			  if math.Abs(sigma_r) > max_sr {
				  max_sr = math.Abs(sigma_r)
			  }

			  if math.Abs(sigma_t) > max_st {
				  max_st = math.Abs(sigma_t)
			  }
		  }
		          fmt.Printf("\n\n")
			  fmt.Printf("%12s,%12.3f,%12.6f,%12.2f,%12.2f,%12.2f,%12.2f\n", "Maximum:", max_d, max_a, max_mr, max_mt, max_sr, max_st)


}

func det2(a [2][2]float64) float64 {
	return a[0][0] * a[1][1] - a[0][1] * a[1][0]
}

func moment_t(data InputData) (float64, float64, float64, float64) {
	///fmt.Println("calculate moment")
	//q := float64(1.0)
	D := data.D
        nu := data.nu

        c1, c2, c3, b := dangle_over_dr(data)
	d1, d2, d3, c :=   angle_over_r(data)
	return D*(d1 + nu*c1), D*(d2 + nu*c2), D*(d3 + nu*c3), D*(c + nu*b) 
}

func moment(data InputData) (float64, float64, float64, float64) {
	///fmt.Println("calculate moment")
	//q := float64(1.0)
	D := data.D
        nu := data.nu

        c1, c2, c3, b := dangle_over_dr(data)
	d1, d2, d3, c :=   angle_over_r(data)
	return D*(c1 + nu*d1), D*(c2 + nu*d2), D*(c3 + nu*d3), D*(b + nu*c) 
}

func shear(data InputData) (float64, float64, float64, float64) {
	////fmt.Println("calculate share")
	q := data.q 
	//D := float64(1.0)
	r := data.r
	return 0., 0., 0., q*r/2.
}

func angle(data InputData) (float64, float64, float64, float64) {
	//////fmt.Println("\nAngle Coefficients")
	q := data.q
	D := data.D
	r := data.r
	a := data.a
	if r < rtolerance {
	   return -r/2., -rmaxnumber, 0., -q*r*r*r/(16.*D)
        }
	return -r/2., -1/r, 0., -q*r*r*r/(16.*D) + q * a * a * r / (8.*D) * (2. * math.Log(r) - 1.)
}

func disp(data InputData) (float64, float64, float64, float64) {
	///fmt.Println("calculate displacement")
	q := data.q
	D := data.D
	r := data.r
	a := data.a

	if r < rtolerance {
	   return r * r / 4., -rmaxnumber, 1., q*r*r*r*r/(64.*D)
        }
	return r * r / 4., math.Log(r), 1., q*r*r*r*r/(64.*D) + q * a * a * r * r / (8. * D) * (1. - math.Log(r))
}

func dangle_over_dr(data InputData) (float64, float64, float64, float64) {
	////fmt.Println("calculate angle")
	q := data.q
	D := data.D
	r := data.r
	a := data.a

	if r < rtolerance {
	    return -1./2., rmaxnumber, 0., -3.*q*r*r/(16.*D)
        }
	return -1./2., 1./(r*r), 0., -3.*q*r*r/(16.*D) + q * a * a / (8. * D) * (2. * math.Log(r) + 1.)
}

func angle_over_r(data InputData) (float64, float64, float64, float64) {
	/////fmt.Println("calculate angle")
	q := data.q
	D := data.D
	r := data.r
	a := data.a

	if r < rtolerance {
	   return -1/2., -rmaxnumber, 0., -q*r*r/(16.*D)
        }
	return -1/2., -1./(r*r), 0., -q*r*r/(16.*D) + q * a * a / (8. * D) * (2. * math.Log(r) -1.)
}

func gauss(A [3][3]float64, B [3]float64) [3]float64 {
	 // solver for 3x3 equations
	 n := 3
	 for i:=0; i<n-1; i++{
		 for j:=i+1; j<n; j++{
			 factor := A[j][i] / A[i][i]
			 for k:=i; k<n; k++ {
				 A[j][k] -= factor * A[i][k]
			 }
			 B[j] -= factor * B[i]
		 }
	 }

	 var x [3]float64

	 for k:=n-1; k>=0; k--{
		 s := float64(0.0)
		 for j:=k+1; j<n; j++{
			 s += A[k][j] * x[j]
		 }
		 x[k] = (B[k] - s) / A[k][k]
	 }
	 return x
}
