BEGIN {
	if (ARGC < 2){
		 printf("usage: awk -f generate-psd-table.awk file=inputfilename\n");
		 exit;
	 }

	for(i=1;i<ARGC;++i){
		####print ARGV[i];
	        split(ARGV[i],input,"=");
		data[input[1]] = input[2];
	}

	if (!data["file"])
		printf("no file included\n");

        file = data["file"];
        record=0;
	while (getline < file > 0){
		split($0,line,",");
		#print line[1], line[2], line[3];
		#
                if (line[3] !~ /dB/){
			freq[++record]=line[1];
			   psd[record] = line[3];
			freq[++record] = line[2];
			   psd[record] = line[3];
		 }

                if (line[3] ~ /dB/){
			split(line[3],number,"dB/oct");
			++record;
                        if ( psd[record - 1] > 0){
                             ## there is a number at the previous point
		             y2 = psd[record - 1];
			     f2 = freq[record - 1];
			     f1 = line[2];
			     m = number[1];
                             y1 = calculate_psd(y2, f1, f2, m);
			     freq[record] = f1;
			      psd[record] = y1;
		     } ## if psd[record-1] > 0
		     else {
			     f1 = line[1];
		              m = number[1];
			     getline < file;
		             split($0,line,",");
                             if (line[3] ~ /[a-z]|[A-Z]/){
				     printf("wrong spectrum\n");
				     exit;
			     }
                             f2 = line[1];
			     y2 = line[3];
                             y1 = calculate_psd(y2, f1, f2, m);

			     freq[record] = f1;
			     psd[record] = y1;

			     freq[++record]=line[1];
			      psd[record] = line[3];
			     freq[++record] = line[2];
			      psd[record] = line[3];
		     }### if psd[record-1]

		 }
        }
		    for(i=1; i<=record;++i){
			    printf("%12.2f%12.4f\n",freq[i], psd[i]);
		    }
 }

 function log10(x){
	 return log(x)/log(10.);
 }

 function pow(a,x){
	 return exp(x * log(a));
 }

 function calculate_psd(y2, f1, f2, m){
	 y1 = y2 * pow(f1/f2, (m / 10.) / log10(2));
	 return y1;
 }
