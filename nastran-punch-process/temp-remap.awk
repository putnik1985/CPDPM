BEGIN {
       FS=","
       OFS = ","
       if (ARGC < 3) {
                   print "usage: awk -f temp-remap.awk basefile=in1 newset=in2"
                   exit
        }

        for(i=1;i<ARGC; ++i){
           n = split(ARGV[i],out,"=")
           data[out[1]] = out[2]
           #######print out[1] "," out[2]
        }
        base = data["basefile"]
         new = data["newset"]

        while(getline < new > 0){
              newset[$1] = $2
              ####print $1, $2
        }

        while(getline < base > 0) {
              if ($0 ~ /^TEMP/) {
                  if ( newset[$3] ){
                       $4 = newset[$3]
                       print "TEMP" "," $2 "," $3 "," $4
                  } else {
                       print $0
                  }
              }
        }
}
