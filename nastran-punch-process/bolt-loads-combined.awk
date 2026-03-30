BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file
	type["cbar"] = 34; ## nastran nx element type from .pch file
	
	if (ARGC < 3){
		print "usage awk -f bolt-loads.awk file=inp.pch unit=loads_from_unit_load";
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
	boltsf = data["bolts_id"]

    ####print file, label, eid
	type_number = type[label];
	###print type_number;
	####exit;
	###print unit
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
	
	##for(i=1; i<=unit_case; ++i){
	##    print gx[i], gy[i], gz[i], rx[i], ry[i], rz[i]
	##}
	
	
	sta = 1
	###################printf("%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq", "Elem", "MZZ-A", "MYY-A", "MZZ-B", "MYY-B", "Shear-Y", "Shear-Z", "Axial", "Torque")
	count = 0
	while (getline < file > 0){
	    ###print $0
		if ($0 ~ /SUBCASE ID/){
			case_number = $4;
			###print case_number
			if (getline < file >0){
			    ###print $0
				if ($0 ~ /ELEMENT TYPE/ && $4 == type["cbar"]){
				    ++count
					#####print $0
					if (getline < file > 0){
						eid = $1
					}

					while (eid !~ /TITLE/){
					
					    mza = $2
						mya = $3
						mzb = $4

					if (getline < file > 0){
						myb = $2
						shear_y = $3
						shear_z = $4
					}

					if (getline < file > 0){
						axial = $2
						torque = $3
					}

					####mza +=, mya, mzb, myb, shear_y, shear_z, axial, torque
					
                    ##str = sprintf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,", 1, eid, case_number, type["cbar"], freq, sta, mza, mya, mzb, myb, shear_y, shear_z, axial, torque)
					##print str
					
					if (written[eid] != 1) {
					    elements[++nelem] = eid
						written[eid] = 1
					}

					order = eid "," case_number
					####print order
					   unit_mza[order] = mza
					   unit_mya[order] = mya
					   unit_mzb[order] = mzb
					   unit_myb[order] = myb
					unit_sheary[order] = shear_y
					unit_shearz[order] = shear_z
					 unit_axial[order] = axial
					unit_torque[order] = torque
					##id = count "," eid
					##print id
					##bolts[id] = str
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
	
	for(i=1; i<= unit_case; ++i){
	    for(k=1; k<=nelem; ++k){
	        eid = elements[k]
			case_number = i
			freq = 0
			sta = 1 

			mza = unit_mza[eid "," "1"] * gx[i] + unit_mza[eid "," "2"] * gy[i] + unit_mza[eid "," "3"] * gz[i] + \
			      unit_mza[eid "," "4"] * rx[i] + unit_mza[eid "," "5"] * ry[i] + unit_mza[eid "," "6"] * rz[i]

			mya = unit_mya[eid "," "1"] * gx[i] + unit_mya[eid "," "2"] * gy[i] + unit_mya[eid "," "3"] * gz[i] + \
			      unit_mya[eid "," "4"] * rx[i] + unit_mya[eid "," "5"] * ry[i] + unit_mya[eid "," "6"] * rz[i]

			mzb = unit_mzb[eid "," "1"] * gx[i] + unit_mzb[eid "," "2"] * gy[i] + unit_mzb[eid "," "3"] * gz[i] + \
			      unit_mzb[eid "," "4"] * rx[i] + unit_mzb[eid "," "5"] * ry[i] + unit_mzb[eid "," "6"] * rz[i]

			myb = unit_myb[eid "," "1"] * gx[i] + unit_myb[eid "," "2"] * gy[i] + unit_myb[eid "," "3"] * gz[i] + \
			      unit_myb[eid "," "4"] * rx[i] + unit_myb[eid "," "5"] * ry[i] + unit_myb[eid "," "6"] * rz[i]

		 sheary = unit_sheary[eid "," "1"] * gx[i] + unit_sheary[eid "," "2"] * gy[i] + unit_sheary[eid "," "3"] * gz[i] + \
			      unit_sheary[eid "," "4"] * rx[i] + unit_sheary[eid "," "5"] * ry[i] + unit_sheary[eid "," "6"] * rz[i]

		 shearz = unit_shearz[eid "," "1"] * gx[i] + unit_shearz[eid "," "2"] * gy[i] + unit_shearz[eid "," "3"] * gz[i] + \
			      unit_shearz[eid "," "4"] * rx[i] + unit_shearz[eid "," "5"] * ry[i] + unit_shearz[eid "," "6"] * rz[i]

		  axial = unit_axial[eid "," "1"] * gx[i] + unit_axial[eid "," "2"] * gy[i] + unit_axial[eid "," "3"] * gz[i] + \
			      unit_axial[eid "," "4"] * rx[i] + unit_axial[eid "," "5"] * ry[i] + unit_axial[eid "," "6"] * rz[i]

		 torque = unit_torque[eid "," "1"] * gx[i] + unit_torque[eid "," "2"] * gy[i] + unit_torque[eid "," "3"] * gz[i] + \
			      unit_torque[eid "," "4"] * rx[i] + unit_torque[eid "," "5"] * ry[i] + unit_torque[eid "," "6"] * rz[i]

	     printf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,\n", 1, eid, case_number, type["cbar"], freq, sta, mza, mya, mzb, myb, shear_y, shear_z, axial, torque)
        }	
	}
}

function abs(x){
 return (x>0) ? x : -x;
}

