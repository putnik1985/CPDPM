BEGIN{ 
	type["cgap"] = 38; ## nastran nx element type from .pch file

	if (ARGC < 2){
		print "usage awk -f qs-edf-list-margins.awk file=inp.pch elements=list.txt";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];

        edf_list = data["elements"]
        while(getline < edf_list > 0){
          edf[++nedf] = $1
        }

    pi = 3.14159;
    printf("\n\n%12s%12s%12s%12s\n", "Elem#", "Load,X", " Shear,Y", "Shear,Z")
	
	
	while (readline()){
           if ($0 ~ /SUBCASE ID/){
		       case_number = $4;
			   readline();
			   if ($4 == type["cgap"]){
			       while(readline() && $0 !~ /TITLE/){
				         id = $1
						 if (id !~ /^[0-9]/) continue
						 
						 
						 if (abs($2) > fx[id]) fx[id] = abs($2)
						 if (abs($3) > fy[id]) fy[id] = abs($3)
						 if (abs($4) > fz[id]) fz[id] = abs($4)						 
                          						 
						 
				   }   
		       }
	       }
	}

                   for(i=1; i<=nedf; ++i){
				       id = edf[i]
				       printf("%12d%12.2f%12.2f%12.2f\n", id, fx[id], fy[id], fz[id])
					   if (max_x < fx[id]) max_x = fx[id]
					   if (max_y < fy[id]) max_y = fy[id]
					   if (max_z < fz[id]) max_z = fz[id]					   
				   }

                   printf("\n\n%12s%12.2f%12.2f%12.2f\n", "Maximum:", max_x, max_y, max_z)						  
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
