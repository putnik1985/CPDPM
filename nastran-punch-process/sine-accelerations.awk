BEGIN{
      if (ARGC < 1){
	       print "usage: awk -f sine-accelerations.awk file=input.pch";
	       exit;
       }

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	    file  = data["file"];
		 
        record = 0;
	    current_subcase = 0;

        pi = 3.14159
        G = 386.1
	
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
						++subcases
						
					    printf("\n%12s,%12d,%24s,\n", "Subcase", current_subcase, label)
					
						readline()
						freq = $3
						
						##print freq
						while(readline() && $0 !~ /\$TITLE/){
						  point_id = $1
						  
						  if (point_id ~ /^[1-9]/){
							  readline()
							  printf("%12s,%12s,%12s,%12s,%12s,","Point ID", "Freq(Hz)", "Ax", "Ay", "Az")
						  }
						  
						}
						printf("\n");
						
					} else {
					
						
						readline()
						freq = $3
						##print freq

						while(readline() && $0 !~ /\$TITLE/){
						  point_id = $1
						  
						  if (point_id ~ /^[1-9]/){
						      ##print point_id
							  fx = $3
							  fy = $4
							  fz = $5
							  readline()
							  mx = $2
							  my = $3
							  mz = $4
							  printf("%12d,%12.2f,%12.2f,%12.2f,%12.2f,",point_id, freq, fx/G, fy/G, fz/G)
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
