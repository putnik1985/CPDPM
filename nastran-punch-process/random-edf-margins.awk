BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file
	
    margin_cut_off = 100.
	if (ARGC < 8){
		print "usage awk -f random-stress-margins.awk file=inp.pch dia=0.625 Fy=48. Fu=61. Fsu=97. FSy=1.25 FSu=2. elements=elements.dat";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	Fy  = data["Fy"];
	Fu  = data["Fu"];
	Fsu = data["Fsu"];
	
	FSy  = data["FSy"];
	FSu  = data["FSu"]	
	dia  = data["dia"];
	
	elements = data["elements"]
	while(getline < elements > 0){
	  group[++ngroup] = $1
	}
	
	print "Elements Of The Group"
	for(i=1; i<=ngroup; ++i)
	    print group[i]

	print ""
	print ""
	
    pi = 3.14159;
    print "Input:"
    printf("Fy =%f, Fu =%f, FSy = %f, FSu = %f\n\n", Fy, Fu, FSy, FSu)
	
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
	shear_limit = Fsu * 2.* A
	
	while (readline()){
	       ###print $0
		   
           if ($0 ~ /\$ELEMENT FORCES - RMS/){
		       readline();
			   readline();
			   readline();
			   if ($4 == type["cbush"]){
			       readline()

				   while(getline < file > 0 && $0 !~ /\$TITLE/){

				         id = $1
						 fx = $2
						 fy = $3
						 fz = $4
						 readline();
						 mx = $2
						 my = $3
						 mz = $4
						 
                         ####print id, fx, fy, fz, mx, my, mz
						 shear_force = sqrt(fy * fy + fz * fz)
						     bending = sqrt(my * my + mz * mz)
						      stress = bending * ymax / Jd
						     tensile = fx / A
						     stress += tensile

						 mos_shear = shear_limit / (FSu * shear_force) - 1
						 mos_yield = Fy / (FSy * stress) - 1
						 mos_ultimate = Fu / (FSu * stress) - 1

						 cbush_shear[id] = mos_shear
                         cbush_ultimate[id] = mos_ultimate
                         cbush_yield[id] = mos_yield
						 
				   }
			   }
		    }
	}
                                          print ""
                                          print "MOS Stress Distribution Of The Selected Group"
                                          printf("\n%36s%12s%12s%12s\n", "Element", "MOS Yield", "MOS Ultimate", "MOS Shear")
	                                      mos_yield_min = 1.E+32
	                                      mos_ultimate_min = 1.E+32
										  mos_shear_min = 1.E+32


                                          for(i=1; i<=ngroup; ++i){
                                                         id =      group[i]
                                                        num = sprintf("%d",id)
                                               mos_ultimate = cbush_ultimate[num]
                                                  mos_yield = cbush_yield[num] 
                                                  mos_shear = cbush_shear[num]

					                           printf("%36d%12.2f%12.2f%12.2f\n", num, mos_yield, mos_ultimate, mos_shear)

					       if (mos_ultimate < mos_ultimate_min){
						     element_ultimate = id
						     mos_ultimate_min = mos_ultimate
				         	}
						
                             if (mos_yield < mos_yield_min){
						        element_yield = id
                                mos_yield_min = mos_yield
					         }

                             if (mos_shear < mos_shear_min){
						        element_shear = id
                                mos_shear_min = mos_shear
					         }
						 
                                          }

					          printf("\n\n%36s%12.2f%12.2f%12.2f\n", "Minimum", mos_yield_min, mos_ultimate_min, mos_shear_min)
						  print ""
						  printf("Minimum    yield element#: %12d\n", element_yield)
						  printf("Minimum ultimate element#: %12d\n", element_ultimate)						  
						  printf("Minimum    shear element#: %12d\n", element_shear)						  
						  
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

function max(a, b){
 if (a>b) 
     return a
 else 
     return b
}
