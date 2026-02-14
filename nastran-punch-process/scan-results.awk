BEGIN { 
### usage awk -f scan-results.awk file_contains_name_of_mos_files
	file = ARGV[1]
	while (getline < file > 0){
		files[++nf] = $0
		##############print files[nf]
	}

	for(i=1; i<=nf; ++i){
	    current = files[i]
            execute = sprintf("awk '{OFS=\",\"; split(\"%s\", out, \".\"); print out[1],$1,$3,$4,$5 }' %s | tail -n 1", current, current)
	    system(execute)
        }
}
