BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 3){
		print "usage awk -f shock-edf-margins.awk file=inp.pch mass=20. g=9.81";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	mass  = data["mass"];
	g = data["g"];
	
    pi = 3.14159;
	
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
	shear_limit = Fsu * 2.* A 
	
	while (readline()){
           if ($0 ~ /SUBCASE ID/){
		       case_number = $4;
			   readline();
			   if ($4 == type["cbush"]){
			       readline()
			       while(readline() && $0 !~ /TITLE/){
				         id = $1
						 fx = $2
						 fy = $3
						 fz = $4
						 f += sqrt(fx*fx + fy*fy + fz*fz)
						 readline();
						 mx = $2
						 my = $3
						 mz = $4
						 
				   }
			   }
		    }
	}
	
	printf("G load:%12.2f\n", f/(mass * g))

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