BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 3){
		print "usage awk -f random-cbush-loads.awk file=inp.pch  element_id=15630394";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	     file  = data["file"];
	 element_id  = data["element_id"];
     G = 386.1;
	 
	printf("%12s%12s%12s%12s%12s%12s%12s\n","Frequency", "Fx", "Fy", "Fz", "Mx", "My", "Mz")
	while (getline < file > 0){
	
		if ($0 ~ /\$ELEMENT FORCES - PSDF/){

            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}
			
            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}

            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}

			if ( $4 != type["cbush"]) continue;
            scale = 1.;

			if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}

			if ($4 == element_id){
			    while (getline < file > 0 && $0 !~ /\$TITLE/){
				###print $0;
				freq = $1;
				fx = $2;
				fy = $3;
				fz = $4;

            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}
				mx = $2;
				my = $3;
				mz = $4;
				
				if (freq ~ /^[0-9]/)
				    printf("%12.1f%12.2f%12.2f%12.2f%12.2f%12.2f%12.2f\n", freq, fx, fy, fz, mx, my, mz)
				}
			}#####if ($4 == element_id)
			
		}###if ($0 ~ /\$ELEMENT FORCES - PSDF/)
		
		if ($0 ~ /\$ELEMENT FORCES - RMS/){
		
            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}

            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}

            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}
			
            if ( $4 != type["cbush"]) continue;
            while (getline < file > 0 && $0 !~ /\$TITLE/){
                if ($1 == element_id){
				
				    fx = $2;
					fy = $3;
					fz = $4;

            if (!readline()) { 
			        printf("can not read file: %12s\n", file);
					exit;
			}
				    mx = $2;
                    my = $3;
                    mz = $4;
					
                    printf("\n%12s%12.2f%12.2f%12.2f%12.2f%12.2f%12.2f\n", "RMS:", fx, fy, fz, mx, my, mz);
                    printf("\n%12s%12.2f%12.2f%12.2f%12.2f%12.2f%12.2f\n", "3 x RMS:", 3 * fx, 3 * fy, 3 * fz, 3 * mx, 3 * my, 3 * mz);
					
                }					
            }			 
		}
	}####while (getline < file > 0)
}

function readline(){
       return (getline < file > 0);
}

