BEGIN {

    if (ARGC < 2){
		print "usage awk -f qs-rotate-90-y.awk file=model.dat";
		exit;
	}
	
	FS = ","
	for(i=1;i<=ARGC;++i){
	    n = split(ARGV[i],out,"=")
	    #####print out[1], out[2]
	    data[out[1]] = out[2]
        }
	dx = data["dx"] 
	dy = data["dy"]
	dz = data["dz"]
	file = data["file"]
	x0 = -1138.96
	y0 = 74.778
	z0 = 5147.853
	scale = 0.001
	x0 *= scale
	y0 *= scale
	z0 *= scale
	pi = 3.14159
	teta = -pi / 2.
	
	while(readline()){
	      ###print $0
           if ($0 ~ /^CORD2R/) {
		  
		      id = $2
			  rcsys = $3
			  
			  x = $4 - x0
			  y = $5 - y0
			  z = $6 - z0
			  
			  x1 = cos(teta) * x - z * sin(teta)
			  y1 = y
			  z1 = sin(teta) * x + z * cos(teta)
			  
		      $4 = x0 + x1; 
			  $5 = y0 + y1; 
			  $6 = z0 + z1; 

			  x = $7 - x0
			  y = $8 - y0
			  z = $9 - z0

			  x1 = x * cos(teta) - z * sin(teta)
			  y1 = y
			  z1 = x * sin(teta) + z * cos(teta)

		      $7 = x0 + x1; 
			  $8 = y0 + y1; 
			  $9 = z0 + z1; 
			  
			  printf("CORD2R,%d,%d,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,+\n", id, rcsys, $4, $5, $6, $7, $8, $9)
			  readline()

			  x = $2 - x0
			  y = $3 - y0
			  z = $4 - z0

			  x1 = x * cos(teta) - z * sin(teta)
			  y1 = y
			  z1 = x * sin(teta) + z * cos(teta)

		      $2 = x0 + x1; 
			  $3 = y0 + y1; 
			  $4 = z0 + z1; 

              printf("+,%.6f,%.6f,%.6f,\n", $2, $3, $4)
			  
		  } else if ($0 ~ /^CBAR/) {
			  x = $6
			  y = $7
			  z = $8

			  x1 = x * cos(teta) - z * sin(teta)
			  y1 = y
			  z1 = x * sin(teta) + z * cos(teta)
			  printf("CBAR,%d,%d,%d,%d,%.6f,%.6f,%.6f,\n", $2, $3, $4, $5, x1, y1, z1)
		  
          } else { 
		           print $0
		   }
    }
	
}

function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}