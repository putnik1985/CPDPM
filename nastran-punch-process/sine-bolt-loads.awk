BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file
	type["cbar"] = 34; ## nastran nx element type from .pch file
	
	if (ARGC <= 3){
		print "usage awk -f sine-bolt-loads.awk file=inp.pch label=cbar bolts_id=bolts.txt";
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
	record = 0;
	
	printf("%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq", "Elem", "MZZ-A", "MYY-A", "MZZ-B", "MYY-B", "Shear-Y", "Shear-Z", "Axial", "Torque")
	count = 0
	while (getline < file > 0){
	
		if ($0 ~ /SUBCASE ID/){
			subcase = $4;
			
			if (getline < file >0){
			
				if ($0 ~ /ELEMENT TYPE/ && $4 == type[label]){
					
					if (getline < file > 0){
						eid = $4
					}

					while (getline < file > 0 && $0 !~ /TITLE/){
					    ++count;
					    freq = $1
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
					
					
                    str = sprintf("%12d%12.2f%12d%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f\n",subcase, freq, eid, mza, mya, mzb, myb, shear_y, shear_z, axial, torque)
					####print str
					id = count "," eid
					##print id
					bolts[id] = str
					
				    } #### while (eid !~ /TITLE/)
					
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
}

function abs(x){
 return (x>0) ? x : -x;
}
 

