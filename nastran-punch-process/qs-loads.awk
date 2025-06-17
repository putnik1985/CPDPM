BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC <= 3){
		print "usage awk -f qs-loads.awk file=inp.pch label=cbush id=243";
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
	####print type_number;
					      printf("%12s,%12s,%12s,%12s,%12s,%12s,%12s,\n","Subcase#", "Fx", "Fy", "Fz", "Rx", "Ry", "Rz")
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
					      printf("%12d,%12.1f,%12.1f,%12.1f,%12.1f,%12.1f,%12.1f,\n",case_number, fx, fy, fz, mx, my, mz)
						  
						  ### in case if to calculate relative deflections
						  ###printf("%12d,%12.6f,%12.6f,%12.6f,%12.6f,%12.6f,%12.6f,\n",case_number, fx, fy, fz, mx * 180 / pi, my * 180. /pi, mz * 180. / pi)
						  if (abs(fx) > fx_max) fx_max = abs(fx);
						  if (abs(fy) > fy_max) fy_max = abs(fy);
						  if (abs(fz) > fz_max) fz_max = abs(fz);

						  if (abs(mx) > mx_max) mx_max = abs(mx);
						  if (abs(my) > my_max) my_max = abs(my);
						  if (abs(mz) > mz_max) mz_max = abs(mz);						  
				        }
				}
			}
		}
	}

					      printf("%12s,%12.1f,%12.1f,%12.1f,%12.1f,%12.1f,%12.1f,\n","Maximum:", fx_max, fy_max, fz_max, mx_max, my_max, mz_max)
}

function abs(x){
  if (x > 0) 
      return x
  else 
      return -x;
}