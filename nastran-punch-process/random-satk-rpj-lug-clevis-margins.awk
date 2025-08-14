BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file CTETRA4
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
        type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
        type["cquad4"] = 33
        type["ctria3"] = 74

	if (ARGC < 8){
		print "usage awk -f random-satk-vm.awk dia=0.625 file=inp.txt Fy=48. Fu=61. Fsu=97. FSy=1.25 FSu=2. elements=elements.dat";
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
	FSu  = data["FSu"]	

	
	elements = data["elements"]
	while(getline < elements > 0){
	  group[++ngroup] = $1
	}

#	print "Elements Of The Group"
#	for(i=1; i<=ngroup; ++i)
#	    print group[i]
#
#	print ""
#	print ""
	FS = ","
	pi = 3.14159
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
    shear_limit = Fsu * 2.* A
	
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
	
	while (readline()){
	       ##print $0
		       fx = $7
			   fy = $8
			   fz = $9
			   mx = $10
			   my = $11
			   mz = $12
			   
						 shear_force = sqrt(fy * fy + fz * fz)
						 bending = shear_force * b / 2
						  sx = bending * ymax / Jd + abs(fx) / A
			             sxy = shear_force / A
						 #####vm = sqrt(sx*sx + 3 * sxy * sxy)
			   #####print $2, fx, fy, fz, mx, my, mz, vm
			   
						 mos_shear = shear_limit / (FSu * shear_force) - 1
						 mos_yield = Fy / (FSy * sx) - 1
						 mos_ultimate = Fu / (FSu * sx) - 1
			   
			             id = sprintf("%d",$2)
               			 cbush_shear[id] = mos_shear
                         cbush_ultimate[id] = mos_ultimate
                         cbush_yield[id] = mos_yield
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
