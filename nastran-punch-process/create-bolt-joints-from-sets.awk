BEGIN{

      FS=",";
      if (ARGC< 4) {
                   print "usage: awk -f create-bolt-joints-from-sets.awk file=mesh.dat sets=input.dat diameter=d"
                   exit
      }

      for(i=1;i<=ARGC;++i){
          n=split(ARGV[i],out,"=")
          data[out[1]] = out[2]
      }

      file = data["file"]
	  sets = data["sets"]
	  diameter = data["diameter"]
      ######print file, sets, diameter
	  
	  while (getline < file > 0){
	  
	         if ($0 ~ /^GRID/){
			     grids[$2] = $0
				 ++ngrids
				 if ($2 > next_grid)
				     next_grid = $2
			 }
			 
			 if ($0 ~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP|CBEAM|CBAR|CONM/) {
				 if ($2 > next_element)
				     next_element = $2			     
			 }
			 
			 if ($0 ~ /PSOLID|PBUSH|PSHELL|PBEAML|PBAR/) {
				 if ($2 > next_property)
				     next_property = $2	
			 }
			 
			 if ($0 ~ /MAT1/) {
				 if ($2 > material)
				     material = $2	
			 }
	  }
	  
	  ++next_grid
	  ++next_element
	  ++next_property
	  ++material
	  
	  if (length(next_property) > 8) next_property = 100
	  
	  while (getline < sets > 0){
	         if ($0 ~ /^[0-9]/ ) {
			 
			      xc = 0.
				  yc = 0.
				  zc = 0.
				 num = 0
				 
				 n = split(grids[$1], fields, ",")
				 refcs = fields[3]
				 discs = fields[7]
				 
				 
			     for(i=1;i<=NF;++i){
					 n = split(grids[$i], fields, ",")
					 ####print grids[$i]
					 ####print i, fields[4], fields[5], fields[6], n
					 if (n > 0) {
					     xc += fields[4]
					     yc += fields[5]
					     zc += fields[6]
						 connections[++num] = $i
					 }
				 }
				 xc /= num
				 yc /= num
				 zc /= num
				 grid = next_grid++
				 bolts[++nbolts] = grid
                                 xbolt[nbolts] = xc
                                 ybolt[nbolts] = yc
                                 zbolt[nbolts] = zc
				 printf("GRID,%d,%d,%.6f,%.6f,%.6f,%d\n", grid, refcs, xc, yc, zc, discs) 
				 printf("$* Mesh Collector: AWK spreader - %.6f diameter\n", diameter)
                 printf("$* Mesh: AWK CBAR spreader - %.6f diameter\n", diameter)

				 for(i=1;i<=num;++i){
				     n = split(grids[connections[i]], fields, ",")
					 norm = normal(fields[4]-xc, fields[5]-yc, fields[6]-zc)
					 #####print norm
				     printf("CBAR,%d,%d,%d,%d,%s,\n", next_element++, next_property, grid, connections[i], norm)
				 }	 
				 printf("\n")				 
			 }
	  }
     printf("$* AWK Property: spreader-%.4f diameter from aluminium\n", diameter)
     printf("$* AWK Section: D=2 x %.4f\n", 2 * diameter)
     printf("PBARL,%d,%d,MSCBML0,ROD,,,,,+\n+,%.6f,0.0,\n", next_property, material, diameter)
	 
         next_property++
	 printf("$* AWK Material: Al7075\n")
	 printf("MAT1,%d,6.83E10,2.57E10,.33,0.0,2.28E-5,20.0,0.0,\n",material)
	 
	 printf("$* Mesh Collector: AWK bolt - %.6f diameter\n", diameter)
         printf("$* Mesh: AWK CBAR bolt - %.6f diameter\n", diameter)
         for(i=1; i<nbolts; i+=2){
             ##############################print bolts[i], bolts[i+1]	 
             norm = normal(xbolt[i]-xbolt[i+1], ybolt[i]-ybolt[i+1], zbolt[i]-zbolt[i+1])
	     printf("CBAR,%d,%d,%d,%d,%s,\n", next_element++, next_property, bolts[i], bolts[i+1], norm)
         }

         printf("$* AWK Property: bolt-%.4f diameter from aluminium\n", diameter)
         printf("$* AWK Section: D=3 x %.4f\n", 3. * diameter)
         printf("PBARL,%d,%d,MSCBML0,ROD,,,,,+\n+,%.6f,0.0,\n", next_property, material, 3. * diameter / 2.)
}

function readline(){
  if (getline < file > 0)
      return 0;
  else {
       printf("can not read file:%s\n", file);
	   exit;
	   }
}

function normal (nx, ny, nz){
    	
	if (nx != 0.) { 
	    ry = 1.0 
		rz = 0. 
		rx = -ny / nx
	} else if (ny != 0.) {
	    rz = 1.0 
		rx = 0. 
		ry = -nz / ny		
	} else {
	    rx = 1.0 
		ry = 0. 
		rz = -nx / nz		
	}
		
	mag = sqrt(rx*rx + ry*ry + rz*rz)
	rx /= mag
	ry /= mag
	rz /= mag
	return sprintf("%.6f,%.6f,%.6f",rx,ry,rz)
}



