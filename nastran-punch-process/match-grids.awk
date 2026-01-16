BEGIN{ FS=",";

	for(i=1;i<=ARGC;++i){
		n = split(ARGV[i], out, "=");
		data[out[1]] = out[2]
	}
	####print data["grid"]
	filein = data["in"]
	fileout = data["out"]
        ####print filein, fileout

	while(getline < fileout > 0){
		outgrids[++nout] = $0
	}

	while(getline < filein > 0){
		grid = $2
		   x = $4
		   y = $5
		   z = $6
		pair = find_closest(x, y, z)
		print grid, pair
	}
}

function find_closest(x0, y0, z0) {
         dmin = 1.E+12
         for(i=1; i<=nout; ++i){
		 n = split(outgrids[i], info, ",")
		 x = info[4]
		 y = info[5]
		 z = info[6]
		 d = sqrt((x-x0)*(x-x0) + (y-y0)*(y-y0) + (z-z0)*(z-z0))
		 if (d < dmin){
			 dmin = d
			 mingrid = info[2]
		 }
	 }
	 return mingrid
 }
