BEGIN {
	#####print ARGC
	if (ARGC < 6){
		 printf("usage: awk -f nastran-interface-loads-psd.awk dir=1 pch=pchfile g=9.81 M0=231.6 Q=10. element=16000000\n");
		 exit;
	 }

	for(i=1;i<ARGC;++i){
		####print ARGV[i];
	        split(ARGV[i],input,"=");
		data[input[1]] = input[2];
	}

        element = data["element"]
           file = data["pch"]
              G = data["g"]
            dir = data["dir"]
	     M0 = data["M0"]
	      Q = data["Q"]
		
	while (getline < file > 0){
              if ($0 ~ /^\$ELEMENT FORCES - PSDF/){
                  readline()
                  readline()
                  readline()
                  readline()
	         if ($0 ~ /^\$ELEMENT ID/){
                     if ($4 == element){
                         while (readline() && $0 !~ /\$TITLE/){
                                freq[++record] = $1
                                for(i=2;i<=4;++i)
                                    force[i-1] = $i          

                                readline()
                                for(i=2;i<=4;++i)
                                    force[i+2] = $i          
                      
                                ####print freq[record], force[1], force[2], force[3], force[4], force[5], force[6]
                                fsd[record] = force[dir] / (G*G)
                         } 
                     }
                 }    
              }
              if ($0 ~ /^\$ELEMENT FORCES - RMS/){
                  readline()
                  readline()
                  readline()
                  readline()
                  readline()
                  while ($1 != element){
                         readline() 
                  } 
                  #######print $0
                                for(i=2;i<=4;++i)
                                    force[i-1] = $i          

                                readline()
                                for(i=2;i<=4;++i)
                                    force[i+2] = $i          
                                #######print force[1], force[2], force[3], force[4], force[5], force[6]
                                rms = force[dir] / G
              }
        } ### while getline
		 
            printf("%12s,%24s, Direction=,%d, M0=,%.2f, Q=,%.2f, RMS=,%.2f\n","Freq(Hz)","FSD", dir, M0, Q, rms)
		    for(i=1; i<=record; ++i){
		        printf("%12.2f,%24.6f,\n", freq[i], fsd[i])
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

function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}
