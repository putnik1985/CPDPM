BEGIN{
      if (ARGC < 5){
	       print "usage: awk -f sine-stress-margins.awk file=input.pch Fy=48. Fu=61. FSy=1.25 FSu=2.";
	       exit;
       }

        type["ctetra"] = 39;
	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	     file  = data["file"];
	     Fy  = data["Fy"];
	     Fu  = data["Fu"];
	     FSy  = data["FSy"];
	     FSu  = data["FSu"];
		 
		 type_number = type["ctetra"];
		 
         record = 0;
	current_subcase = 0;

    pi = 3.14159
	mos_yield_min = 1000.
	mos_ultimate_min = 1000.
	
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

						readline()
						if ($4 != type_number) continue
						
						readline()
						freq = $3
						
						while(readline() && $0 !~ /\$TITLE/){
						  element_id = $1
						  
						  if (element_id ~ /^[1-9]/){
							  readline()
							  sxx = $3
							  syy = $4
                              syy = correct_number(syy)
							  readline()
							  szz = $2
							  sxy = $3
							  syz = $4
							  syz = correct_number(syz)
							  readline()
							  szx = $2
							  ###print element_id, freq, sxx, syy, szz, sxy, syz, szx
							  calculate_margins()
							  #######print subcase, mos_yield_min
						         yield[subcases] = mos_yield_min
							  ultimate[subcases] = mos_ultimate_min

								 
								    element_yield[subcases] = eyield
								 element_ultimate[subcases] = eultimate
									
									   fyield[subcases] = freq_yield
									fultimate[subcases] = freq_ultimate							  
						  }
						  
						}
						
					} else {
					
						readline()
						if ($4 != type_number) continue
						
						readline()
						freq = $3

						while(readline() && $0 !~ /\$TITLE/){
						  element_id = $1
						  
						  if (element_id ~ /^[1-9]/){
							  readline()
							  sxx = $3
							  syy = $4
							  syy = correct_number(syy)
							  readline()
							  szz = $2
							  sxy = $3
							  syz = $4
							  syz = correct_number(syz)
							  readline()
							  szx = $2
							  #####print element_id, freq, sxx, syy, szz, sxy, syz, szx
							  calculate_margins()
							    
						         yield[subcases] = mos_yield_min
							  ultimate[subcases] = mos_ultimate_min

								 
								    element_yield[subcases] = eyield
								 element_ultimate[subcases] = eultimate
									
									   fyield[subcases] = freq_yield
									fultimate[subcases] = freq_ultimate
									
					       }
					    }
		            } 
        }####if ($0 ~ /SUBCASE ID/){					
    }####while (readline()){				

    printf("Materials Input:\n");
	printf("Fy(ksi) =%f, Fu(ksi) =%f, FSy = %f, FSu = %f\n", Fy, Fu, FSy, FSu)
	
    printf("\n\nMargins of Safety(MOS):\n");
    printf("%12s,%12s,%12s,\n","Subase#", "Yield", "Ultimate")
    for(i=1; i<=subcases; ++i)
	    printf("%12d,%12.2f,%12.2f,\n", i, yield[i], ultimate[i])

    printf("\n\nCritical Elements:\n");
    printf("%12s,%12s,%12s,\n","Subase#", "Yield", "Ultimate")
    for(i=1; i<=subcases; ++i)
	    printf("%12d,%12d,%12d,\n", i, element_yield[i], element_ultimate[i])


    printf("\n\nCritical Frequencies(Hz):\n");
    printf("%12s,%12s,%12s,\n","Subase#", "Yield", "Ultimate")
    for(i=1; i<=subcases; ++i)
	    printf("%12d,%12.2f,%12.2f,\n", i, fyield[i], fultimate[i])
		
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

function correct_number(sx){
      temp = sx
      if (NF < 5) { 
        s = temp; 
		temp = substr(s, 1, length(s) - 8)
      }
	  return temp
}	  

function calculate_margins(){

                         vm = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + (sxx - szz) * (sxx - szz) + (syy - szz) * (syy - szz) + 6 * ( sxy * sxy + szx * szx + syz * syz))
						 
						 vm /= 1000. ## convert to ksi
						 mos_yield = Fy / (FSy * vm) - 1
						 mos_ultimate = Fu / (FSu * vm) - 1
						 
						 if (mos_ultimate < mos_ultimate_min){
						     eultimate = element_id
							 freq_ultimate = freq
						     mos_ultimate_min = mos_ultimate
						 }
						
                         if (mos_yield < mos_yield_min){
						     eyield = element_id
							 freq_yield = freq
                             mos_yield_min = mos_yield
						 }
						 
						 if (vm > vm_max){
						     vm_max = vm
							 efreq = element_id
							 max_freq = freq
						 }
}