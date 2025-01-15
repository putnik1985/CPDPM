BEGIN{
      if (ARGC < 6){
	       print "usage: awk -f notching.awk file=input.pch subcase=1 cbush=1981818 inputs=677368 notch=1172.0";
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
					   printf("%12s%12s%12s%12s%12s\n","Subcase#", "Freq,Hz", "Fx", "Fy", "Fz")
					   while (getline < file > 0 && $1 !~/TITLE/){
					          freq = $1;
                                                  fx = $2
					          fy = $3
					          fz = $4
						  if (freq ~ /^[0-9]/){
					              printf("%12d%12.1f%12.1f%12.1f%12.1f\n", subcase, freq, fx, fy, fz);
						      frequencies[++record]=freq;
						      load_x[freq] = fx;
						      load_y[freq] = fy;
						      load_z[freq] = fz;
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
        printf("%12s%12s%12s%12s%12s%12s%12s%12s\n","Subcase#", "Freq,Hz", "Ax", "Ay", "Az", "Fx", "Fy", "Fz")
	for(i=1; i<=record; ++i){
		freq = frequencies[i];
		fx = load_x[freq];
		fy = load_y[freq];
		fz = load_z[freq];
		f1 = max(fx,fy);
		fmax = max(f1,fz);
		sf = 1.0;
	        if (fmax > notch)
			sf = notch / fmax;

	        accel[excitation_direction "," freq] *= sf;	
	        ax = accel["1" "," freq];
	        ay = accel["2" "," freq];
	        az = accel["3" "," freq];

		fx *= sf;
		fy *= sf;
		fz *= sf;
                printf("%12d%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f%12.1f\n", subcase, freq, ax, ay, az, fx, fy, fz);
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
