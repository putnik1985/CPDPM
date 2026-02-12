BEGIN{ 
	FS=","

	if (ARGC < 6){
		print "usage awk -f stress-margins-from-unit.awk stress=outer-shell-unit-load loads=htvx-combine-load-output Fy=241. Fu=290. FSy=1.25 FSu=2.";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     data[a[1]] = a[2];
        }

	file  = data["stress"]
	loads = data["loads"]
	
	Fy  = data["Fy"];
	Fu  = data["Fu"];

	FSy  = data["FSy"];
	FSu  = data["FSu"];

    pi = 3.14159;
	print "Input:"
	printf("Fy,=%f, Fu,=%f, FSy = %f, FSu,=%f\n", Fy, Fu, FSy, FSu)
	
    printf("\n\n%12s%12s%12s%12s%12s\n", "Load Case", "Element", "VM(MPa)", "MOS Yield", "MOS Ultimate")
	
	mos_yield_min = 1000.
	mos_ultimate_min = 1000.
	
	while(readline()){
          order=sprintf("%d %d", $1, $2)
		  ###sxx, syy, szz, sxy, syz, szx
		  sxx[order] = $3
		  syy[order] = $4
		  szz[order] = $5
		  sxy[order] = $6
		  syz[order] = $7
		  szx[order] = $8
		  if ($1 == 1) {
		      elements[++nelem] = $2
		  }
	}
	vm_max = 0.
	while (getline < loads > 0){
	       if ($1 ~ /[0-9]/) {
		       g[1] = $1
			   g[2] = $2
			   g[3] = $3
			   g[4] = $4
			   g[5] = $5
			   g[6] = $6
			   ######print g[1], g[2], g[3], g[4], g[5], g[6]
			   ++load_case
			   vm = 0. ## for current load case
			   for(num=1; num<=nelem; ++num){
			       element = elements[num]
			       sxx1 = 0.; syy1 = 0.; szz1 = 0.;
				   sxy1 = 0.; syz1 = 0.; szx1 = 0.;
				   for(direction=1; direction<=6; ++direction){
			           order=sprintf("%d %d", direction, element) ## extract stresses for the 1st direction
					   ################print sxx[order], syy[order], szz[order], sxy[order], syz[order], szx[order]
					   					   
				       sxx1 += sxx[order] * g[direction]
				       syy1 += syy[order] * g[direction]
				       szz1 += szz[order] * g[direction]
				       sxy1 += sxy[order] * g[direction]
				       syz1 += syz[order] * g[direction]
				       szx1 += szx[order] * g[direction] 
					   
                       ##print sxx1, syy1, szz1, sxy1, syz1, szx1		
                       ##exit					   
				   }
				   vm = 1./sqrt(2)*sqrt((sxx1 - syy1)*(sxx1 - syy1)+(sxx1 - szz1)*(sxx1 - szz1)+(syy1 - szz1)*(syy1 - szz1)+6*(sxy1*sxy1+szx1*szx1+syz1*syz1))
                   ######printf("%12d%12.4f\n", element, vm / 1000000.)
				   if (vm > vm_max) {
				            vm_max = vm
							elem_max = element
							load_case_max = load_case
				   }
			   }
		   }
	}
	printf("\n\n%12d%12d%12.4f%12.2f%12.2f\n", load_case_max, elem_max, vm_max / 1000000., Fy * 1000000. / (vm_max * FSy) - 1., Fu * 1000000. / (vm_max * FSu) - 1.)						  
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