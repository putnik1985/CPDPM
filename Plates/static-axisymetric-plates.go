package main

import(
	"fmt"
	"os"
	"strings"
	"bufio"
	"strconv"
)

func main(){
	//fmt.Println(os.Args[1:])
	data := make(map[string]string)
	boundary := make(map[string](func(r float64) (float64, float64, float64)))

	boundary["moment"] = moment
	 boundary["shear"] = shear
	 boundary["angle"] = angle
	  boundary["disp"] = disp

	 if len(os.Args) > 1 {
             for _, value := range os.Args {
		     /////fmt.Println(value)
		     parts := strings.Split(value, "=")
		     //fmt.Println(parts)
		     if len(parts) > 1 {
		         data[parts[0]] = parts[1]
	             }
	     }
	     input := "moment"
	     boundary[input](0.1)
         } else {
	    fmt.Println("usage: ./static.. moment[shear,angle,disp]")
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
	     ////////fmt.Println(scanner.Text())
	     parts := strings.Split( scanner.Text(), ",")
	     data[parts[0]] = parts[1]
	 }
	    E, _ := strconv.ParseFloat(data["E"], 64)
	    h, _ := strconv.ParseFloat(data["h"], 64)
	   nu, _ := strconv.ParseFloat(data["nu"], 64)
	  rho, _ := strconv.ParseFloat(data["rho"], 64)

	  fmt.Printf("\nInput Data:\n")
	  fmt.Printf("E = %g, h = %f, rho = %g, nu = %f\n", E, h, rho, nu)

}


func moment(r float64) (float64, float64, float64) {
	fmt.Println("calculate moment")
	return 0., 0., 0.
}

func shear(r float64) (float64, float64, float64) {
	fmt.Println("calculate share")
	return 0., 0., 0.
}

func angle(r float64) (float64, float64, float64) {
	fmt.Println("calculate angle")
	return 0., 0., 0.
}

func disp(r float64) (float64, float64, float64) {
	fmt.Println("calculate displacement")
	return 0., 0., 0.
}
