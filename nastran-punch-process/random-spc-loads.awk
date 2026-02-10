BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file

	if (ARGC < 2){
		print "usage awk -f random-spc-loads.awk file=inp.pch mass=604.4 g=9.81";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
     mass = data["mass"];
    pi = 3.14159;
	G = data["g"];
	
	
    printf("\n\n%12s,%12s,%12s,%12s,\n", "Grid", "Xrms", "Yrms", "Zrms")
	
	while (readline()){
	       ###print $0
		   
           if ($0 ~ /\$SPCF - RMS/){
		       readline();
			   readline();
			   readline();
			   
			       while(readline() && $0 !~ /TITLE/){
				      if ($1 ~ /^[0-9]/){
						  fx = $3
						  fy = $4
						  fz = $5
						  printf("%12d,%12.2f,%12.2f,%12.2f,\n", $1, fx, fy, fz)
						  Fx += fx
						  Fy += fy
						  Fz += fz
						 }
						 
				   }
		    }
	}
	 printf("\n\n%12s,%12s,%12s,%12s,\n", "Case", "Xrms", "Yrms", "Zrms")
	 printf("%12s,%12.2f,%12.2f,%12.2f,\n", "Total:", Fx, Fy, Fz)

	 printf("\n\n%12s,%12s,%12s,%12s,\n", "Case", "X, G", "Y, G", "Z, G")
	 printf("%12s,%12.2f,%12.2f,%12.2f,\n", "Total:", Fx/(mass*G), Fy/(mass*G), Fz/(mass*G))
	 
						  
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