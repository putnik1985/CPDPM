BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file
	type["cbar"] = 34; ## nastran nx element type from .pch file
	
	if (ARGC <= 3){
		print "usage awk -f bolt-loads.awk file=inp.pch label=cbar bolts_id=bolts.txt";
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
	boltsf = data["bolts_id"]

    ###print file, label, eid
	type_number = type[label];
	###print type_number;
	####exit;
	
	printf("%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq", "Elem", "MZZ-A", "MYY-A", "MZZ-B", "MYY-B", "Shear-Y", "Shear-Z", "Axial", "Torque")
	count = 0
	while (getline < file > 0){
		if ($0 ~ /SUBCASE ID/){
			case_number = $4;
			
			if (getline < file >0){
				if ($0 ~ /ELEMENT TYPE/ && $4 == type[label]){
				    ++count
					if (getline < file > 0){
						eid = $1
					}

					while (eid !~ /TITLE/){
					
					    mza = $2
						mya = -$3
						mzb = $4

					if (getline < file > 0){
						myb = -$2
						shear_y = $3
						shear_z = $4
					}

					if (getline < file > 0){
						axial = $2
						torque = $3
					}

					moment = sqrt(mza * mza + mya * mya);
					if (max_moment[count] < moment) {
					    max_moment[count] = moment;
					}

					moment = sqrt(mzb * mzb + myb * myb);
					if (max_moment[count] < moment) {
					    max_moment[count] = moment;
					}
					
					shear = sqrt(shear_y * shear_y + shear_z * shear_z);
					if (max_shear[count] < shear) {
					    max_shear[count] = shear;
					}

					if (max_axial[count] < abs(axial)) {
					    max_axial[count] = abs(axial);
					}
					
					if (max_torque[count] < abs(torque)) {
					    max_torque[count] = abs(torque);
					}
					
                    str = sprintf("%12d%12d%12d%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f\n",case_number, 0, eid, mza, mya, mzb, myb, shear_y, shear_z, axial, torque)
					####print str
					id = count "," eid
					##print id
					bolts[id] = str
					if (getline < file > 0){
						eid = $1
					} else {
					  break;
					}
						
				    }
					
				}
			}

		}

	}
                        bolts_number = 0 
				        while(getline < boltsf > 0){
	                      bolt_idf[++bolts_number] = $1
	                    }

	                
					##############print "bolts: ", bolts_number
					for(i = 1; i <= count; ++i){
				          for(j=1; j<=bolts_number; ++j){
						      eid = i "," bolt_idf[j]
     	                      printf("%s", bolts[eid])
						  }
	                    
                    }		

                    printf("\n%16s%16s%16s%16s%16s\n","Subcase#", "Moment, lbf.in", "Shear, lbf", "Axial, lbf", "Torque, lbf.in");	
                    for(i=1; i<=count; ++i)
                     	printf("%16d%16.1f%16.1f%16.1f%16.1f\n", i, max_moment[i], max_shear[i], max_axial[i], max_torque[i]);				
}

function abs(x){
 return (x>0) ? x : -x;
}

