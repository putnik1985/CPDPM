BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 2){
		print "usage awk -f gs-rotational-force-generation.awk file=inp.txt";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }
     pi = 3.14159
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
						 signrx = 1;
						 for(i1=0; i1<2; ++i1){
						 rx = signrx * g[5];
						 signrx *= -1;
						 signry = 1
						 for(j1=0; j1<2; ++j1){
						     ry = signry * g[6]
							 signry *= -1
							 signrz = 1
							 for(k1=0; k1<2; ++k1){
							     rz = signrz * g[7]
								 signrz *= -1
						         ++loadcase;
						         gload[loadcase] = sprintf("grav,%d,0,g,%.2f,%.2f,%.2f,",1000 * loadcase, gx, gy, gz);
								 rload[loadcase] = sprintf("rforce,%d,grid,0,0.,%.2f,%.2f,%.2f,,+\n+,%f,",1000 * loadcase + 1,rx,ry,rz,1./(2*pi));
							 }
						 }
						 }
					 }
				 }
			 }		 
         } ## if
         if ($0 ~ /g,/) {
             split($0, line, ",");
             accel = line[2];
         }			 
         if ($0 ~ /rpoint,/) {
             split($0, line, ",");
             gridnum = line[2];
			 gridx = line[3];
			 gridy = line[4];
			 gridz = line[5];
         }			 

	 } ## while (getline ...)

     print "Case Control Section"
     for(i=1; i<= loadcase; ++i){
	     print "subcase " i
		 print "load = " i
	 }
	 
	 print ""
     print "Bulk Data"
	 printf("GRID,%d,0,%f,%f,%f,0\n", gridnum, gridx, gridy, gridz);
     printf("spc,1,%d,123456,0.\n",gridnum);
	 
	 for(i=1; i<=loadcase; ++i){
	     printf("load,%d,1.,1.,%d,1.,%d,\n",i, 1000 * i, 1000 * i + 1);
	     sub(",g,","," accel ",",gload[i]);
         print gload[i];
		 sub(",grid,", "," gridnum ",", rload[i]);
		 print rload[i];
	 }
		 
}

function abs(x){
  if (x > 0) 
      return x
  else 
      return -x;
}