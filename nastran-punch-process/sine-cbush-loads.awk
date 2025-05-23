BEGIN{
      if (ARGC < 3){
	       print "usage: awk -f sine-cbush-loads.awk file=input.pch cbush=1981836";
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
     	  eid  = data["cbush"];
        label  = "cbush";
    	type_number = type[label];

    	record = 0;
		
	while (getline < file > 0){
		if ($0 ~ /SUBCASE ID/){
		    subcase_num = $4;
			if (getline < file >0){
				####print $4;
				if ($0 ~ /ELEMENT TYPE/ && $4 == type_number){

					if (getline < file > 0){
						found = ($4 == eid)
					}
                       if (found){
					              subcase[++record]=subcase_num;
					              printf("%12s,%12s,%12s,%12s,%12s,%12s,%12s,%12s,\n","Subcase#", "Freq(Hz)", "Fx", "Fy", "Fz", "Mx", "My", "Mz")
								  fx_max = 0
								  fy_max = 0
								  fz_max = 0
					              while (getline < file > 0 && $1 !~/TITLE/){
					                     freq = $1;
                                         fx = $2
					                     fy = $3
					                     fz = $4
										 getline < file;
										 mx = $2
										 my = $3
										 mz = $4
										 
						                 if (freq ~ /^[0-9]/){
										     if (fx > fx_max) fx_max = fx;
											 if (fy > fy_max) fy_max = fy;
                                             if (fz > fz_max) fz_max = fz;
                                             calculate_global_max(fx, fy, fz, mx, my, mz)											 
					                         printf("%12d,%12.1f,%12.1f,%12.1f,%12.1f,%12.1f,%12.1f,%12.1f,\n", subcase_num, freq, fx, fy, fz, mx, my, mz);
					                     }

				                  }### while (getline < file > 0 && $1 !~/TITLE/)
								  printf("\n");
				        }## if(found)
						found = 0;
						FX_MAX[record] = fx_max;
						FY_MAX[record] = fy_max;
						FZ_MAX[record] = fz_max;
				}
			}
		} ####if ($0 ~ /SUBCASE ID/)
	}
	printf("\n\nTable Of The Maximum Loads For each Subcase\n");
	printf("%12s,%12s,%12s,%12s,\n","Subcase", "Fx", "Fy", "Fz");
	for(i=1; i<=record;++i)
	    printf("%12d,%12.1f,%12.1f,%12.1f,\n",subcase[i], FX_MAX[i], FY_MAX[i], FZ_MAX[i]);

	printf("\n\nTable Of The Maximum Sine Loads Element:,%d\n", eid);
	printf("Fx,%.1f\n",global_fx)
	printf("Fy,%.1f\n",global_fy)
	printf("Fz,%.1f\n",global_fz)
	printf("Mx,%.1f\n",global_mx)
	printf("My,%.1f\n",global_my)
	printf("Mz,%.1f\n",global_mz)	
}

function max(a,b){
	if (a > b)
            return a;
	else 
	    return b;
}

function calculate_global_max(fx, fy, fz, mx, my, mz){
   if (fx > global_fx) global_fx = fx;
   if (fy > global_fy) global_fy = fy;
   if (fz > global_fz) global_fz = fz;
   if (mx > global_mx) global_mx = mx;
   if (my > global_my) global_my = my;
   if (mz > global_mz) global_mz = mz;
}   