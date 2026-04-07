BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 2){
		print "usage awk -f qs-loads.awk file=inp.pch";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	 file  = data["file"];
	label  = data["label"];
	  eid  = data["id"];
	   pi  = 3.14159
	   
        ######print file, label, eid
	type_number = type[label];
	sta = 1
	####print type_number;
	####printf("%12s,%12s,%12s,%12s,%12s,%12s,%12s,%12s,%12s,\n","Subcase#", "Fx", "Fy", "Fz", "Rx", "Ry", "Rz", "FResultant", "MResultant" )
	while (getline < file > 0){
	    
    if ($0 ~ /\$ELEMENT FORCES/){
        readline()
		readline()
		
		if ($0 ~ /SUBCASE ID/){
			case_number = $4;
			if (getline < file >0){
				if ($0 ~ /ELEMENT TYPE/ && $4 == type["cbush"]){
				###########print case_number
				    ####print $0
				    while (getline < file > 0 && $0 !~ /\$TITLE/){
				      ++count
					  ###########print count
				      eid = $1
                      fx = $2
					  fy = $3
					  fz = adapt($4)
					  readline()
					  mx = $2
					  my = $3
					  mz = adapt($4)
					  printf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,\n", 1, eid, case_number, type["cbush"], freq, sta,  my, mz, my, mz, fy, fz, fx, mx)
				    }
				}
					      
						  					  
		    }
		} ## subcase id
	  } ## element forces
	} ## while getline
}

function abs(x){
  if (x > 0) 
      return x
  else 
      return -x;
}

function readline(){
  if (getline < file > 0)
      return 0;
  else {
       printf("can not read file:%s\n", file);
	   exit;
	   }
}

function adapt(vm){
	if (NF < 5){ 
		s = vm; 
	    vm = substr(s, 1, length(s) - 8)
	}
    return vm
}