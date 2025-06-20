BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 8){
		print "usage awk -f qs-edf-list-margins.awk file=inp.pch dia=0.625 Fy=145. Fu=155. Fsu=97. FSy=1.25 FSu=2. edf_list=list.txt";
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
	Fy  = data["Fy"];
	Fu  = data["Fu"];
	Fsu = data["Fsu"];

	FSy  = data["FSy"];
	FSu  = data["FSu"];
        edf_list = data["edf_list"]
        while(getline < edf_list > 0){
          edf[++nedf] = $1
        }

        pi = 3.14159;
	print "Input:"
	printf("D =%f, Fy =%f, Fu =%f, Fsu = %f, FSy = %f, FSu = %f\n", dia, Fy, Fu, Fsu, FSy, FSu)
	
        printf("\n\n%12s%12s%12s%12s%12s\n", "Subcase", "EDF#", "MOS Yield", "MOS Ultimate", "MOS Shear")
	
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
	shear_limit = Fsu * 2.* A
	mos_shear_min = 1000.
	mos_yield_min = 1000.
	mos_ultimate_min = 1000.
	
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
						 ####print case_number, id
						 shear_force = sqrt(fy * fy + fz * fz)
						 bending = sqrt(my * my + mz * mz)
						 stress = bending * ymax / Jd + abs(fx) / A
						 
						 mos_shear = shear_limit / (FSu * shear_force) - 1
						 mos_yield = Fy / (FSy * stress) - 1
						 mos_ultimate = Fu / (FSu * stress) - 1

						 cbush_shear[id] = mos_shear
                                                 cbush_ultimate[id] = mos_ultimate
                                                 cbush_yield[id] = mos_yield
 
							 
						 
				   }   
                                   for(i=1; i<=nedf; ++i){
                                       num = edf[i]
                                       printf("%12d%12d%12.2f%12.2f%12.2f\n", case_number, num, cbush_yield[num], cbush_ultimate[num], cbush_shear[num])
                                       mos_shear = cbush_shear[num]
                                       mos_ultimate = cbush_ultimate[num]
                                       mos_yield = cbush_yield[num]

						 if (mos_shear < mos_shear_min){
                                                     edf_shear = num 						 
						     mos_shear_min = mos_shear
						 }
						 
						 if (mos_ultimate < mos_ultimate_min){
						     edf_ultimate = num
						     mos_ultimate_min = mos_ultimate
						 }
						
                                                 if (mos_yield < mos_yield_min){
						     edf_yield = num
                                                     mos_yield_min = mos_yield
						 }
                                   }
			   }
		    }
	}

        printf("\n\n%12s%12s%12.2f%12.2f%12.2f\n\n", "Minimum", " MOS", mos_yield_min, mos_ultimate_min, mos_shear_min)
						  print ""
						  printf("Minimum    yield edf#: %12d\n", edf_yield)
						  printf("Minimum ultimate edf#: %12d\n", edf_ultimate)
						  printf("Minimum    share edf#: %12d\n", edf_shear)						  
						  
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
