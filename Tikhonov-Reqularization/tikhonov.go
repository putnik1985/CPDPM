package main

import "fmt"
import "gonum.org/v1/gonum/mat"
import "log"
import "bufio"
import "strings"
import "strconv"
import "os"
import "math"

func main(){
        ///var input []float64={1., -1., 1., 1.,}

	data := make(map[string]string)
	for _, value := range os.Args {
		command := strings.Split(value,"=")
		if (len(command) > 1) {
			data[command[0]] = command[1]
		}
	}

	file := data["file"]
	fmt.Printf("Input file: %s\n", file)
	string_vector := read(file, "vector")
	string_n := read(file, "dimension")
	string_matrix := read(file, "matrix")
        
	fmt.Println(string_n, string_matrix, string_vector)

        vector, err := convert_slice_to_numbers(string_vector)
        if (err != nil){
            panic("can not convert vector")
        } 
            
        n, err := convert_slice_to_numbers(string_n)
        if (err != nil){
            panic("can not convert dimension")
        } 
       
	//fmt.Println(n, vector)
        matrix, err := convert_slice_to_matrix(string_matrix)
        if (err != nil){
            panic("can not convert matrix")
        } 

	//fmt.Println(matrix)

	A := mat.NewDense(int(n[0]),int(n[1]),matrix)
        fmt.Printf("A = %v\n\n", mat.Formatted(A, mat.Prefix("     ")))
        fmt.Printf("\n------------------------------------------------\n")
	fmt.Printf("Tikhonov Reqularization\n")
        fmt.Printf("-------------------------------------------------\n")
	var alpha float64 = 1.E-17
	var delta float64 = 1.
        var sol []float64
        var alpha_min float64

	for alpha < 1. {
	    output := Tikhonov_Reqularization(A, vector, alpha)
            deviation := calculate_deviation_norm(A, output, vector)
	    if (deviation < delta){
		    delta = deviation
		    alpha_min = alpha
		    sol = output
	    }
	    fmt.Println("------------------------------------")
	    fmt.Printf("alpha: %.4e\n", alpha)
	    fmt.Printf("delta: %.4e\n", deviation)
	    fmt.Println(output)
	    alpha *= 10.
        }

	fmt.Println("\n\n-----------------SOLUTION--------------------")
	fmt.Printf("alpha: %.4e\n", alpha_min)
	fmt.Printf("delta: %.4e\n", delta)
	fmt.Println("Optimal solution:")
	fmt.Println(sol)
}

func calculate_deviation_norm(A mat.Matrix, x []float64, u []float64) float64 {
	m, n := A.Dims()
	var norm float64
	norm = 0.
	for i:=0; i<m; i++ {
		var s float64 = 0.
		for j:=0; j<n; j++{
			s += A.At(i,j) * x[j] 
		}
		norm += (s - u[i] ) * (s - u[i])
	}
	return math.Sqrt(norm)
}


func read(filename string, key string) []string {
        var output []string

	handler, err := os.Open(filename)
	defer handler.Close()
	if (err != nil){
		message := fmt.Sprintf("can not read file: %s", filename)
		panic(message)
	}

	scanner := bufio.NewScanner(handler)
	var found bool = false
	fmt.Println("looking for: ", key)
	for scanner.Scan(){
		line := scanner.Text()

		if (strings.Contains(line, key)) {
		    fmt.Printf("found %s\n",line)
		    found = true
		    continue
	        } else if ( !found) {
		    continue	
		}


		contains_numbers := strings.ContainsAny(line,"0123456789")
		if (found && contains_numbers) {
		    fmt.Printf("%s\n",line)	
		    output = append(output, line)
		} else {
		    break
		}
	}

	return output
}

func convert_slice_to_numbers(strings []string) ([]float64, error) {

     var output []float64
         for _, value := range strings {
             //fmt.Println(value)
             number, err := strconv.ParseFloat(value,64)
             if (err != nil) {
                 panic("can not convert into numbers:")
                 return nil, err
             }
             output = append(output, number) 
         }
     return output, nil
}

func convert_slice_to_matrix(str []string) ([]float64, error) {

     var output []float64
         for _, value := range str {
             ////////////fmt.Println(value)
             numbers := strings.Split(value," ")
             ////fmt.Println(numbers)
             for _, number := range numbers {
                 if (strings.ContainsAny(number,"0123456789")){ 
                     num, err := strconv.ParseFloat(number,64) 
                     if (err != nil){ 
                         panic("can not convert to matrix")
                     }
                     output = append(output, num) 
                 }
             }
         }
     return output, nil
}

func Tikhonov_Reqularization(A mat.Matrix, u []float64, alpha float64) []float64 {
	m, n := A.Dims()
	output := mat.NewDense(n, 1, nil)
        b := mat.NewDense(n, 1, nil)	

	B := mat.NewDense(n,n,nil)
	for k:=0; k<n; k++ {
	    for j:=0; j<n; j++ {
		    for i:=0; i<m; i++{
			B.Set(k,j, B.At(k,j) + A.At(i,k) * A.At(i,j))    
		    }
	    }
	    B.Set(k,k, B.At(k,k) + alpha)
	}
	for k:=0; k<n; k++ {
		for i:=0; i<n; i++ {
			b.Set(k, 0, A.At(i,k) * u[i] + b.At(k,0))
		}
	}

        //fmt.Printf("B = %v\n\n", mat.Formatted(B, mat.Prefix("     ")))
        //fmt.Printf("b = %.4f\n", mat.Formatted(b))
	var qr mat.QR
	qr.Factorize(B)
	err := qr.SolveTo(output, false, b)
	if (err != nil) {
		log.Fatalf("could not solve QR:%+v", err)
	}
	var res []float64
	for i:=0; i<n; i++ {
		res = append(res, output.At(i,0))
	}
	return res
}
