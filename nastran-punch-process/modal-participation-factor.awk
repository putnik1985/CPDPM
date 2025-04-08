BEGIN{ 

	if (ARGC < 2){
		print "usage awk -f modal-participation-factor.awk file=inp.pch";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     data[a[1]] = a[2];
        }

	file  = data["file"];
    pi = 3.14159;

	
    printf("%16s,%16s,%16s,%16s,%16s,%16s,%16s,%16s,\n", "Mode#", "Frequency(Hz)", "T1", "T2", "T3", "R1", "R2", "R3");
	
	while (readline()){
	       ###print $0
		   
           if ($0 ~ /\$MODAL PARTICIPATION FACTORS/){
		        readline();
			    readline();
			   
			       while(readline() && $0 !~ /TITLE/){
				      ####print $0
				      if ($1 ~ /^[0-9]/){
					      mode = $1
						  t1 = $2
						  t2 = $3
						  t3 = $4
						  readline();
						  r1 = $2
						  r2 = $3
						  r3 = $4
                          factors[++precords] = sprintf("%16.3f,%16.3f,%16.3f,%16.3f,%16.3f,%16.3f,", t1, t2, t3, r1, r2, r3); 
						}
						 
				   }
		    }
			
			if ($0 ~ /\$EIGENVALUE/){
			    frequency[++frecords] = sqrt($3) / (2.*pi)
			}
	}
	 
	if (frecords != precords) {
        printf("frequency records does not match factors records\n")
        exit
    }

    for(i=1; i<= frecords; ++i){
        printf("%16d,%16.2f,%s\n", i, frequency[i], factors[i])
    }		
						  
}

function abs(x){
  if (x > 0) 
      return x
  else 
      return -x;
}

function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}