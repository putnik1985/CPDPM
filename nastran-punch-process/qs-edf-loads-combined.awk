BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 3){
		print "usage awk -f qs-loads.awk file=inp.pch unit=loads_from_unit_load";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	 file  = data["file"];
	 unit = data["unit"];
	label  = data["label"];
	  eid  = data["id"];
	   pi  = 3.14159
	   
        ######print file, label, eid

	while (getline < unit > 0){
	       if ($1 ~ /[0-9]/){
		       ###print $0
			   n = split($0, out, ",")
			   gx[++unit_case] = out[1]
			   gy[  unit_case] = out[2]
			   gz[  unit_case] = out[3]
			   rx[  unit_case] = out[4]
			   ry[  unit_case] = out[5]
			   rz[  unit_case] = out[6]			   
		   }
    }

	#for(i=1; i<=unit_case; ++i){
	#    print gx[i], gy[i], gz[i], rx[i], ry[i], rz[i]
	#}
	#exit	
	type_number = type[label];
	sta = 1
	####print type_number;
	####printf("%12s,%12s,%12s,%12s,%12s,%12s,%12s,%12s,%12s,\n","Subcase#", "Fx", "Fy", "Fz", "Rx", "Ry", "Rz", "FResultant", "MResultant" )
	while (getline < file > 0){
	    
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
					  fz = $4
					  readline()
					  mx = $2
					  my = $3
					  mz = $4
					
					if (written[eid] != 1) {
					    elements[++nelem] = eid
						written[eid] = 1
					}
					
					order = eid "," case_number
					   unit_fx[order] = fx
					   unit_fy[order] = fy
					   unit_fz[order] = fz
					   unit_mx[order] = mx
					   unit_my[order] = my
					   unit_mz[order] = mz					   

					  #####printf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,\n", 1, eid, case_number, type["cbush"], freq, sta,  my, mz, my, mz, fy, fz, fx, mx)
				    }
				}
					      
						  					  
		    }
		}
	}
    ##########print nelem
	for(i=1; i<= unit_case; ++i){
	    for(k=1; k<=nelem; ++k){
	        eid = elements[k]
			case_number = i
			freq = 0
			sta = 1 
			fx = unit_fx[eid "," "1"] * gx[i] + unit_fx[eid "," "2"] * gy[i] + unit_fx[eid "," "3"] * gz[i] + \
			     unit_fx[eid "," "4"] * rx[i] + unit_fx[eid "," "5"] * ry[i] + unit_fx[eid "," "6"] * rz[i]

			fy = unit_fy[eid "," "1"] * gx[i] + unit_fy[eid "," "2"] * gy[i] + unit_fy[eid "," "3"] * gz[i] + \
			     unit_fy[eid "," "4"] * rx[i] + unit_fy[eid "," "5"] * ry[i] + unit_fy[eid "," "6"] * rz[i]

			fz = unit_fz[eid "," "1"] * gx[i] + unit_fz[eid "," "2"] * gy[i] + unit_fz[eid "," "3"] * gz[i] + \
			     unit_fz[eid "," "4"] * rx[i] + unit_fz[eid "," "5"] * ry[i] + unit_fz[eid "," "6"] * rz[i]

			mx = unit_mx[eid "," "1"] * gx[i] + unit_mx[eid "," "2"] * gy[i] + unit_mx[eid "," "3"] * gz[i] + \
			     unit_mx[eid "," "4"] * rx[i] + unit_mx[eid "," "5"] * ry[i] + unit_mx[eid "," "6"] * rz[i]

		    my = unit_my[eid "," "1"] * gx[i] + unit_my[eid "," "2"] * gy[i] + unit_my[eid "," "3"] * gz[i] + \
			     unit_my[eid "," "4"] * rx[i] + unit_my[eid "," "5"] * ry[i] + unit_my[eid "," "6"] * rz[i]

		    mz = unit_mz[eid "," "1"] * gx[i] + unit_mz[eid "," "2"] * gy[i] + unit_mz[eid "," "3"] * gz[i] + \
			     unit_mz[eid "," "4"] * rx[i] + unit_mz[eid "," "5"] * ry[i] + unit_mz[eid "," "6"] * rz[i]
				  
         printf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,\n", 1, eid, case_number, type["cbush"], freq, sta,  my, mz, my, mz, fy, fz, fx, mx)
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
  if (getline < file > 0)
      return 0;
  else {
       printf("can not read file:%s\n", file);
	   exit;
	   }
}