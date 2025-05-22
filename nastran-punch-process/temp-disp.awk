BEGIN{ 

	if (ARGC <= 2){
		print "usage awk -f temp-disp.awk file=inp.pch id=243";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     data[a[1]] = a[2];
        }

	 file  = data["file"];
	  eid  = data["id"];
       pi = 3.14159
	printf("Grid:, %12d,\n", eid)   
    printf("%24s,%12s,%12s,%12s,%12s,%12s,%12s,\n","Subcase#", "Tx", "Ty", "Tz", "Rx(deg)", "Ry(deg)", "Rz(deg)")
	while (getline < file > 0){
	    if ($0 ~ /^\$LABEL/) {
		            label = ""
		            for (i=3; i<NF; ++i)
					     label = label " " $i
		}
		
	    if ($0 !~ /^\$DISPLACEMENTS/) continue
		readline()
		readline()
		if ($0 ~ /SUBCASE ID/){
			case_number = $4;
			while (getline < file > 0 && $0 !~ /\$TITLE/){
			       id = $1
				   ##print case_number, id
				   tx = $3
				   ty = $4
				   tz = $5
				   readline()
				   rx = $2
				   ry = $3
				   rz = $4
				   if (id == eid){
				       printf("%24s,%12.6f,%12.6f,%12.6f,%12.6f,%12.6f,%12.6f,\n", label, tx, ty, tz, rx * 180. / pi, ry * 180. / pi, rz * 180. / pi)
                       accumlate_max(tx, ty, tz, rx, ry, rz)
                   }					   
					   
            } #### while (getline < file > 0 && $ 	        
		} ####if ($0 ~ /SUBCASE ID/)
	}
	
	printf("\n\n")
	printf("%24s,%12.6f,%12.6f,%12.6f,%12.6f,%12.6f,%12.6f,\n", "Maximum:", txmax, tymax, tzmax, rxmax * 180. / pi, rymax * 180. / pi, rzmax * 180. / pi)
}

function abs(x){
  if (x > 0) 
      return x
  else 
      return -x;
}

function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}

function accumlate_max(tx, ty, tz, rx, ry, rz){
	if (abs(tx) > txmax) txmax = abs(tx)
	if (abs(ty) > tymax) tymax = abs(ty)
	if (abs(tz) > tzmax) tzmax = abs(tz)
	if (abs(rx) > rxmax) rxmax = abs(rx)
	if (abs(ry) > rymax) rymax = abs(ry)
	if (abs(rz) > rzmax) rzmax = abs(rz)	
}