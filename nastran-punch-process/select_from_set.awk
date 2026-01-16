BEGIN{ FS=",";

	for(i=1;i<=ARGC;++i){
		n = split(ARGV[i], out, "=");
		data[out[1]] = out[2]
	}
	####print data["grid"]
	file = data["file"]
	skip = data["skip"]

	if (getline < file > 0) {
		print $1
	}

	while (getline < file > 0){
	       ++count
	       if (count == skip + 1) {
		       print $1
		       count = 0
	       }
	}

}


