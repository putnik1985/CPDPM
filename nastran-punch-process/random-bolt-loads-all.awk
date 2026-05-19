BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file
	type["cbar"] = 34; ## nastran nx element type from .pch file
	
	if (ARGC < 2){
		print "usage awk -f random-bolt-loads.awk file=inp.pch";
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

    if ($0 ~ /\$ELEMENT FORCES - RMS/){
        readline()
		readline()
		
		if ($0 ~ /\$RANDOM ID/){
			case_number = $4;
            readline()
				if ($0 ~ /ELEMENT TYPE/ && $4 == type["cbar"]){
                    readline()
					freq = $3

					while (getline < file > 0 && $0 !~ /TITLE/){
					    eid = $1
						
					    mza = $2
						mya = $3
						mzb = adapt($4)

					    readline()
						myb = $2
						shear_y = $3
						shear_z = adapt($4)

					    readline()
						axial = $2
						torque = $3
				
                    str = sprintf("%12d,%12d,%12d,%12d,%12d,%12d,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,%12.4f,", 1, eid, case_number, type["cbar"], freq, sta, mza, mya, mzb, myb, shear_y, shear_z, axial, torque)
					print str
				    }
					
				}
		} ## random id
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