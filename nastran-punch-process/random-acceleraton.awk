BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 3){
		print "usage awk -f random-acceleration.awk file=inp.pch  point_id=15630394";
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
     G = 386.1;
	 
	printf("%12s%12s%12s%12s\n","Frequency", "Ax", "Ay", "Az")
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
				    printf("%12.1f%12.8f%12.8f%12.8f\n", freq, ax, ay, az)
				}
			}#####if ($4 == point_id)
			
		}###if ($0 ~ /\$ACCELERATION - PSDF/)
		if ($0 ~ /\$ACCELERATION - RMS/){
            getline < file;
			getline < file;
			getline < file;		
            while (getline < file > 0 && $0 !~ /\$TITLE/){
                if ($1 == point_id)
                    printf("RMS: %12.2f, %12.2f, %12.2f\n", $3 / G, $4 / G, $5 / G);     			
            }			 
		}
	}####while (getline < file > 0)
}

