BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
    type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
    type["cquad4"] = 33
    type["ctria3"] = 74
	
	if (ARGC < 6){
		print "usage awk -f qs-stress-margins.awk file=inp.pch Fy=48. Fu=61. FSy=1.25 FSu=2. elements=elements.dat";
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

	elements = data["elements"]
	while(getline < elements > 0){
	  group[++ngroup] = $1
	  #####print group[ngroup]
	}
	
	
    margin_cut_off = 100.
	pi = 3.14159;
	print "Input:"
	printf("Fy =%f, Fu =%f, FSy = %f, FSu = %f\n", Fy, Fu, FSy, FSu)
	
    printf("\n\n%12s%12s%12s%12s\n", "Subcase", "VM, ksi", "MOS Yield", "MOS Ultimate")
	
       	       mos_yield_min = 1.e+32
	           mos_ultimate_min = 1.E+32
	
	while (readline()){
	       
		   if ($0 ~ /\$ELEMENT STRESSES/) {
		       readline()
			   readline()
			   
           if ($0 ~ /SUBCASE ID/){
		       case_number = $4;
			   readline();
               type_number = $4

	           vm_max = 0.
			   
			   if ($4 == type["ctetra"]){
			       
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
						 
						
						 mos_yield = Fy / (FSy * vm) - 1
						 mos_ultimate = Fu / (FSu * vm) - 1
						 ###print case_number, id, vm, mos_ultimate, mos_yield
						 
						 yield[id] = mos_yield
						 ultimate[id] = mos_ultimate
						 stress[id] = vm
						 
				   }
				   
			   }
			   
			   if ($4 == type["cquadr"] || $4 == type["cquad4"] || $4 == type["ctria3"]){
			       
			       while(readline() && $0 !~ /TITLE/){
				         id = $1
						 #### calculate bottom stresses
						 sx = $3
						 sy = $4
						 if (NF < 5) { 
						        s = sy; 
								sy = substr(s, 1, length(s) - 8)
                                ####print sy								
						 }
						 readline()
						 sxy = $2
						 vm_bottom = 1./sqrt(2) * sqrt((sx - sy) * (sx - sy) + (sx * sx) + (sy * sy) + 6 * ( sxy * sxy ))
                         ####print case_number, id, sx, sy, sxy, vm_bottom
						 
						 readline()
						 
						 readline()
						 ##### calculate top stresses
						 sx = $2
						 sy = $3
						 sxy = $4
						 if (NF < 5) { 
						        s = sxy; 
								sxy = substr(s, 1, length(s) - 8)
                                ####print sy								
						 }
						 vm_top = 1./sqrt(2) * sqrt((sx - sy) * (sx - sy) + (sx * sx) + (sy * sy) + 6 * ( sxy * sxy ))
						 #####print case_number, id, sx, sy, sxy, vm_top

                         vm = max(vm_top, vm_bottom)
						 ##############print vm
						 mos_yield = Fy / (FSy * vm) - 1
						 mos_ultimate = Fu / (FSu * vm) - 1
						 #####print id, vm
						 yield[id] = mos_yield
						 ultimate[id] = mos_ultimate
						 stress[id] = vm
                         #####print current_type, case_number, id, yield[id], ultimate[id], stress[id]
						 readline()
						 readline()
						 
				   }
										  
			   }
							  
                                      for(i=1; i<=ngroup; ++i){

                                               id =      group[i]
                                               num = sprintf("%d",id)
                                               mos_ultimate = ultimate[num]
                                               mos_yield =    yield[num] 
                                               vm =   stress[num]
                                              
                                              if (vm <= 1. || mos_yield > margin_cut_off ) continue 

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
									if (vm_max > 0.){  
			                            mos_yield = Fy / (FSy * vm_max) - 1
			                            mos_ultimate = Fu / (FSu * vm_max) - 1
			                            if (type_number == type["cquad4"] || type_number == type["ctetra"] || type_number == type["cquadr"]) 
										    printf("%12d%12.2f%12.2f%12.2f\n", case_number, vm_max, mos_yield, mos_ultimate)
									}

		    }
			}
	}

					      printf("\n\n%12s%12s%12.2f%12.2f\n", "Minimum", " MOS", mos_yield_min, mos_ultimate_min)
						  print ""
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

function max(a, b){
 if (a>b) 
     return a
 else 
     return b
}	 