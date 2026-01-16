BEGIN{ FS=",";

	for(i=1;i<=ARGC;++i){
		n = split(ARGV[i], out, "=");
		data[out[1]] = out[2]
	}
	####print data["grid"]
	file = data["file"]
	x = data["x"]
	y = data["y"]
	z = data["z"]
	tolr = data["tolr"]

	tolrz = 1.
        rad = sqrt(x*x + y*y)
	min_distance = 1.E+12
	while (getline < file > 0){
		if ($1 ~ /GRID/) {
		    x0 = $4
		    y0 = $5
		    z0 = $6
		    rad0 = sqrt(x0*x0+y0*y0)

		    if (abs(rad0-rad) < tolr && abs(z-z0)<tolrz){
			    print $2
		            if (abs(y0) < min_distance){
			        min_grid = $2
			        min_distance = abs(y0)
		            }
	            }
		}
	}

	printf("\n\nExtreme Grid:\n")
	print min_grid

}

function abs(x){
    if (x>0) {
	      return x
      } else {
              return -x
      }
}

