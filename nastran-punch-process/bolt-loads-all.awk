BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file
	type["cbar"] = 34; ## nastran nx element type from .pch file
	
	if (ARGC < 2){
		print "usage awk -f bolt-loads.awk file=inp.pch";
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

    ####print file, label, eid
	type_number = type[label];
	###print type_number;
	####exit;
	sta = 1
	###################printf("%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq", "Elem", "MZZ-A", "MYY-A", "MZZ-B", "MYY-B", "Shear-Y", "Shear-Z", "Axial", "Torque")
	count = 0
	while (getline < file > 0){
	    ###print $0

    if ($0 ~ /\$ELEMENT FORCES/){
        readline()
		readline()
		
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
						mzb = adapt($4)

					if (getline < file > 0){
						myb = -$2
						shear_y = $3
						shear_z = adapt($4)
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
					####mza +=, mya, mzb, myb, shear_y, shear_z, axial, torque
					
                    str = sprintf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,", 1, eid, case_number, type["cbar"], freq, sta, mza, mya, mzb, myb, shear_y, shear_z, axial, torque)
					print str
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

		} ## subcase id
	  } ## element forces
	} ## getline
}

function abs(x){
 return (x>0) ? x : -x;
}

function adapt(vm){
	if (NF < 5){ 
		s = vm; 
	    vm = substr(s, 1, length(s) - 8)
	}
    return vm
}	


function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}