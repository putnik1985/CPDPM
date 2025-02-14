BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 2){
		print "usage awk -f gs-loads-generation.awk file=inp.txt";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	 file = data["file"];
     ####print file
	 loadcase = 0;
	 while (getline < file > 0) {
	     if ($0 ~ /grav/) {
		     n = split($0, g, ",");
			 signx = 1;
			 for(i=0;i<2;++i){
			     gx = signx * g[2];
				 signx *= -1;
				 signy = 1;
				 for(j=0; j<2; ++j){
				     gy = signy * g[3];
					 signy *= -1;
					 signz = 1;
					 for(k=0; k<2; ++k){
					     gz = signz * g[4];
						 signz *= -1;
						 ++loadcase;
						 gload[loadcase] = sprintf("grav,%d,0,g,%.2f,%.2f,%.2f,",loadcase, gx, gy, gz);
					 }
				 }
			 }		 
         } ## if
         if ($0 ~ /g,/) {
             split($0, line, ",");
             accel = line[2];
         }			 
	 } ## while (getline ...)

     print "Case Control Section"
     for(i=1; i<= loadcase; ++i){
	     print "subcase " i
		 print "load = " i
	 }
	 
	 print ""
     print "Bulk Data"
	 for(i=1; i<=loadcase; ++i){
	     sub(",g,","," accel ",",gload[i]);
         print gload[i];
	 }
		 
}

function abs(x){
  if (x > 0) 
      return x
  else 
      return -x;
}