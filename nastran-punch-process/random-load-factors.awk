BEGIN {

      disp = 1; 
	  rot = 1; 
	  freq = 1; 
	  Pi = 3.14159;
	  for(i=1;i<ARGC;++i){
	      split(ARGV[i],input,"=");
		  data[input[1]] = input[2];
	  }
	  Q = data["Q"];
	  filex = data["xdir"];
	  filey = data["ydir"];
	  filez = data["zdir"];
	  
}


$0 ~ /MODAL EFFECTIVE MASS FRACTION/ {found++;}
$0 ~ /EIGENVALUE/ {split($0, a, " "); frequency[freq++] = sqrt(a[3])/(2*Pi);}
######$0 ~ /MODAL EFFECTIVE MASS FRACTION/ && found == 1 {print $0; found = 2; }
$0 ~ /TITLE/ && found  == 2 {found = 0;}
$1 ~ /^[1-9]/ && found  == 1 {translation[disp++] = $0;}
$1 ~ /^[1-9]/ && found  == 2 {rotation[rot++] = $0;}

END {
      if (ARGC < 5){
	      printf("usage: awk -f random-load-factors.awk input.pch Q=10. xdir=x_psd ydir=y_psd zdir=z_psd\n");
		  exit;
		  }
		  
    f_x = 0.;
	x_max = 0.;
	
	f_y = 0.;
	y_max =0.;
	
	f_z =0.;
	z_max = 0.;


	recordx = 0;
	while(getline < filex > 0){
	       Xxt[++recordx] = $1;
		   Xyt[recordx] = $2;
	}

	recordy = 0;
	while(getline < filey > 0){
	       Yxt[++recordy] = $1;
		   Yyt[recordy] = $2;
	}

	recordz = 0;
	while(getline < filez > 0){
	       Zxt[++recordz] = $1;
		   Zyt[recordz] = $2;
	}

	
	scale = 100;
	printf("%16s%16s%16s%16s%16s%16s%16s%16s\n","Mode#", "Frequency(Hz)", "T1", "T2", "T3", "R1", "R2", "R3");
	
	for(i=1; i < disp; i++){
		split(translation[i],t," ");
		x = t[2] * scale;
		y = t[3] * scale;
		z = t[4] * scale;
		
        split(rotation[i],r," ");
		rx = r[2] * scale;
		ry = r[3] * scale;
		rz = r[4] * scale;
		printf("%16d%16.1f%16.1f%16.1f%16.1f%16.1f%16.1f%16.1f\n",i, frequency[i], x, y, z, rx, ry, rz)
		
		if (x > x_max) {
		    x_max = x;
			f_xmax = frequency[i];
		}

		if (y > y_max) {
		    y_max = y;
			f_ymax = frequency[i];
		}

		if (z > z_max) {
		    z_max = z;
			f_zmax = frequency[i];
		}
		
        sumx += x;
		sumy += y;
		sumz += z;
		sumrx += rx;
		sumry += ry;
		sumrz += rz;


	
    f_x = frequency[i];
	wx = get_Xyt(f_x)
	rvlfx += t[2] * t[2] * Pi/2 * f_x * Q * wx; ## square of the load factor

    f_y = frequency[i];
	wy = get_Yyt(f_y)
	rvlfy += t[3] * t[3] * Pi/2 * f_y * Q * wy; ## square of the load factor

    f_z = frequency[i];
	wz = get_Zyt(f_z)
	rvlfz += t[4] * t[4] * Pi/2 * f_z * Q * wz; ## square of the load factor
		
	}
	printf("%16s%16s%16.1f%16.1f%16.1f%16.1f%16.1f%16.1f\n","Total", "Sum:", sumx, sumy, sumz, sumrx, sumry, sumrz);	


	printf("\n");
	printf("X psd input file:%s\n", filex);
	printf("Y psd input file:%s\n", filey);
	printf("Z psd input file:%s\n", filez);

	printf("\nModal Participation Approach Miles Equation Results (Random Load Factors), G:\n");
    ### 3 sigma load factor
    rvlfx = 3 * sqrt(rvlfx);
    rvlfy = 3 * sqrt(rvlfy);
    rvlfz = 3 * sqrt(rvlfz);
	printf("Q:%12.1f\n", Q);
	
	printf("x:%12.1f\n", rvlfx);
	printf("y:%12.1f\n", rvlfy);
	printf("z:%12.1f\n", rvlfz);	
	
	printf("\n\nMiles Equation Results:\n");

	printf("\n");
	printf("X psd input file:%s\n", filex);
	printf("\nX direction:\n");

	wx = get_Xyt(f_xmax)
	printf("%12s%12s%12s%12s%12s\n","Freq,Hz", "Q", "W", "Grms", "3xGrms");
	G = sqrt(Pi/2 * f_xmax * Q * wx);
	printf("%12.2f%12.2f%12.2f%12.2f%12.2f\n", f_xmax, Q, wx, G, 3*G);

	printf("\n");
	printf("Y psd input file:%s\n", filey);
	printf("\nY direction:\n");

	wy = get_Yyt(f_ymax)
	printf("%12s%12s%12s%12s%12s\n","Freq,Hz", "Q", "W", "Grms", "3xGrms");
	G = sqrt(Pi/2 * f_ymax * Q * wy);
	printf("%12.2f%12.2f%12.2f%12.2f%12.2f\n", f_ymax, Q, wy, G, 3*G);

	printf("\n");
	printf("Z psd input file:%s\n", filez);
	printf("\nZ direction:\n");

	wz = get_Zyt(f_zmax)
	printf("%12s%12s%12s%12s%12s\n","Freq,Hz", "Q", "W", "Grms", "3xGrms");
	G = sqrt(Pi/2 * f_zmax * Q * wz);
	printf("%12.2f%12.2f%12.2f%12.2f%12.2f\n", f_zmax, Q, wz, G, 3*G);
	
	
	print "";
	print "Nastran Input Table";
	print "TABLED1,XXXX,log,log,"
	num_per_row = 8;
	current = 0;
	for(i=1;i<=recordx;++i){
		if (current == 0) 
	            printf("+,");

	        freq = Xxt[i];
	        valu = Xyt[i];	
                printf("%.1f,%.4f,",freq, valu);
		current+=2;
		if (current == 8){
			printf("+\n");
			current = 0;
		}
	}
	printf("endt\n");

	print "TABLED1,YYYY,log,log,"
	num_per_row = 8;
	current = 0;
	for(i=1;i<=recordy;++i){
		if (current == 0) 
	            printf("+,");

	        freq = Yxt[i];
	        valu = Yyt[i];	
                printf("%.1f,%.4f,",freq, valu);
		current+=2;
		if (current == 8){
			printf("+\n");
			current = 0;
		}
	}
	printf("endt\n");	  

	print "TABLED1,ZZZZ,log,log,"
	num_per_row = 8;
	current = 0;
	for(i=1;i<=recordz;++i){
		if (current == 0) 
	            printf("+,");

	        freq = Zxt[i];
	        valu = Zyt[i];	
                printf("%.2f,%.4f,",freq, valu);
		current+=2;
		if (current == 8){
			printf("+\n");
			current = 0;
		}
	}
	printf("endt\n");	
}

function get_Xyt(x){
    k = 0;
	while(x<Xxt[++k]);
    j = k+1;
    ###printf("x: %f,%f\n", Xxt[k], Xxt[j]);
	return exp( log(Xxt[j]/x) / log(Xxt[j]/Xxt[k]) * log(Xyt[k]) + log(x/Xxt[k]) / log(Xxt[j]/Xxt[k]) * log(Xyt[j]));
}

function get_Yyt(x){
    k = 0;
	while(x<Yxt[++k]);
    j = k+1;
	##printf("y: %f,%f\n", Yxt[k], Yxt[j]);
	return exp( log(Yxt[j]/x) / log(Yxt[j]/Yxt[k]) * log(Yyt[k]) + log(x/Yxt[k]) / log(Yxt[j]/Yxt[k]) * log(Yyt[j]));
}

function get_Zyt(x){
    k = 0;
	while(x<Zxt[++k]);
    j = k+1;
	##printf("z: %f,%f\n", Zxt[k], Zxt[j]);
	return exp( log(Zxt[j]/x) / log(Zxt[j]/Zxt[k]) * log(Zyt[k]) + log(x/Zxt[k]) / log(Zxt[j]/Zxt[k]) * log(Zyt[j]));
}
