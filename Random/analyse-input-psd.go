package main

import "fmt"
import "os"
import "math"
import "bufio"
import "strings"

type Spectrum struct {
	frequency float64
	psd float64
}

func main() {
	///usage go run file=input-psd.txt 
	data := make(map[string]string)
	for _, item := range os.Args {
		//fmt.Println(item)
		command := strings.Split(item,"=")
		if (len(command) > 1) {
			////fmt.Println(command)
			data[command[0]] = command[1]
		}

	}
	file := data["file"]
	fmt.Println("Input file: ", file)
	f, err := os.Open(file)
	defer f.Close()

	if (err != nil){
		panic(err)
	}

	scanner := bufio.NewScanner(f)
	var table []Spectrum

	for scanner.Scan(){
		line := scanner.Text()
		////fmt.Println(line)
		var freq, psd float64
		fmt.Sscanf(line, "%g%g",&freq, &psd)
		///fmt.Println(freq, psd)
		table = append(table, Spectrum{freq, psd})
	}

	fmt.Println("")
	fmt.Println("Spectrum Read: ")
	for _, value := range table {
		fmt.Printf("%8.2f%8.4f\n", value.frequency, value.psd)
	}
	fmt.Println("")
	fmt.Println("Spectrum Analysed: ")
	dim := len(table)

	fmt.Println("")
	fmt.Printf("%8s%8s%8s\n", "Freq(Hz)", "G^2/Hz", "dB/oct")
	var frequency, psd float64
	var power float64 = 0.
	for i:=0; i<dim-1; i++ {
                   dB := 3. * math.Log(table[i+1].psd/table[i].psd) / math.Log(table[i+1].frequency/table[i].frequency) 
	     frequency = table[i].frequency
	           psd = table[i].psd
                   power += 0.5 * (table[i].psd + table[i+1].psd) * (table[i+1].frequency - table[i].frequency)
	    fmt.Printf("%8.2f%8.4f%8.2f\n", frequency, psd, dB)
	}

	     frequency = table[dim-1].frequency
	           psd = table[dim-1].psd

	    fmt.Printf("%8.2f%8.4f\n", frequency, psd)
	    fmt.Println("")
	    fmt.Printf("%8s%16.2f\n", "Grms:", math.Sqrt(power))

}
