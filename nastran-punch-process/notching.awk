BEGIN{
      if (ARGC < 6){
	       print "usage: awk -f notching.awk file=input.pch subcase=1 cbush=1981818 inputs=677368 notch=1225.5,1225.5,1225.5,25421.4,43235.3,27373.4";
	       exit;
       }

        type["cbush"] = 102;
	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	 file  = data["file"];
      subcase  = data["subcase"];
	  eid  = data["cbush"];
       inputs  = data["inputs"];
        notch  = data["notch"];
        label  = "cbush";

       split(notch,t,",");
	   fx_notch = t[1];
	   fy_notch = t[2];
	   fz_notch = t[3];
	   mx_notch = t[4];
	   my_notch = t[5];
	   mz_notch = t[6];
	   ##############print fx_notch, fy_notch, fz_notch, mx_notch, my_notch, mz_notch
	   
       excitation_type = "$ACCELERATION";
       excitation_direction = subcase;

        ######print file, label, eid
	type_number = type[label];
	####print type_number;
	record = 0;

	while (getline < file > 0){
		if ($0 ~ /SUBCASE ID/ && $4 == subcase){
                        #####print $0;
			if (getline < file >0){
				####print $4;
				if ($0 ~ /ELEMENT TYPE/ && $4 == type_number){
                                        #####print $0;
					if (getline < file > 0){
						found = ($4 == eid)
					}

					while (!found && $0 !~ /TITLE/)
					        if (getline < file > 0)
						   found = ($1 == eid)
					   
                                        if (found){
					   printf("%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq,Hz", "Fx", "Fy", "Fz", "Mx", "My", "Mz")
					   while (getline < file > 0 && $1 !~/TITLE/){
					          freq = $1;
                              fx = $2
					          fy = $3
					          fz = $4
							  getline < file
							  mx = $2;
							  my = $3;
							  mz = $4
						  if (freq ~ /^[0-9]/){
					              printf("%12d%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f\n", subcase, freq, fx, fy, fz, mx, my, mz);
						      frequencies[++record]=freq;
						      load_x[freq] = fx;
						      load_y[freq] = fy;
						      load_z[freq] = fz;
							  mom_x[freq] = mx;
							  mom_y[freq] = my;
							  mom_z[freq] = mz;
					      }

				           }
				        }## if(found)
				}
			}
		}
		if ($0 ~ /\$ACCELERATION/){
			getline < file;
			getline < file;
			case_number = $4;
			getline < file;
			if ($0 ~ /POINT ID/)
		            point_id = $4;
			if (point_id == inputs && case_number == subcase){
				   ###print case_number, point_id
				   printf("%12s%12s%12s%12s%12s\n","Subcase#", "Freq,Hz", "Ax", "Ay", "Az")
				   while (getline < file > 0 && $1 !~/TITLE/){
					          ####print $0;
					          freq = $1;
                              ax = $3
			                  ay = $4 
					          az = $5 
						  if (freq ~ /^[0-9]/){
					              printf("%12d%12.1f%12.1f%12.1f%12.1f\n", subcase, freq, ax, ay, az);
						      accel["1" "," freq] = ax;
						      accel["2" "," freq] = ay;
						      accel["3" "," freq] = az;
					      }
				      }
			      }
		}
	}
	### do notching
	
	print "Notched Input and Output"
        printf("%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq,Hz", "Ax", "Ay", "Az", "Fx", "Fy", "Fz", "Mx", "My", "Mz")
	for(i=1; i<=record; ++i){
		freq = frequencies[i];
		
		fx = load_x[freq];
		fy = load_y[freq];
		fz = load_z[freq];
		mx = mom_x[freq];
		my = mom_y[freq];
		mz = mom_z[freq];
		
		s1 = calculate_sf(fx, fx_notch);
		s2 = calculate_sf(fy, fy_notch);
		s3 = calculate_sf(fz, fy_notch);
		s4 = calculate_sf(mx, mx_notch);
		s5 = calculate_sf(my, my_notch);
		s6 = calculate_sf(mz, mz_notch);

        smin_12 = min(s1, s2);
        smin_34 = min(s3, s4);
        smin_56 = min(s5, s6);		

        s1 = min(smin_12, smin_34)
		sf = min(s1, smin_56);

	        accel[excitation_direction "," freq] *= sf;	
	        ax = accel["1" "," freq];
	        ay = accel["2" "," freq];
	        az = accel["3" "," freq];

		fx *= sf;
		fy *= sf;
		fz *= sf;
		mx *= sf;
		my *= sf;
		mz *= sf;

                printf("%12d%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f\n", subcase, freq, ax, ay, az, fx, fy, fz, mx, my, mz);
	}

	print "";
	print "Nastran Input Table";
	print "TABLED1,99999,linear,linear,"
	G = 386.1;
	num_per_row = 8;
	current = 0;
	for(i=1;i<=record;++i){
		if (current == 0) 
	            printf("+,");

	        freq = frequencies[i];
	        notched_a = accel[excitation_direction "," freq] / G;	
                printf("%.1f,%.2f,",freq, notched_a);
		current+=2;
		if (current == 8){
			printf("+\n");
			current = 0;
		}
	}
	printf("endt\n");
}

function max(a,b){
	if (a > b)
            return a;
	else 
	    return b;
}

function calculate_sf(f, fnotch){
 if (f <= fnotch)
     return 1.; 
 else
     return fnotch / f;
}

function min(a,b){
	if (a > b)
            return b;
	else 
	    return a;
}
