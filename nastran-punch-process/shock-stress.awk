BEGIN{ 

	type["ctetra"] = 39; ## nastran nx element type from .pch file
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
    type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
    type["cquad4"] = 33
    type["ctria3"] = 74

	if (ARGC < 3){
		print "usage awk -f qs-stress-margins.awk file=inp.pch elements=elements.dat out=dir";
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
    dir = data["out"]
	
	######print "Elements To Work With"
	while(getline < elements > 0){
	
	  list[++nlist] = $1
      ####print list[nlist]
	  #####print $1
	}
	
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
			       readline()
				   freq = $3
			       while(readline() && $0 !~ /TITLE/){

				         id = $1
                         if (id !~ /^[0-9]/)
                             continue
							 
						 readline();
						 readline();
						 readline();

						 
                         vm = $4
						    if (NF < 5) { 
						        s = vm; 
								vm = substr(s, 1, length(s) - 8)
                                ####print sxy								
						    } 

						 delta = vm - stress[id]
						 if (delta > 0.) {
						          stress[id] = vm
								  frequency[id] = case_number
						 }
						 ####print case_number, id, stress[id], vm
						 
				   }				   
			   }
			   
			   if ($4 == type["cquadr"] || $4 == type["cquad4"] || $4 == type["ctria3"]){
			       readline()
				   freq = $3
			       while(readline() && $0 !~ /TITLE/){
				         id = $1
						 readline()
						 readline()
						 vm_bottom = $3
						 
						 readline()
						 readline()
						 readline()

						 vm_top = $2
						 vm = max(vm_bottom, vm_top)
						 if (vm > stress[id]){
						     stress[id] = vm
							 frequency[id] = freq
						 }
						 ##print freq, id, vm_top, vm_bottom
				   }
										  
			   } ##cquad
			   
			   if ($4 == type["chexa"]){
			       readline()
				   freq = $3

			       while(readline() && $0 !~ /TITLE/){
				         id = $1
						 
                            if (id !~ /^[0-9]/)
                            continue
							
						 readline()
						 readline()
						 readline()
						 vm = $4

						    if (NF < 5) { 
						        s = vm; 
								vm = substr(s, 1, length(s) - 8)
                                ####print sxy								
						    }
							
						 if (vm > stress[id]){
						     stress[id] = vm
							 frequency[id] = freq
						 }
						 ##print freq, id, vm_top, vm_bottom
				   }				   

               } ##chexa

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
										
								while (getline < element_file > 0){
								       group[++ngroup] = $1
								}
	                                  vm_max = 0.;
									  freq_max = 0.;
									  
	                                  for(i=1; i<=ngroup; ++i){
                                               id = group[i]
                                               num = sprintf("%d",id)
											   if (stress[num] > vm_max){
											       vm_max = stress[num]
												   freq_max = frequency[num]
												   id_max = num
											   }
                                               #####printf("%d,%.2f,%s\n", num, frequency[num], stress[num])
                                      }
									  output = dir "/" fout ".stress" 
									  printf("%d,%.2f,%s\n", id_max, freq_max, vm_max) > output
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