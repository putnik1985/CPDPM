BEGIN{
      if (ARGC < 7){
	       print "usage: awk -f sine-edf-margins.awk file=input.pch dia=0.625 Fy=145. Fu=155. Fsu=97. FSy=1.25 FSu=2.";
	       exit;
       }

        type["cbush"] = 102;
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
		 
		 type_number = type["cbush"];
		 
         record = 0;
	current_subcase = 0;

    pi = 3.14159
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
	shear_limit = Fsu * 2.* A * 1000.
	mos_shear_min = 1000.
	mos_yield_min = 1000.
	mos_ultimate_min = 1000.
    ######print A, Jd, ymax
	
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
                    if (current_subcase != $4) {
					    current_subcase = $4
						++subcases
						
					    printf("\n%12s,%12d,%24s,\n", "Subcase", current_subcase, label)

						readline()
						if ($4 != type_number) continue
						
						readline()
						freq = $3
						
						##print freq
						while(readline() && $0 !~ /\$TITLE/){
						  point_id = $1
						  
						  if (point_id ~ /^[1-9]/){
							  readline()
							  printf("%12s,%12s,%12s,%12s,%12s,%12s,%12s,%12s,","Point ID", "Freq(Hz)", "Fx", "Fy", "Fz", "Mx", "My", "Mz")
						  }
						  
						}
						printf("\n");
						
					} else {
					
						readline()
						if ($4 != type_number) continue
						
						readline()
						freq = $3
						##print freq

						while(readline() && $0 !~ /\$TITLE/){
						  point_id = $1
						  
						  if (point_id ~ /^[1-9]/){
						      ##print point_id
							  fx = $2
							  fy = $3
							  fz = $4
							  readline()
							  mx = $2
							  my = $3
							  mz = $4
							  printf("%12d,%12.2f,%12.2f,%12.2f,%12.2f,%12.2f,%12.2f,%12.2f,",point_id, freq, fx, fy, fz, mx, my, mz)
							  
						      shear_force = sqrt(fy * fy + fz * fz)
						      bending = sqrt(my * my + mz * mz) / 1000. ### convert to ksi
						      stress = bending * ymax / Jd

						      mos_shear = shear_limit / (FSu * shear_force) - 1
						      mos_yield = Fy / (FSy * stress) - 1
						      mos_ultimate = Fu / (FSu * stress) - 1
						 
						      if (mos_shear < mos_shear_min){
                                  edf_shear = point_id
                                  freq_shear = freq 								  
						          mos_shear_min = mos_shear
						      }
						 
						      if (mos_ultimate < mos_ultimate_min){
						          edf_ultimate = point_id
								  freq_ultimate = freq
						          mos_ultimate_min = mos_ultimate
						      }
						
                              if (mos_yield < mos_yield_min){
						          edf_yield = point_id
								  freq_yield = freq
                                  mos_yield_min = mos_yield
						      }
							    
						         yield[subcases] = mos_yield_min
							  ultimate[subcases] = mos_ultimate_min
							     shear[subcases] = mos_shear_min
								 
								    element_yield[subcases] = edf_yield
								 element_ultimate[subcases] = edf_ultimate
								    element_shear[subcases] = edf_shear
									
									   fyield[subcases] = freq_yield
									fultimate[subcases] = freq_ultimate
									   fshear[subcases] = freq_shear
								 
						  }
						  
						}
						printf("\n");
					
					}
		   }           
	}

    printf("\n\nEDF input:\n");
	printf("D(in)=%f, Fy(ksi) =%f, Fu(ksi) =%f, Fsu(ksi) = %f, FSy = %f, FSu = %f\n", dia, Fy, Fu, Fsu, FSy, FSu)
	
    printf("\n\nMargins of Safety(MOS):\n");
    printf("%12s,%12s,%12s,%12s,\n","Subase#", "Yield", "Ultimate", "Shear")
    for(i=1; i<=subcases; ++i)
	    printf("%12d,%12.2f,%12.2f,%12.2f\n", i, yield[i], ultimate[i], shear[i])

    printf("\n\nCritical EDFs:\n");
    printf("%12s,%12s,%12s,%12s,\n","Subase#", "Yield", "Ultimate", "Shear")
    for(i=1; i<=subcases; ++i)
	    printf("%12d,%12.2f,%12.2f,%12.2f\n", i, element_yield[i], element_ultimate[i], element_shear[i])


    printf("\n\nCritical Frequencies(Hz):\n");
    printf("%12s,%12s,%12s,%12s,\n","Subase#", "Yield", "Ultimate", "Shear")
    for(i=1; i<=subcases; ++i)
	    printf("%12d,%12.2f,%12.2f,%12.2f\n", i, fyield[i], fultimate[i], fshear[i])

}

function max(a,b){
	if (a > b)
            return a;
	else 
	    return b;
}

function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}
