BEGIN{
	if (ARGC<4) {
		print "usage: awk -f load-combinations.awk file=in.dat max_shear=7800 grid=100 csys=100"
		exit
	}

	### in csys X is axial
	for(i=1;i<=ARGC;++i){
		n = split(ARGV[i], out, "=")
		data[out[1]] = out[2]
	}
	#####print data["file"], data["max_shear"]
        file = data["file"]
	max_shear = data["max_shear"]
	grid = data["grid"]
        csys = data["csys"]

	load_case = 100

	FS = ","
	pi = 3.14159
	while(getline < file > 0){
              ###print $1, $2
	      moment = $1
	       force = $2

          if (moment > 0.){
              mpoint[++points] = $1
		      fpoint[points] = $2
          }
		  
	      printf("\n$------------------------------------------------\n")
	      printf("$corner point: %.2fN, %.2fNm\n", force, moment)
	      printf("$------------------------------------------------\n")

	      if (force <= 0.){
		              fx = 0.
			      fy = 0.
			      fz = 0.
	                      for(k=1; k<=8; ++k){
		                  angle = k * pi / 4.
		                  mx = 0.
		                  my = moment * cos(angle)
		                  mz = moment * sin(angle)
				  ++load_case
	                          printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
							  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
	                      }
		      continue
	      }

	      if(force > max_shear){
		      fx = sqrt(force * force - max_shear * max_shear)
		      for(k1=1; k1<=8; ++k1){
			      angle1 = k1 * pi / 4.
			      fy = max_shear * cos(angle1)
			      fz = max_shear * sin(angle1)
	                      for(k=1; k<=8; ++k){
		                  angle = k * pi / 4.
		                  mx = 0.
		                  my = moment * cos(angle)
		                  mz = moment * sin(angle)
				  ++load_case
	                          printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
							  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
							  
				  if (moment <= 0.) {
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
				  break
			          }
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
	                      }
		      }
		      fx = force
			      fy = 0.
			      fz = 0.
	                      for(k=1; k<=8; ++k){
		                  angle = k * pi / 4.
		                  mx = 0.
		                  my = moment * cos(angle)
		                  mz = moment * sin(angle)
				  ++load_case
	                          printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
							  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
				  if (moment <= 0.) { 
	                                              printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
						      break
			          }
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
	                      }
  	      } else {
		      fx = 0.
		      for(k1=1; k1<=8; ++k1){
			      angle1 = k1 * pi / 4.
			      fy = force * cos(angle1)
			      fz = force * sin(angle1)
	                      for(k=1; k<=8; ++k){
		                  angle = k * pi / 4.
		                  mx = 0.
		                  my = moment * cos(angle)
		                  mz = moment * sin(angle)
				  ++load_case
	                          printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
							  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
				  if (moment <= 0.) {
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
				  break
			          }
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
	                      }
		      }
		      fx = force
			      fy = 0.
			      fz = 0.
	                      for(k=1; k<=8; ++k){
		                  angle = k * pi / 4.
		                  mx = 0.
		                  my = moment * cos(angle)
		                  mz = moment * sin(angle)
				  ++load_case
	                          printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
							  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
				  if (moment <= 0.) {
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
				  break
			          }
	                          printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
	                      }
              }

        }


	      printf("\n$------------------------------------------------\n")
	      printf("$ Torque Cases:\n")
	      printf("$--------------------------------------------------\n")

		  for(i=1; i<=points; ++i){
	          printf("\n$------------------------------------------------\n")
	          printf("$corner point: %.2fN, %.2fNm\n", fpoint[i], mpoint[i])
	          printf("$------------------------------------------------\n")
			  mx = mpoint[i]
			  my = 0.
			  mz = 0.
			  force = fpoint[i]
			  
		  if (force <= 0.) {
		          fx=0.
				  fy=0.
				  fz=0.
				  ++load_case
	              printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
				  			  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
				  continue
          }  				  
	      if(force > max_shear){
		      fx = sqrt(force * force - max_shear * max_shear)
		      for(k1=1; k1<=8; ++k1){
			      angle1 = k1 * pi / 4.
			      fy = max_shear * cos(angle1)
			      fz = max_shear * sin(angle1)
				  ++load_case
	              printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
	              printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
                  			  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
		      }
		      fx = force
			      fy = 0.
			      fz = 0.
				  ++load_case
	              printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
                  printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
				  			  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
  	      } else {
		      fx = 0.
		      for(k1=1; k1<=8; ++k1){
			      angle1 = k1 * pi / 4.
			      fy = force * cos(angle1)
			      fz = force * sin(angle1)
				  ++load_case
				  printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
	              printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
				  			  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
		      }
		      fx = force
			      fy = 0.
			      fz = 0.
				  ++load_case
	              printf("force,%d,%d,%d,1.,%.2f,%.2f,%.2f\n",load_case,grid,csys,fx,fy,fz)
	              printf("moment,%d,%d,%d,1.,%.2f,%.2f,%.2f\n\n",load_case,grid,csys,mx,my,mz)
				  			  str = sprintf("%s,%s,%s,%s,%s,%s,",fx,fy,fz,mx,my,mz)
							  print str > "load-combinations-for-process.dat"
	                 
              }			  
		  } ## points cycle

	printf("\n")
	for(i=101; i<=load_case; ++i){
		str = sprintf("subcase %d\n", i)
		print str "load = " i > "nastran-case.dat"
	}

}
