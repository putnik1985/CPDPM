package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	"math"
	//"math/cmplx"
)

var line string
var fields []string
var input *bufio.Scanner
var filename string

var Jd, Jp, m complex128 // mass and inertia of the turbine
var speed complex128 // rotor rotational speed
var L, b complex128 // distane to bearings, distance to CG of the turbine
var ky, kz complex128 // stiffnesses in y and z direction
var etay, etaz complex128 // loss factor for y and z direction
var unb complex128 // unbalance on the turbine
var dy, dz complex128 // damping in y and z direction, will be damper


const (
	dofs = 6 
	tolerance = 1.E-24
	max_iter = 1.E+6
)

func main() {

	if (len(os.Args) < 2) {
		fmt.Println("usage: ./turbine-mode-sfd command=command-file")
		return
	}

	data := make(map[string]string)
	for _, value := range os.Args {
		parts := strings.Split(value, "=")
		if (len(parts) > 1) {
			 data[parts[0]] = parts[1]
		 } 
	}
	
    com, err := os.Open(data["command"])
	if (err != nil) {
		fmt.Fprintf(os.Stderr,"turbine-mode: %v\n", err)
	}
	
	input := bufio.NewScanner(com);
	for (input.Scan()){
         line = input.Text()
         fields = strings.Split(line,",")
		
		 //fmt.Println(line, len(fields))
		 if (len(fields) > 2){
		     data[fields[0]] = fields[1]
		 }
	}
	//fmt.Println(data)
	Jd = complex(tonumber(data["Jp"]),0.)
	Jp = complex(tonumber(data["Jd"]),0.) 
	 m = complex(tonumber(data["m"]),0.)
	 
 speed = complex(tonumber(data["speed"]),0.)
     L = complex(tonumber(data["L"]),0.)
	 b = complex(tonumber(data["b"]),0.)
	 Jd = Jd + m * b * b

    ky = complex(tonumber(data["ky"]),0.)
    kz = complex(tonumber(data["kz"]),0.)

  etay = complex(tonumber(data["etay"]),0.)
  etaz = complex(tonumber(data["etaz"]),0.)	

   unb = complex(tonumber(data["unb"]),0.)

    dy = complex(tonumber(data["dy"]),0.)
    dz = complex(tonumber(data["dz"]),0.)    
	
    fmt.Println(m, Jp, Jd, speed, L, b, ky, kz, dy, dz, etay, etaz, unb)
    return
}

// working with 2DOF system
func f(x [2]complex128, dx [2]complex128) [2]complex128 {
	 var y [2]complex128
	 w := speed * math.Pi / 30.
	 
	 u1 :=  x[0]
	 u2 :=  x[1]
	 
	 v1 := dx[0]
	 v2 := dx[1]
	 
	 y[0] = -(0.*v1 + Jp*w * v2 + dz*L*L * v1 +     0. * v2 + kz*L*L * u1 +     0. * u2 + 1i*etaz*kz*L*L * u1 +             0. * u2) / Jd
	 y[1] = -(-Jp*w*v1 + 0.* v2 +      0.* v1 + dy*L*L * v2 +     0. * u1 + ky*L*L * u2 +             0. * u1 + 1i*etay*ky*L*L * u2) / Jd
	 
	 return y
}

// runge kutt for 2nd order equation
// create methods
func df(dt float64, x0 [2]complex128, dx0 [2]complex128) ([2]complex128, [2]complex128) {
	var y [2]complex128
	var dy [2]complex128
	k1 := dt * f(x0, dx0)
	k2 := dt * f(x0 + dt/2.*dx0 + dt/8.*k1, dx0 + k1/2.)
	k3 := dt * f(x0 + dt/2.*dx0 + dt/8.*k2, dx0 + k2/2.)
	k4 := dt * f(x0 + dt*dx0    + dt/2.*k3, dx0 + k3)
	A := dx0 + 1./6. * (k1 + k2 + k3)
	
	   y = x0 + dt * A
	  dy = A + 1./6. * (k2 + k3 + k4)
	  
	return y, dy
}

func tonumber(str string) float64 {
	num, err := strconv.ParseFloat(str,64)
	if (err != nil){
		fmt.Fprintf(os.Stderr,"tonumber: %v\n", err)
	}
	return num
}


