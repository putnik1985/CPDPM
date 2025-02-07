BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file

	if (ARGC < 5){
		print "usage awk -f qs-stress-margins.awk file=inp.pch Fy=48. Fu=61. FSy=1.25 FSu=2.";
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

	FSy  = data["FSy"];
	FSu  = data["FSu"];

    pi = 3.14159;
	print "Input:"
	printf("Fy, ksi =%f, Fu, ksi =%f, FSy = %f, FSu = %f\n", Fy, Fu, FSy, FSu)
	
    printf("\n\n%12s%12s%12s%12s\n", "Subcase", "VM, ksi", "MOS Yield", "MOS Ultimate")
	
	mos_yield_min = 1000.
	mos_ultimate_min = 1000.
	
	while (readline()){
           if ($0 ~ /SUBCASE ID/){
		       case_number = $4;
			   readline();
			   if ($4 == type["ctetra"]){
			       vm_max = 0.
			       while(readline() && $0 !~ /TITLE/){

				         id = $1
                         if (id !~ /^[0-9]/)
                             continue
							 
						 readline();
                         sxx = $3
						 sxy = $4
						 if (NF < 5) { 
						        s = sxy; 
								sxy = substr(s, 1, length(s) - 8)
                                ####print sxy								
						 } 
						 
						 readline();
						 readline();
						 
						 readline();
						 syy = $2
						 syz = $3
						 
						 readline();
						 readline();
						 szz = $2
						 sxz = $3
						 readline();
						 
                         vm = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + (sxx - szz) * (sxx - szz) + (syy - szz) * (syy - szz) + 6 * ( sxy * sxy + sxz * sxz + syz * syz))
                         ##print case_number, id, vm, sxx, syy, szz, sxy, sxz, syz
						 
						 vm /= 1000. ## convert to ksi
						 mos_yield = Fy / (FSy * vm) - 1
						 mos_ultimate = Fu / (FSu * vm) - 1
						 ###print case_number, id, vm, mos_ultimate, mos_yield
						 
						 if (mos_ultimate < mos_ultimate_min){
						     edf_ultimate = id
						     mos_ultimate_min = mos_ultimate
						 }
						
                         if (mos_yield < mos_yield_min){
						     edf_yield = id
                             mos_yield_min = mos_yield
						 }
						 
						 if (vm > vm_max){
						     vm_max = vm
							 max_case = case_number
						 }
						 
				   }
				   
			   mos_yield = Fy / (FSy * vm_max) - 1
			   mos_ultimate = Fu / (FSu * vm_max) - 1
			   printf("%12d%12.2f%12.2f%12.2f\n", case_number, vm_max, mos_yield, mos_ultimate)
			   }
			   

		    }
	}

					      printf("\n\n%12s%12s%12.2f%12.2f\n", "Minimum", " MOS", mos_yield_min, mos_ultimate_min)
						  print ""
						  printf("Minimum    yield element#: %12d\n", edf_yield)
						  printf("Minimum ultimate element#: %12d\n", edf_ultimate)						  
						  
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