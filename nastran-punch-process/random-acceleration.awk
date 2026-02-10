BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 4){
		print "usage awk -f random-acceleration.awk file=inp.pch  point_id=15630394 G=9.81 transform=local-to-global.txt";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	     file  = data["file"];
	 point_id  = data["point_id"];
     G = data["G"];

	matrix_file = data["transform"]

	if (getline < matrix_file > 0){
	    n = split($0, out, ",")
		x[1] = out[1]
		x[2] = out[2]
		x[3] = out[3]
	}
	
	if (getline < matrix_file > 0){
	    n = split($0, out, ",")
		y[1] = out[1]
		y[2] = out[2]
		y[3] = out[3]
	}

	if (getline < matrix_file > 0){
	    n = split($0, out, ",")
		z[1] = out[1]
		z[2] = out[2]
		z[3] = out[3]
	}
	
	printf("Output is in the Displacement Coordinate System\n")
	printf("%12s,\n", point_id)
	printf("%12s,%12s,%12s,%12s,\n","Frequency", "Ax", "Ay", "Az")
	while (getline < file > 0){
		if ($0 ~ /\$ACCELERATION - PSDF/){
            getline < file;
			getline < file;
			getline < file;
            scale = 1./(G * G)
			if ($4 == point_id){
			    while (getline < file > 0 && $0 !~ /\$TITLE/){
				###print $0;
				freq = $1;
				ax = $3 * scale;
				ay = $4 * scale;
				az = $5 * scale;
				if (freq ~ /^[0-9]/)
				    printf("%12.1f,%12.8f,%12.8f,%12.8f,\n", freq, ax, ay, az)
				}
			}#####if ($4 == point_id)
			
		}###if ($0 ~ /\$ACCELERATION - PSDF/)
		if ($0 ~ /\$ACCELERATION - RMS/){
            getline < file;
			getline < file;
			getline < file;		
            while (getline < file > 0 && $0 !~ /\$TITLE/){
                if ($1 == point_id){
                    printf("\n\n%12s,%12.2f,%12.2f,%12.2f,\n","RMS", $3 / G, $4 / G, $5 / G);
                    printf("%12s,%12.2f,%12.2f,%12.2f,\n","3 x RMS", 3 * $3 / G, 3 * $4 / G, 3 * $5 / G);
                }					
            }			 
		}
	}####while (getline < file > 0)
}

