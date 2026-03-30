BEGIN{

      if (ARGC < 2){
	       print "usage: awk -f sine-cbush-loads.awk file=input.pch";
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
     	  eid  = data["cbush"];
        label  = "cbush";
    	type_number = type[label];
    	record = 0;
		
	while (getline < file > 0){
		if ($0 ~ /SUBCASE ID/){
		    subcase_num = $4;
				
			if (getline < file >0){
				if ($0 ~ /ELEMENT TYPE/ && $4 == type["cbush"]){
				    readline()
					freq = $3
					##print freq
					##exit
				    while (getline < file > 0 && $0 !~ /\$TITLE/){
				      ++count
					  ###########print count
				      eid = $1
                      fx = $2
					  fy = $3
					  fz = $4
					  readline()
					  mx = $2
					  my = $3
					  mz = $4
					  printf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,\n", 1, eid, case_number, type["cbush"], freq, sta,  my, mz, my, mz, fy, fz, fx, mx)
                      readline()
					  readline()
				    }
				}			  					  
		    }
		} ####if ($0 ~ /SUBCASE ID/)
	}
}

function max(a,b){
	if (a > b)
            return a;
	else 
	    return b;
}

function readline(){
  if (getline < file > 0)
      return 0;
  else {
       printf("can not read file:%s\n", file);
	   exit;
	   }
}