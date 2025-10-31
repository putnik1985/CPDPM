BEGIN {
	#####print ARGC
	if (ARGC < 4){
		 printf("usage: awk -f notched-force-rms-fsd.awk interface=interface-file rms=limit-file psd=input-psd-file\n");
		 exit;
	 }

	for(i=1;i<ARGC;++i){
		####print ARGV[i];
	        split(ARGV[i],input,"=");
		data[input[1]] = input[2];
	}

        rms = data["rms"];
        interface = data["interface"];
        file = data["psd"];
		
        record=0;
	FS = ","

	while (getline < file > 0){
	       freq[++record] = $1
	       psd[record] = $2

        } ### while getline
        ## calculate input frequency range
	dfreq = freq[record] - freq[1]
	limit_psd = rms*rms / dfreq
        ####print dfreq, limit_psd

	segments = 10
	for(i=1;i<record;++i){
		fmin = freq[i]
		fmax = freq[i+1]
		df = (fmax - fmin)/segments
		for(j=0;j<=segments;++j){
			f = fmin + df * j
		        psda = psd[i] + (f - freq[i])/(freq[i+1] - freq[i])*(psd[i+1] - psd[i])
			ifreq[++irecord] = f
			isd[irecord] = psda
			inputrms += psda * df
		}
	}
        inputrms = sqrt(inputrms)
	
	getline < interface
	M0interface = $6
	Direction = $4
	Q = $8
	RMSinterface = $10

	while(getline < interface > 0){
              infreq[++inrecord] = $1
	      insd[inrecord] = $2
		  ###print insd[inrecord]
        }
	#####print irecord, lrecord, inrecord
	
	for(i=1;i<=irecord;++i){
		if (insd[i] > limit_psd) {
		    ####print isd[i], limit_psd, insd[i]
			notch[i] = isd[i] * limit_psd / insd[i]
			dB = 10. * log10(notch[i]/isd[i])
			if (dB < dB_min) dB_min = dB
		} else { 
		        notch[i] = isd[i]
		}
		if (i>=2) {
			nrms+=(ifreq[i]-ifreq[i-1])*notch[i]
		}
	}

	nrms = sqrt(nrms)
	printf("%12s,%12s(RMS=%.2f),%12s(RMS=%.2f),%12s(RMS=%.2f),%12s(RMS=%.2f)\n", "Freq(Hz)", "Input", inputrms, "Limit", rms, "Interface", RMSinterface, "Notched", nrms)
	for(i=1;i<=irecord;++i)
	    printf("%12.2f,%12.4f,%12.4f,%12.4f,%12.8f\n", ifreq[i], isd[i], limit_psd, insd[i], notch[i])

	printf("\nM0Limit,M0Interface,Direction,Q,Minimum dB,\n");
	printf("%.2f,%.2f,%d,%.2f,%.4f,\n", M0limit, M0interface, Direction, Q, dB_min)
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

function rT(n, f, f0) {
   s = f / F[k]
   return ( (1-s*s) + 4 * ksi * ksi * s * s) / ((1-s*s)*(1-s*s) + 4. * ksi * ksi * s * s)
}

function iT(n, f, f0) {
   s = f / F[k]
   return -( 2 * ksi * s * s * s) / ((1-s*s)*(1-s*s) + 4. * ksi * ksi * s * s)
}
