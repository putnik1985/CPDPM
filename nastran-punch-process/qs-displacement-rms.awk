BEGIN{ 
	
	if (ARGC < 2){
		print "usage awk -f qs-displacement-rms file=inp.pch";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	
    printf("\n\n%36s%12s%12s%12s%12s\n", "Subcase", "X, RMS", "Y, RMS", "Z, RMS", "3D, RMS")
	
	while (readline()){
	       if($0 ~ /\$LABEL/) {
		                       split($0, out1, "=")
							   label1 = out1[2]
							   m = split(label1, out2)
							   label = "";
							   for(i=1; i < m; ++i)
							       label = label " " out2[i]
							   ####print label
		   }
		   
           if ($0 ~ /SUBCASE ID/){
		           subcase = $4
				   xrms = 0.;
				   yrms = 0.;
				   zrms = 0.;
				   rms3D = 0.;
				   
				   N = 0;
			       while(readline() && $0 !~ /TITLE/){
						 xrms += $3 * $3
						 yrms += $4 * $4
						 zrms += $5 * $5
						 rms3D += $3 * $3 + $4 * $4 + $5 * $5
						 
						 ++N
						 readline();
				   }
				    xrms =  sqrt(xrms/N)
				    yrms =  sqrt(yrms/N)
				    zrms =  sqrt(zrms/N)
				   rms3D = sqrt(rms3D/N)
				   
				   printf("%36s%12.4f%12.4f%12.4f%12.4f\n", label, xrms, yrms, zrms, rms3D);

			   }
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