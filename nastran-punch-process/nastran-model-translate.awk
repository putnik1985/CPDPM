BEGIN {

    if (ARGC < 5){
		print "usage awk -f qs-displacement-rms file=model.dat dx=0. dy=0. dz=0.29999959893";
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
	
	while(readline()){
	      ###print $0
		  if ($0 ~ /^GRID/ ) {
              id = $2
			  rcsys = $3
			  dcsys = $7
			  
		      $4+=dx; 
			  $5+=dy; 
			  $6+=dz;
			  printf("GRID,%d,%d,%.6f,%.6f,%.6f,%d,\n", id, rcsys, $4, $5, $6, dsys)
			  
		  } else if ($0 ~ /^CORD2R/) {
		  
		         id = $2
			  rcsys = $3
			  
		      $4+=dx; 
			  $5+=dy; 
			  $6+=dz; 

		      $7+=dx; 
			  $8+=dy; 
			  $9+=dz; 
			  
			  printf("CORD2R,%d,%d,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,+\n", id, rcsys, $4, $5, $6, $7, $8, $9)
			  readline()
		      $2+=dx; 
			  $3+=dy; 
			  $4+=dz; 
              printf("+,%.6f,%.6f,%.6f,\n", $2, $3, $4)
			  
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