package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
	"math"
	"math/cmplx"
)

var line string
var fields []string
var input *bufio.Scanner
var filename string

var Jd, Jp, m float64 // mass and inertia of the turbine
var speed float64 // rotor rotational speed
var L, b float64 // distane to bearings, distance to CG of the turbine
var ky, kz float64 // stiffnesses in y and z direction
var etay, etaz float64 // loss factor for y and z direction
var unb float64 // unbalance on the turbine
var dy, dz float64 // damping in y and z direction, will be damper
var steps int = 1000

var G float64 = 9810. //mm/sec2 

const (
	dofs = 6 
	tolerance = 1.E-24
	max_iter = 1.E+6
)

type ncomplex struct {
	r float64
	im float64
}

func main() {

	if (len(os.Args) < 2) {
		fmt.Println("usage: ./turbine-mode-sfd command=command-file steps=1000")
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
	Jd = tonumber(data["Jp"]) / G
	Jp = tonumber(data["Jd"]) / G
	 m = tonumber(data["m"]) / G
	 
 speed = tonumber(data["speed"])
     L = tonumber(data["L"])
	 b = tonumber(data["b"])
	 Jd = Jd + m * b * b

    ky = tonumber(data["ky"])
    kz = tonumber(data["kz"])

  etay = tonumber(data["etay"])
  etaz = tonumber(data["etaz"])	

   unb = tonumber(data["unb"]) / G

    dy = tonumber(data["dy"])
    dz = tonumber(data["dz"])    
	
    ///fmt.Println(m, Jp, Jd, speed, L, b, ky, kz, dy, dz, etay, etaz, unb)
    fmt.Printf("%12s%12s%12s\n","Time,sec","UY,mm","UZ,mm")

    var x0 [2]complex128
    var dx0 [2]complex128

    var t float64 = 0.
    var dt float64 = 0.0005 // 2kHz sample rate
    var n int

    n = steps
    fmt.Printf("%12.6f%12.6f%12.6f\n", t, L*real(x0[1]), -L*real(x0[0]))
    for i:=0; i<=n; i++ {
	x, dx := df(t, dt, x0, dx0)
	x0 = x
	dx0 = dx
        t += dt
        fmt.Printf("%12.6f%12.6f%12.6f\n", t, L*real(x0[1]), -L*real(x0[0]))
    }
    return
}

// working with 2DOF system
func f(t float64, x [2]complex128, dx [2]complex128) [2]complex128 {
	 var y [2]complex128
	 w := speed * math.Pi / 30.
	 
	 u1 :=  x[0]
	 u2 :=  x[1]
	 
	 v1 := dx[0]
	 v2 := dx[1]
	 
	 y[0] = cmplx.Exp(1i*complex(w*t,0.))*complex(unb*w*w*b/Jd, 0.) * 1i + complex(-1./Jd,0.) * ( complex(Jp*w,0.)*v2 + complex(dz*L*L,0.)*v1 + complex(kz*L*L,0.)*u1 + 1i*complex(etaz*kz*L*L,0.)*u1)
	 y[1] =      cmplx.Exp(1i*complex(w*t,0.))*complex(unb*w*w*b/Jd, 0.) + complex(-1./Jd,0.) * (complex(-Jp*w,0.)*v1 + complex(dy*L*L,0.)*v2 + complex(ky*L*L,0.)*u2 + 1i*complex(etay*ky*L*L,0.)*u2)
	 return y
}

// runge kutt for 2nd order equation
// create methods
func df(t float64, dt float64, x0 [2]complex128, dx0 [2]complex128) ([2]complex128, [2]complex128) {
	var y [2]complex128
	var dy [2]complex128

	k1 := times(dt, f(t, x0, dx0))
	k2 := times(dt, f(t + dt/2., sum(x0 ,times(dt/2.,dx0) ,times(dt/8.,k1)), sum(dx0, times(0.5, k1)) ))
	k3 := times(dt, f(t + dt/2., sum(x0 ,times(dt/2.,dx0) ,times(dt/8.,k2)), sum(dx0, times(0.5, k2)) ))
	k4 := times(dt, f(   t + dt, sum(x0 ,times(dt, dx0)   ,times(dt/2.,k3)), sum(dx0,    k3) ))
	 A := sum( dx0, times(1./6., sum(k1, k2, k3)) )
	
	 y = sum(x0,times(dt,A))
	dy = sum( A,times(1./6.,sum(k2, k3, k4)))
	return y, dy
}

func tonumber(str string) float64 {
	num, err := strconv.ParseFloat(str,64)
	if (err != nil){
		fmt.Fprintf(os.Stderr,"tonumber: %v\n", err)
	}
	return num
}

func times(r float64, z [2]complex128) [2]complex128{
	var out [2]complex128
	out[0] = complex(r,0.) * z[0]
	out[1] = complex(r,0.) * z[1]
	return out
}

func sum(vals ...[2]complex128) [2]complex128 {
	var total [2]complex128
	for _, val := range vals {
		total[0] += val[0]
		total[1] += val[1]
	}
	return total
}
