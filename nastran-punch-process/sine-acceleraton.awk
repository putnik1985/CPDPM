BEGIN{ 
	type["cbush"] = 102; ## nastran nx element type from .pch file

	if (ARGC < 4){
		print "usage awk -f sine-acceleration.awk file=inp.pch  point_id=15630394 subcase=1";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	     file  = data["file"];
	 point_id  = data["point_id"];
	 subcase = data["subcase"];
     G = 386.1;
	 
	printf("%12s%12s%12s%12s\n","Frequency", "Ax", "Ay", "Az")
	while (getline < file > 0){
		if ($0 ~ /\$ACCELERATION/){
            readline();
			
			readline();
			if (subcase != $4) continue;
			
			readline();
			if (point_id != $4) continue;
            scale = 1./G;
			    while (getline < file > 0 && $0 !~ /\$TITLE/){
				###print $0;
				freq = $1;
				ax = $3 * scale;
				ay = $4 * scale;
				az = $5 * scale;
				if (freq ~ /^[0-9]/)
				    printf("%12.1f%12.8f%12.8f%12.8f\n", freq, ax, ay, az)
				}
		}###if ($0 ~ /\$ACCELERATION/)

	}####while (getline < file > 0)
}

function readline(){
  if (getline < file > 0)
      return 0;
  else {
       printf("can not read file:%s\n", file);
	   exit;
	   }
}

