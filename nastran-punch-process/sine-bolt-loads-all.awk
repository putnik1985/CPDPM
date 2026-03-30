BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file
	type["cbar"] = 34; ## nastran nx element type from .pch file
	
	if (ARGC < 2){
		print "usage awk -f sine-bolt-loads.awk file=inp.pch";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	 file  = data["file"];

    ########print file, label, eid
	type_number = type[label];
	###print type_number;
	####exit;
	record = 0;
	
	##########printf("%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq", "Elem", "MZZ-A", "MYY-A", "MZZ-B", "MYY-B", "Shear-Y", "Shear-Z", "Axial", "Torque")
	count = 0
	while (getline < file > 0){
	
		if ($0 ~ /SUBCASE ID/){
			subcase = $4;
			
			if (getline < file >0){
			
				if ($0 ~ /ELEMENT TYPE/ && $4 == type["cbar"]){
					
					if (getline < file > 0){
						freq = $3
					}
					
                    ####print freq
					while (getline < file > 0 && $0 !~ /TITLE/){
					    ++count;
					    eid = $1
						#####print eid
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
					
					getline < file;
					getline < file;
					getline < file;
					

                    str = sprintf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,", 1, eid, subcase, type["cbar"], freq, sta, mza, mya, mzb, myb, shear_y, shear_z, axial, torque)
					print str
					
				    } #### while (eid !~ /TITLE/)
					
				}
			}

		}

	}

}

function abs(x){
 return (x>0) ? x : -x;
}
 

