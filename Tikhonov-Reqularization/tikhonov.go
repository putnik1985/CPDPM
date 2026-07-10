package main

import "fmt"
import "gonum.org/v1/gonum/mat"
import "log"
import  "bufio"
import "strings"
import _ "strconv"
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
