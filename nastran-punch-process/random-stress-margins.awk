BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file CTETRA4
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
        type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
        type["cquad4"] = 33
        type["ctria3"] = 74

        margin_cut_off = 100.
	if (ARGC < 6){
		print "usage awk -f random-stress-margins.awk file=inp.pch Fy=48. Fu=61. FSy=1.25 FSu=2. elements=elements.dat";
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
	}
	print "Elements Of The Group"
	for(i=1; i<=ngroup; ++i)
	    print group[i]

	print ""
	print ""
	
    pi = 3.14159;
    print "Input:"
    printf("Fy =%f, Fu =%f, FSy = %f, FSu = %f\n\n", Fy, Fu, FSy, FSu)
    print "Stress Distribution Of The Entire Model"	
    printf("\n%24s%12s%12s%12s%12s\n", "Element Type", "Element", "VM", "MOS Yield", "MOS Ultimate")
	
        ##stress[1] = 0.
        ##yield[1] = 0.
        ##ultimate[1] = 0.
	
	while (readline()){
	       ###print $0
		   
           if ($0 ~ /\$ELEMENT STRESSES - RMS/){
		           readline();
			   readline();
			   readline();
			   if ($4 == type["chexa"]){
                           ## read stresses in the middle of the element
			       readline()
				   while(readline() && $0 !~ /TITLE/){
                                         id = $1
                                         if (id !~ /^[0-9]/)
                                             continue

                                         readline()
                                         sxx = $3
					 syy = $4
						 if (NF < 5) { 
						        s = syy; 
							syy = substr(s, 1, length(s) - 8)
						 } 
                                          readline()
                                          szz = $2
                                          sxy = $3
				          syz = $4
						 if (NF < 5) { 
						        s = syz; 
								syz = substr(s, 1, length(s) - 8)
						 } 
                                           readline()
                                           szx = $2

						 sxx *=  3.
						 syy *= -3.
						 szz *= -3.
						 sxy *=  3.
						 szx *=  3.
						 syz *=  3.
						 
                         vm = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + (sxx - szz) * (sxx - szz) + (syy - szz) * (syy - szz) + 6 * ( sxy * sxy + szx * szx + syz * syz))
					 stress[id] = vm

					 mos_yield = Fy / (FSy * vm) - 1
					 mos_ultimate = Fu / (FSu * vm) - 1
					 printf("%24s%12d%12.2f%12.2f%12.2f\n", "CHEXA", id, vm, mos_yield, mos_ultimate)
				         yield[id]= mos_yield	 
                                         ultimate[id] = mos_ultimate
                                   }
                           } 

			   if ($4 == type["cquadr"] || $4 == type["cquad4"] || $4 == type["ctria3"]){
			           readline()
				   while(readline() && $0 !~ /TITLE/){
				          id = $1
					  sxx = $3
					  syy = $4
						 if (NF < 5) { 
						        s = syy; 
							syy = substr(s, 1, length(s) - 8)
						 } 

					  readline()
					  sxy = $2

					  sxx *=  3.
					  syy *= -3.
					  sxy *=  3.
						 
                                          vm_top = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + sxx * sxx + syy * syy + 6 * sxy * sxy )

					  sxx = $4
						 if (NF < 5) { 
						        s = sxx; 
							sxx = substr(s, 1, length(s) - 8)
						 } 
					  readline()
					  syy = $2
					  sxy = $3
					  
					  vm_bottom = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + sxx * sxx + syy * syy + 6 * sxy * sxy )
					  vm = max(vm_top, vm_bottom)
					  stress[id] = vm

					  mos_yield = Fy / (FSy * vm) - 1
					  mos_ultimate = Fu / (FSu * vm) - 1
					  printf("%24s%12d%12.2f%12.2f%12.2f\n", "CQUADR", id, vm, mos_yield, mos_ultimate)
					  yield[id]= mos_yield	 
                                          ultimate[id] = mos_ultimate
                                          ###print id, yield[id], ultimate[id], stress[id]
				   }
			   }
			   
			   if ($4 == type["ctetra"]){
			   readline();
			   
			       while(readline() && $0 !~ /TITLE/){
                           ## read stresses in the midlle of the element

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
                                                 szx = $2
						 
						 ####print id, sxx, syy, szz, sxy, sxz, syz
						 
						 sxx *=  3.
						 syy *= -3.
						 szz *= -3.
						 sxy *=  3.
						 szx *=  3.
						 syz *=  3.
						 
                         vm = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + (sxx - szz) * (sxx - szz) + (syy - szz) * (syy - szz) + 6 * ( sxy * sxy + szx * szx + syz * syz))
                         ##
						 
						 stress[id] = vm

						 mos_yield = Fy / (FSy * vm) - 1
						 mos_ultimate = Fu / (FSu * vm) - 1
						 printf("%24s%12d%12.2f%12.2f%12.2f\n", "CTETRA", id, vm, mos_yield, mos_ultimate)
					         yield[id]= mos_yield	 
                                                 ultimate[id] = mos_ultimate
                                                 ####print id, yield[id], ultimate[id], stress[id]
						 
				   }
				   
			   ###mos_yield = Fy / (FSy * vm_max) - 1
			   ####mos_ultimate = Fu / (FSu * vm_max) - 1
			   #printf("\n%28s:\n","Summary");
			   #printf("%12d%12.2f%12.2f%12.2f\n", element_vm, vm_max, mos_yield, mos_ultimate)
			   }
			   

		    }
	}
                                          print ""
                                          print "Stress Distribution Of The Selected Group"
                                          printf("\n%36s%12s%12s%12s\n", "Element", "VM", "MOS Yield", "MOS Ultimate")
	                                  mos_yield_min = 1.E+32
	                                  mos_ultimate_min = 1.E+32


                                          for(i=1; i<=ngroup; ++i){

                                                         id =      group[i]
                                                        num = sprintf("%d",id)
                                               mos_ultimate = ultimate[num]
                                                  mos_yield =    yield[num] 
                                                         vm =   stress[num]

                                               if (vm <= 0. || mos_yield > margin_cut_off ) continue 
					       printf("%36d%12.2f%12.2f%12.2f\n", num, vm, mos_yield, mos_ultimate)

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

					          printf("\n\n%36s%12s%12.2f%12.2f\n", "Minimum", " MOS", mos_yield_min, mos_ultimate_min)
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

function max(a, b){
 if (a>b) 
     return a
 else 
     return b
}
