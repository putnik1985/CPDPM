BEGIN{ FS=",";

	for(i=1;i<=ARGC;++i){
		n = split(ARGV[i], out, "=");
		data[out[1]] = out[2]
	}
	####print data["grid"]
	file = data["file"]
	sectors = data["sectors"]

	xc = data["xc"]
	yc = data["yc"]
	zc = data["zc"]

	while(getline < file > 0){
		if ($1 ~ /^GRID/) {
		   grids[++nout] = $0
		   ####print $0
		}
	}
    #########print nout
    pi = 3.14195
	alpha = 2. * pi / sectors
	rad = 160.
	
	for(k=0; k<sectors; ++k){
		   teta = alpha * k
		   ##rotation along z
		   x = rad * cos(teta) + xc
		   y = rad * sin(teta) + yc
        ########printf("%.6f,%.6f,%.6f\n",x,y,zc)
		grid = find_closest(x, y, z)
		print grid
	}

}

function find_closest(x0, y0, z0) {
         dmin = 1.E+12
         for(i=1; i<=nout; ++i){
		 n = split(grids[i], info, ",")
		 
		 x1 = info[4]
		 y1 = info[5]
		 z1 = info[6]
		 ##########print "-->", info[2]
		 
		 d = sqrt((x1-x0)*(x1-x0) + (y1-y0)*(y1-y0))
		 if (d < dmin){
			 dmin = d
			 mingrid = info[2]
		 }
	 }
	 ########print mingrid, dmin
	 return mingrid
 }

