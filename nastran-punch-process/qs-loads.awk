BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC <= 3){
		print "usage awk -f loads.awk file=inp.pch label=cbush id=243";
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
        ######print file, label, eid
	type_number = type[label];
	####print type_number;
					      printf("%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Fx", "Fy", "Fz", "Rx", "Ry", "Rz")
	while (getline < file > 0){
		if ($0 ~ /SUBCASE ID/){
			case_number = $4;
			if (getline < file >0){
				if ($0 ~ /ELEMENT TYPE/ && $4 == type[label]){
					if (getline < file > 0){
						found = ($1 == eid)
						####print $0i, found
					}

					while (!found && $0 !~ /TITLE/)
					        if (getline < file > 0)
						   found = ($1 == eid)
					   
                                        if (found){
                                           fx = $2
					   fy = $3
					   fz = $4
					      if (getline < file > 0){
						      mx = $2
						      my = $3
						      mz = $4
					      }
					      printf("%12d%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f\n",case_number, fx, fy, fz, mx, my, mz)
				        }
				}
			}
		}
	}
}

