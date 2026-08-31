BEGIN{ 
	
	if (ARGC < 4){
		print "usage awk -f on-orbit-satk-stress.awk file=yja-vib-test_random_stre.out elements=elements.dat output=dir";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	elements = data["elements"] ##list of files where the elements for each component
    directory = data["output"]
	##print directory
	##exit
	######print "Elements To Work With"
	####print file, elements, directory
	while(getline < elements > 0){
	  list[++nlist] = $1
	  ##print $1
	}

	while (readline()){
	       if ($1 ~ /^[0-9]/) {
		       ###print $0
			   id = $1
			   vm = $NF
			   delta = vm - stress[id]
				if (delta > 0.) {
					stress[id] = vm
					frequency[id] = case_number
				}
		   }
	}
	
	                        
	                        for(k=1; k<=nlist; ++k){
							    ##########print k
							    ngroup = 0
								element_file = list[k]
								n1 = split(element_file, out, "/")
								n1 = split(out[n1], out2, ".")
								fout = out2[1]
								
								##print element_file
								while (getline < element_file > 0){
								       group[++ngroup] = $1
									   ##print $1
								}
	                                  vm_max = 0.;
									  freq_max = 0.;
									  
	                                  for(i=1; i<=ngroup; ++i){
                                               id = group[i]
                                               num = sprintf("%d",id)
											   ##print num, stress[num],vm_max
											   str = sprintf("%g",stress[num])
											   ###print id, stress[num], vm_max, stress[num]-vm_max
											   delta = stress[num]-vm_max
											   if (delta > 0.){
											       vm_max = stress[num]
												   freq_max = frequency[num]
												   id_max = num
											   }
                                               ##printf("%d,%.2f,%s\n", num, frequency[num], stress[num])
                                      }
									  output = directory "/" fout ".stress" 
									  printf("%d,%d,%s\n", id_max, freq_max, vm_max) > output
                            } ## read each file
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