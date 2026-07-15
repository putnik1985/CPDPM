package main

import "fmt"
import "os"
import "strings"
import "bufio"
import "strconv"

/// usage: go run stress-reader.go file=nastran.pch
func main() {
	etypes := make(map[string]int)
        etypes["ctetra"] = 39
        var fields []string
        var NF int
        ////var subcase int

        data := make(map[string]string)
	for _, value := range os.Args {
		command := strings.Split(value,"=")
		if (len(command) > 1) {
			data[command[0]] = command[1]
		}
	}
	file := data["file"]	
	//fmt.Println(file)
	f, err := os.Open(file)
	if (err != nil) {
		panic("can not open file")
	}

	defer f.Close()

	scanner := bufio.NewScanner(f)
	////fmt.Printf("%T\n",scanner)

	fmt.Printf("%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n", "EID", "X","Y","Z","XY","YZ","ZX","A","B","C","P","VM")
        for scanner.Scan() {
		line := scanner.Text()
		chline := line[:len(line)-8]
		///fmt.Printf("%s\n",chline)
		if (strings.Contains(chline, "$ELEMENT STRESSES")) {
			///fmt.Println(chline)
                        scanner.Scan()
			line, fields = readline(scanner)
			/************************
                        scanner.Scan()
			line = scanner.Text()
			chline = line[:len(line)-8]
			fields = strings.Fields(chline)
			*****************************/

			NF = len(fields)
			////subcase, _ = strconv.Atoi(fields[NF-1])
			/************************************************************
                        scanner.Scan()
			line = scanner.Text()
			chline = line[:len(line)-8]
			fmt.Println(chline)
			fields = strings.Fields(chline)
			fmt.Println(fields)
			************************************************************/
			line, fields = readline(scanner)
			NF = len(fields)
			read_type, _ := strconv.Atoi(fields[NF-1])
			begin := fields[0]
			if (read_type == etypes["ctetra"]) {
				///fmt.Println("Subcase: ",subcase)
			        for scanner.Scan() && begin != "$TITLE" {
			            /*****************************************************************
			            line = scanner.Text()
			            chline = line[:len(line)-8]
				    fields = strings.Fields(chline)
				    *******************************************************************************/
				    line, fields = splitline(scanner)
				    begin = fields[0]
				    if (strings.ContainsAny(begin,"0123456789")) {
				        ///fmt.Println(begin)
					EID, _ := strconv.ParseInt(begin, 10, 64)

					line, fields = readline(scanner)
					///fmt.Println(line)
					 X, _ := strconv.ParseFloat(fields[2], 64)
					XY, _ := strconv.ParseFloat(fields[3], 64)
                                        
					line, fields = readline(scanner)
					//fmt.Println(line)
					 A, _ := strconv.ParseFloat(fields[1], 64)

					line, fields = readline(scanner)
					//fmt.Println(line)
					 P, _ := strconv.ParseFloat(fields[2], 64)
					 VM, _ := strconv.ParseFloat(fields[3], 64)

					line, fields = readline(scanner)
					//fmt.Println(line)
					 Y, _ := strconv.ParseFloat(fields[1], 64)
					YZ, _ := strconv.ParseFloat(fields[2], 64)
					 B, _ := strconv.ParseFloat(fields[3], 64)

					line, fields = readline(scanner)
					//fmt.Println(line)

					line, fields = readline(scanner)
					//fmt.Println(line)
					 Z, _ := strconv.ParseFloat(fields[1], 64)
					ZX, _ := strconv.ParseFloat(fields[2], 64)
					 C, _ := strconv.ParseFloat(fields[3], 64)

					line, fields = readline(scanner)
					///fmt.Println(line)
	                                fmt.Printf("%16d%16.4e%16.4e%16.4e%16.4e%16.4e%16.4e%16.4e%16.4e%16.4e%16.4e%16.4e\n", EID, X, Y, Z, XY, YZ, ZX, A, B, C, P, VM)

			            }
				}
			}
		}
	}
}


func readline(scanner *bufio.Scanner) (string, []string) {
	var line string
	var fields []string
	read := scanner.Scan()         
	if (!read) {
		return "can not scan", nil
	}

	line = scanner.Text()
	chline := line[:len(line)-8] //cut last eight numbers as may overlap main text
	fields = strings.Fields(chline)
	return line, fields
}

func splitline(scanner *bufio.Scanner) (string, []string) {
	var line string
	var fields []string
	line = scanner.Text()
	chline := line[:len(line)-8] //cut last eight numbers as may overlap main text
	fields = strings.Fields(chline)
	return line, fields
}

