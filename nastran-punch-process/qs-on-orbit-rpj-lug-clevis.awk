BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 3){
		print "usage awk -f qs-on-orbit-bolt-vm.awk file=inp.pch dia=0.625 elements=list.txt";
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

        edf_list = data["elements"]
        while(getline < edf_list > 0){
          edf[++nedf] = $1
        }

    pi = 3.14159;

    ###Ref. SPAR-SS-1604 Rev B_10, page 96
    meters = 0.0254	## convert in to meters
	t1 = 0.6 * meters 
	t2 = 0.567 * meters 
	dia = 0.625 * meters
	gap= 0.096 * meters
	Pumin = 37800. * 4.44822 ## convert to N
	gamma = 0.8
	b = 0.5 * t1 + gap + gamma * 0.25 * t2
    ###Ref. SPAR-SS-1604 Rev B_10, page 96

	
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
	print "Input assumed in Pa convert to ksi"
	while (readline()){
           if ($0 ~ /SUBCASE ID/){
		       vm_max = 0.
			   elem = 0
		       case_number = $4;
			   readline();
			   if ($4 == type["cbush"]){
			       while(readline() && $0 !~ /TITLE/){
				                 id = $1
						 fx = $2
						 fy = $3
						 fz = $4
						 
						 if (NF < 5) { 
						        s = fz; 
								fz = substr(s, 1, length(s) - 8)
                                ####print sxy								
						 } 
						 
						 readline();
						 mx = $2
						 my = $3
						 mz = $4

						 if (NF < 5) { 
						        s = mz; 
								mz = substr(s, 1, length(s) - 8)
                                ####print sxy								
						 } 

						 ###print case_number, id, fx, fy, fz, mx, my, mz
						 shear_force = sqrt(fy * fy + fz * fz)
						 bending = shear_force * b / 2
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
										   elem = id
					                   }
                                   }
								   printf("%d%12.2f%12d\n", case_number, vm_max * 1.45038E-7, elem)
			   }
		    }
	}

                                          #print "Input assumed in Pa convert to ksi"
                                          #printf("%.2f\n", vm_max * 1.45038E-7)
                                          ###printf("%e\n", vm_max)
						  
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
