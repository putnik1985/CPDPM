BEGIN{ FS=","; OFS = ",";
       
       for(i=1; i<=ARGC; ++i){
           n = split(ARGV[i], out, "=");
           data[out[1]] = out[2]
       }

       offset = data["offset"]
         file = data["file"]

       ####print data["file"], data["offset"]
       
       while (getline < file > 0) {

             if ($0 ~ /RBE3/){
                 for(i=8;i<=NF;++i)
                     if ($i ~ /[0-9]/) $i += offset
             } 
             if ($0 ~ /^\+/){
                 for(i=1;i<=NF;++i)
                     if ($i ~ /[0-9]/) $i += offset
             } 
             print $0
       }
}
