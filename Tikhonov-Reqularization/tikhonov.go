package main

import "fmt"
import "gonum.org/v1/gonum/mat"
import "log"
import "bufio"
import "strings"
import "strconv"
import "os"

func main(){
        ///var input []float64={1., -1., 1., 1.,}

	a := mat.NewDense(2, 2, []float64 { 1., -1.,
                                            1., 1.})
        fmt.Printf("A = %v\n\n", mat.Formatted(a, mat.Prefix("     ")))
	var eig mat.Eigen
	ok := eig.Factorize(a, mat.EigenLeft)

	if !ok {
		log.Fatal("Eigendecomposition failed")
	}
	fmt.Printf("Eigenvalues of A:\n%v\n", eig.Values(nil))


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
       
	fmt.Println(n, vector)
        matrix, err := convert_slice_to_matrix(string_matrix)
        if (err != nil){
            panic("can not convert matrix")
        } 

	fmt.Println(matrix)
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
             ////////////fmt.Println(value)
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
