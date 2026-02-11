BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file

	if (ARGC < 2){
		print "usage awk -f random-spc-loads.awk file=inp.pch mass=604.4 g=9.81 transform=matrix-from-local-to-global.txt peak=3.";
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
	matrix_file = data["transform"]
    peak = data["peak"]
	
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


	
	############print x[1], x[2], x[3], y[1], y[2], y[3], z[1], z[2], z[3]
	printf("Output is in the Global coordinate system of the grids\n");
    printf("\n\n%12s,%12s,%12s,%12s,\n", "Grid", "Xrms", "Yrms", "Zrms")
	
	while (readline()){
	       ###print $0
		   
           if ($0 ~ /\$SPCF - RMS/){
		       readline();
			   readline();
			   readline();
			   
			       while(readline() && $0 !~ /TITLE/){
				      if ($1 ~ /^[0-9]/){
						  fx = x[1] * $3 + x[2] * $4 + x[3] * $5
						  fy = y[1] * $3 + y[2] * $4 + y[3] * $5
						  fz = z[1] * $3 + z[2] * $4 + z[3] * $5
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

	 printf("\n\n%12s,%12s,%12s,%12s,\n", "Case", "X(G)", "Y(G)", "Z(G)")
	 printf("%12s,%12.2f,%12.2f,%12.2f,\n", "Total:", Fx/(mass*G), Fy/(mass*G), Fz/(mass*G))
	 
	 printf("\n\n%12s,%12s,%12s,%12s,\n", "Peaking", "X(G)", "Y(G)", "Z(G)")
	 printf("%12s,%12.2f,%12.2f,%12.2f,\n", "Total:", peak * Fx/(mass*G), peak * Fy/(mass*G), peak * Fz/(mass*G))
						  
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