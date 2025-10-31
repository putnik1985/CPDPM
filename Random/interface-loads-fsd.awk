BEGIN {
	#####print ARGC
	if (ARGC < 7){
		 printf("usage: awk -f interface-loads-psd.awk dir=1 meff=meff-file g=9.81 M0=23. Q=10. file=inputfilename\n");
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
        mfile = data["meff"]
        G = data["g"]
        dir = data["dir"]
		M0 = data["M0"]
		Q = data["Q"]
		
        record=0;
	FS = ","
	while (getline < file > 0){
	       freq[++record] = $1
	       psd[record] = $2

        } ### while getline
	
	while (getline < mfile > 0){
	       ####print $1
           if ($1 ~ /[0-9]/) {
		       F[++mrecord] = $2
               MPFX[mrecord] = $3
               MPFY[mrecord] = $4
               MPFZ[mrecord] = $5
			   
            }			   
        } ### while getline
 					 
					 for(k=1;k<=mrecord;++k){
					     if (dir==1) { 
						   MPF = MPFX[k]
                         } else if (dir == 2) {
                           MPF = MPFY[k]
                         } else {
                           MPF = MPFZ[k]
                         }
						 Mresidual += MFP
				     }
				     M0 /= G
                         Mresidual = M0 * (1. - Mresidual)

            segments = 10
			ksi = 1./ (2.*Q)
			
		    for(i=1; i<record;++i){
			     fmin = freq[i]
			     fmax = freq[i+1]
			     df = (fmax - fmin) / segments
			     for(j=0;j<=segments;++j){
				     f = fmin + df * j 
					 psda = psd[i] + (f - freq[i])/(freq[i+1] - freq[i])*(psd[i+1] - psd[i])
					 
				     sfreq[++frecord]=f
					 rMapp = 0.
					 iMapp = 0.
					 for(k=1;k<=mrecord;++k){
					     if (dir==1) { 
						              MPF = MPFX[k]
                         } else if (dir == 2) {
                                      MPF = MPFY[k]
                         } else {
                                      MPF = MPFZ[k]
                         }
						 
						 rMapp += MFP * rT(k, f)
						 iMapp += MFP * iT(k, f)
				     }
					     rMapp = Mresidual + M0 * rMapp
						 iMapp =             M0 * iMapp
						 sff[frecord] = (rMapp*rMapp + iMapp*iMapp) * psda
						 
				     rms += sff[frecord] * df
		         }
		    }

                    rms = sqrt(rms)
            printf("%12s,%24s, Direction=,%d, M0=,%.2f, Q=,%.2f, RMS=,%.2f\n","Freq(Hz)","FSD", dir, M0*G, Q, rms)
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
