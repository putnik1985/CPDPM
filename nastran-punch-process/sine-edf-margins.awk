BEGIN{
      if (ARGC < 2){
	       print "usage: awk -f sine-cbush-loads-response.awk file=input.pch";
	       exit;
       }

        type["cbush"] = 102;
	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	     file  = data["file"];
		 type_number = type["cbush"];
		 
         record = 0;
	current_subcase = 0;
		
	while (readline()){
	
		   if($0 ~ /\$LABEL/) {
		                       split($0, out1, "=")
							   label1 = out1[2]
							   m = split(label1, out2)
							   label = "";
							   for(i=1; i < m; ++i)
							       label = label " " out2[i]
							   ####print label
		   }
		   
           if ($0 ~ /SUBCASE ID/){
                    if (current_subcase != $4) {
					    current_subcase = $4
					    printf("\n%12s,%12d,%24s,\n", "Subcase", current_subcase, label)

						readline()
						if ($4 != type_number) continue
						
						readline()
						freq = $3
						
						##print freq
						while(readline() && $0 !~ /\$TITLE/){
						  point_id = $1
						  
						  if (point_id ~ /^[1-9]/){
							  readline()
							  printf("%12s,%12s,%12s,%12s,%12s,%12s,%12s,%12s,","Point ID", "Freq(Hz)", "Fx", "Fy", "Fz", "Mx", "My", "Mz")
						  }
						  
						}
						printf("\n");
						
					} else {
					
						readline()
						if ($4 != type_number) continue
						
						readline()
						freq = $3
						
						##print freq
						while(readline() && $0 !~ /\$TITLE/){
						  point_id = $1
						  
						  if (point_id ~ /^[1-9]/){
						      ##print point_id
							  fx = $2
							  fy = $3
							  fz = $4
							  readline()
							  mx = $2
							  my = $3
							  mz = $4
							  printf("%12d,%12.2f,%12.2f,%12.2f,%12.2f,%12.2f,%12.2f,%12.2f,",point_id, freq, fx, fy, fz, mx, my, mz)
						  }
						  
						}
						printf("\n");
					
					}
		   }           
	}

}

function max(a,b){
	if (a > b)
            return a;
	else 
	    return b;
}

function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}
