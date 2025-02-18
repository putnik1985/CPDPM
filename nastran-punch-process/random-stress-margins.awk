BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file

	if (ARGC < 5){
		print "usage awk -f random-stress-margins.awk file=inp.pch Fy=48. Fu=61. FSy=1.25 FSu=2.";
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
	
    printf("\n\n%12s%12s%12s%12s\n", "Element", "VM, ksi", "MOS Yield", "MOS Ultimate")
	
	mos_yield_min = 1000.
	mos_ultimate_min = 1000.
	
	while (readline()){
	       ###print $0
		   
           if ($0 ~ /\$ELEMENT STRESSES - RMS/){
		       readline();
			   readline();
			   readline();
			   if ($4 == type["ctetra"]){
			   readline();
			   
			       while(readline() && $0 !~ /TITLE/){

				         id = $1
                         if (id !~ /^[0-9]/)
                             continue
							 
						 readline();
                         sxx = $3
						 syy = $4
						 if (NF < 5) { 
						        s = syy; 
								syy = substr(s, 1, length(s) - 8)
						 } 
						 
						 readline();
						 szz = $2
						 sxy = $3
						 syz = $4
						 if (NF < 5) { 
						        s = syz; 
								syz = substr(s, 1, length(s) - 8)
						 } 
						 
						 readline();
                         sxz = $2
						 
						 ####print id, sxx, syy, szz, sxy, sxz, syz
						 
						 sxx *=  3.
						 syy *= -3.
						 szz *= -3.
						 sxy *=  3.
						 sxz *=  3.
						 syz *=  3.
						 
                         vm = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + (sxx - szz) * (sxx - szz) + (syy - szz) * (syy - szz) + 6 * ( sxy * sxy + sxz * sxz + syz * syz))
                         ##
						 
						 vm /= 1000. ## convert to ksi
						 mos_yield = Fy / (FSy * vm) - 1
						 mos_ultimate = Fu / (FSu * vm) - 1
						 printf("%12d%12.2f%12.2f%12.2f\n", id, vm, mos_yield, mos_ultimate)
						 
						 if (mos_ultimate < mos_ultimate_min){
						     element_ultimate = id
						     mos_ultimate_min = mos_ultimate
						 }
						
                         if (mos_yield < mos_yield_min){
						     element_yield = id
                             mos_yield_min = mos_yield
						 }
						 
						 if (vm > vm_max){
							 element_vm = id
						     vm_max = vm
						 }
						 
				   }
				   
			   mos_yield = Fy / (FSy * vm_max) - 1
			   mos_ultimate = Fu / (FSu * vm_max) - 1
			   #printf("\n%28s:\n","Summary");
			   #printf("%12d%12.2f%12.2f%12.2f\n", element_vm, vm_max, mos_yield, mos_ultimate)
			   }
			   

		    }
	}

					      printf("\n\n%12s%12s%12.2f%12.2f\n", "Minimum", " MOS", mos_yield_min, mos_ultimate_min)
						  print ""
						  printf("Maximum VonMises element#: %12d\n", element_vm)
						  printf("Minimum    yield element#: %12d\n", element_yield)
						  printf("Minimum ultimate element#: %12d\n", element_ultimate)						  
						  
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