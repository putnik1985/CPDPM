BEGIN {
	#####print ARGC
	if (ARGC < 7){
		 printf("usage: awk -f force-limits-psd.awk M0=23. c=2.5 n=1.3 f0=45. g=9.81 file=inputfilename\n");
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
	M0 = data["M0"]
	c = data["c"]
	f0 = data["f0"]
	n = data["n"]
	G = data["g"]


        record=0;
	FS = ","
	while (getline < file > 0){
	       freq[++record] = $1
	       psd[record] = $2

        } ### while getline
	            segments = 10. ## number of segments between each frequencies 
		    M0 = M0 / G ## convert to massforce per g 

		    for(i=1; i<record;++i){
			     fmin = freq[i]
			     fmax = freq[i+1]
			     df = (fmax - fmin) / segments
			     ##################print fmin, fmax, df
			     for(j=0;j<=segments;++j){
				 f = fmin + df * j 
				 sfreq[++frecord]=f
				 if (f<f0) {
                                     sff[frecord]=c*c*M0*M0*(psd[i] + (f - freq[i])/(freq[i+1] - freq[i])*(psd[i+1] - psd[i]))
				 }else {
                                     sff[frecord]=c*c*M0*M0*pow(f0/f,2*n)*(psd[i] + (f - freq[i])/(freq[i+1] - freq[i])*(psd[i+1] - psd[i]))
				 }
				 rms += sff[frecord] * df
		             }
		    }
                    rms = sqrt(rms)
                    printf("%12s,%24s, M0=, %.2f, C=,%.2f, RMS=, %.2f,\n","Freq(Hz)","FSD(NASA-HDBK-7004C)", M0*G, c, rms)
		    for(i=1; i<=frecord; ++i){
			   printf("%12.2f,%24.6f,\n", sfreq[i], sff[i])
		    }
 }

 function log10(x){
	 return log(x)/log(10.);
 }

 function pow(a,x){
	 return exp(x * log(a));
 }

 function calculate_psd(y2, f1, f2, m){
	 y1 = y2 * pow(f1/f2, (m / 10.) / log10(2))
	 return y1;
 }
