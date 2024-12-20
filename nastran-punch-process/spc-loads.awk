BEGIN{ 
        force_scale = 4.4482;	
        moment_scale = 0.112985;	
	if (ARGC < 2){
		print "usage awk -f spc-loads.awk file=inp.pch grid_file = file.dat x=x0 y=y0 z=z0";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	 file  = data["file"];
	 x0 = data["x"];
	 y0 = data["y"];
	 z0 = data["z"];
	 grid_file = data["grid_file"];
	 
    printf("Moments and loads are calculated relative to the following coordinates in FEM CS,  inches:\nx0 = %f, y0 = %f, z0 = %f\n\n", x0, y0, z0);
	printf("%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "X,lbf", "Y,lbf", "Z,lbf", "Mx,lbf.in", "My,lbf.in", "Mz,lbf.in")
           while (getline < grid_file > 0){
		       if ($0 ~ /^GRID/) {
		           split($0,words,",");
				   ###########print words[2], words[4], words[5], words[6];
			       gridx[words[2]] = words[4];
			       gridy[words[2]] = words[5];
			       gridz[words[2]] = words[6];
			    }	    
		   }
		   
    X = 0.;
	Y = 0.;
	Z = 0.;
	Mx = 0.;
	My = 0.;
	Mz = 0.;

	while (getline < file > 0){

		if ($0 ~ /SPCF/){
			getline < file;
			getline < file;

		if ($0 ~ /SUBCASE ID/){
			case_number = $4;
			getline < file;
			first_word = $1;
					while (first_word !~ /TITLE/){
					       ######print case_number, $1;
						   gx = gridx[$1];
						   gy = gridy[$1];
						   gz = gridz[$1];
						   rx = gx - x0;
						   ry = gy - y0;
						   rz = gz - z0;
						   
					       X += $3;
					       Y += $4;
					       Z += $5;
						   Mx += (Z * ry - Y * rz);
						   My += (X * rz - Z * rx);
						   Mz += (Y * rx - X * rz);
						   
					       getline < file;
					       ##############print $2,$3,$4;
					       Mx += $2;
					       My += $3;
					       Mz += $4;
					       getline < file;
					       first_word = $1;
					}
	                printf("%12d%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f\n", case_number, X, Y, Z, Mx, My, Mz);
			X = 0.;
			Y = 0.;
			Z = 0.;
			Mx = 0.;
			My = 0.;
			Mz = 0.;
			}

		}

	}
}

