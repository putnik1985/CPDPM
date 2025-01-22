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
	      printf("usage: awk -f miles-equation.awk input.pch Q=10. xdir=x_psd ydir=y_psd zdir=z_psd\n");
		  exit;
		  }
		  
    f_x = 0.;
	x_max = 0.;
	
	f_y = 0.;
	y_max =0.;
	
	f_z =0.;
	z_max = 0.;
	
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
			f_x = frequency[i];
		}

		if (y > y_max) {
		    y_max = y;
			f_y = frequency[i];
		}

		if (z > z_max) {
		    z_max = z;
			f_z = frequency[i];
		}
		
	}
	



	printf("\nMiles Equation Results:\n");

	printf("\n");
	printf("X psd input file:%s\n", filex);
	record = 0;
	while(getline < filex > 0){
	       xt[++record] = $1;
		   yt[record] = $2;
	}	
	printf("\nX direction:\n");

	wx = get_yt(f_x)
	printf("%12s%12s%12s%12s%12s\n","Freq,Hz", "Q", "W", "Grms", "3xGrms");
	G = sqrt(Pi/2 * f_x * Q * wx);
	printf("%12.2f%12.2f%12.2f%12.2f%12.2f\n", f_x, Q, wx, G, 3*G);

	printf("\n");
	printf("Y psd input file:%s\n", filey);
	record = 0;
	while(getline < filey > 0){
	       xt[++record] = $1;
		   yt[record] = $2;
	}
	printf("\nY direction:\n");

	wy = get_yt(f_y)
	printf("%12s%12s%12s%12s%12s\n","Freq,Hz", "Q", "W", "Grms", "3xGrms");
	G = sqrt(Pi/2 * f_y * Q * wy);
	printf("%12.2f%12.2f%12.2f%12.2f%12.2f\n", f_y, Q, wy, G, 3*G);

	printf("\n");
	printf("Z psd input file:%s\n", filez);
	record = 0;
	while(getline < filez > 0){
	       xt[++record] = $1;
		   yt[record] = $2;
	}
	printf("\nZ direction:\n");

	wz = get_yt(f_z)
	printf("%12s%12s%12s%12s%12s\n","Freq,Hz", "Q", "W", "Grms", "3xGrms");
	G = sqrt(Pi/2 * f_z * Q * wz);
	printf("%12.2f%12.2f%12.2f%12.2f%12.2f\n", f_z, Q, wz, G, 3*G);

}

function get_yt(x){
    i = 0;
	while(x<xt[++i]);
	
    j = i+1;
	
	return exp( log(xt[j]/x) / log(xt[j]/xt[i]) * log(yt[i]) + log(x/xt[i]) / log(xt[j]/xt[i]) * log(yt[j]));
}
