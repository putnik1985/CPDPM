BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
    type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
    type["cquad4"] = 33
    type["ctria3"] = 74
	
	if (ARGC < 3){
		print "usage awk -f qs-element-stress.awk file=inp.pch elements=elements.dat";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	elements = data["elements"]

	######print "Elements To Work With"
	while(getline < elements > 0){
	  group[++ngroup] = $1
	  #####print group[ngroup]
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
						 szx = $3
						 readline();
						 
                         vm = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + (sxx - szz) * (sxx - szz) + (syy - szz) * (syy - szz) + 6 * ( sxy * sxy + szx * szx + syz * syz))
						 stress[id] = sprintf("%d,%d,%.6g,%.6g,%.6g,%.6g,%.6g,%.6g,\n", case_number, id, sxx, syy, szz, sxy, syz, szx)
						 
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
						 bottom = sprintf("%d,%d,%.6g,%.6g,%.6g,%.6g,%.6g,%.6g,\n", case_number, id, sx, sy, 0., sxy, 0., 0.)
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
						 top = sprintf("%d,%d,%.6g,%.6g,%.6g,%.6g,%.6g,%.6g,\n", case_number, id, sx, sy, 0., sxy, 0., 0.)
						 stress[id] = bottom top
						 readline()
						 readline()
						 
				   }
										  
			   }
			   
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
                         vm = 1./sqrt(2) * sqrt((sxx - syy) * (sxx - syy) + (sxx - szz) * (sxx - szz) + (syy - szz) * (syy - szz) + 6 * ( sxy * sxy + szx * szx + syz * syz))
						 stress[id] = sprintf("%d,%d,%.6g,%.6g,%.6g,%.6g,%.6g,%.6g,\n", case_number, id, sxx, syy, szz, sxy, syz, szx)
                    }
                }
                                      for(i=1; i<=ngroup; ++i){
                                               id = group[i]
                                               num = sprintf("%d",id)
                                               printf("%s", stress[num])
                                      }

		    }
			}
	}
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