BEGIN{
     FS = ","
	 if (ARGC < 2) {
	                print "usage awk -f htvx-combine-load.awk file=qs-input.txt"
					exit
					}
     for(i=1;i<ARGC; ++i){
         n = split(ARGV[i], out, "=")
         data[out[1]] = out[2]
     }
     print "Input File: " data["file"]
     file = data["file"]
   
     while(getline < file > 0){ 
	 
           if ($0 ~ /TNLUF/){
		       ##print $0
               n = split($0, out, "=")
               tnluf = out[2]
           }

           if ($0 ~ /RNLUF/){
               n = split($0, out, "=")
               rnluf = out[2]
           }

           if ($0 ~ /tfactor/){
               n = split($0,out,"=")
               tfactor = out[2]
           }
           if ($0 ~ /rfactor/){
               n = split($0,out,"=")
               rfactor = out[2]
           }
           if ($0 ~ /ranfactor/){
               n = split($0,out,"=")
               ranfactor = out[2]
           }
           if ($0 ~ /^Random Factors/){
               ###print $0
               readline()
			   for(i=1; i<=NF; ++i)
			       ran[i] = $i
           }
		   if ($0 ~ /^XPL,YPL,ZPL/) {
		       while (readline() && $0 ~ /^[+-]?[0-9]/){
			          ##print NF, $0
			          for(i=1; i<=3; ++i)
					      if (t[i] < abs($i)) t[i] = abs($i)
			          for(i=4; i<=NF; ++i)
					      if (r[++j] < abs($i)) r[j] = abs($i)

			   }
		   }
     }
            ###combine the loads
            for(i=1; i<=3; ++i){
			    t[i] *= tfactor
				r[i] *= rfactor
			  ran[i] *= ranfactor
			}
			out[1] = tnluf * sqrt(t[1]*t[1] + ran[1]*ran[1])
			out[2] = tnluf * sqrt(t[2]*t[2] + ran[2]*ran[2])
			out[3] = tnluf * max(abs(1.8 + sqrt((t[3] - 1.8)*(t[3] - 1.8) + ran[3]*ran[3])), abs(1.8 - sqrt((t[3] - 1.8)*(t[3] - 1.8) + ran[3]*ran[3])))
			out[4] = rnluf * r[1]
			out[5] = rnluf * r[2]
			out[6] = rnluf * r[3]
			printf("Worst-case scenario:\n")
			for(i1=1; i1<=2; ++i1)
			    for(i2=1; i2<=2; ++i2)
				    for(i3=1; i3<=2; ++i3)
					    for(i4=1; i4<=2; ++i4)
						    for(i5=1; i5<=2; ++i5)
							    for(i6=1; i6<=2; ++i6)	
printf("%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,\n", pow(i1) * out[1], pow(i2) * out[2], pow(i3) * out[3], pow(i4) * out[4], pow(i5) * out[5], pow(i6) * out[6])
			printf("\n")	
}

function pow(n){
  if (n==1) {
         return 1
  } else {
         return -1
  }
}

function abs(x){
  if (x > 0) {
      return x
  }
  else {
       return -x
  }
}

function max(a, b){
  if (a>b) {
      return a
   } else {
      return b
   }
}

function readline(){
   success = getline < file;
   if (success < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return success;
}
