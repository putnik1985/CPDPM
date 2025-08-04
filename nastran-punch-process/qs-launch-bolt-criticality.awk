BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 4){
		print "usage awk -f qs-edf-list-margins.awk file=inp.pch dia=0.625 elements=list.txt ultimate=ult";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	dia  = data["dia"];
    ultimate = data["ultimate"]
	
        edf_list = data["elements"]
        while(getline < edf_list > 0){
          edf[++nedf] = $1
        }

    pi = 3.14159;
	
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
	
	while (readline()){
           if ($0 ~ /SUBCASE ID/){
		       case_number = $4;
			   readline();
			   if ($4 == type["cbush"]){
			       while(readline() && $0 !~ /TITLE/){
				                 id = $1
						 fx = $2
						 fy = $3
						 fz = $4
						 readline();
						 mx = $2
						 my = $3
						 mz = $4
						 ###print case_number, id, fx, fy, fz, mx, my, mz
						 shear_force = sqrt(fy * fy + fz * fz)
						 bending = sqrt(my * my + mz * mz)
						 sigma = bending * ymax / Jd + abs(fx) / A
						 shear = shear_force / A
                         vm = sqrt(sigma * sigma + 3 * shear * shear)						 
                         stress[id] = vm						  
						 
				   }   
								   for(i=1; i<=nedf; ++i){
                                       id = edf[i]
									   num = sprintf("%d",id)
						               vm = stress[num]
									   
					                   if (vm > vm_max){
						                   vm_max = vm
					                   }
                                   }
			   }
		    }
	}


                                          printf("%.2f\%\n", vm_max * 100. / ultimate)

						  
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
