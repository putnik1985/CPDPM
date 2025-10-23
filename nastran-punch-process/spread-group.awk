BEGIN { FS = ",";

        for(i=1;i<=ARGC;++i){

            n = split(ARGV[i], out, "=")
            data[out[1]] = out[2]
        }

        set = data["set"]
        file = data["file"]
        offset = data["offset"]

        key = sprintf("SET %d", set)
        while (getline < file > 0){
              if ($0 ~ key) {
                  split($0, out, "=")
                  line = out[2]

                  nline = split(line,words,",")
                  for(i=1;i<=nline;++i){
                      n = split(words[i],grids," ")
                      if (n==3) {
                          min = grids[1]
                          max = grids[3] 
                          for(k=min;k<=max;++k)
                              print k + offset
                      } else if (grids[1] ~ /[0-9]/){
                              print grids[1] + offset
                      }
                  }
                     
                  while (getline < file > 0 && $0 ~ /[0-9]/){
                         for(i=1;i<=NF;++i){
                             n = split($i,grids," ")
                             if (n==3) {
                              min = grids[1]
                              max = grids[3] 
                              for(k=min;k<=max;++k)
                                  print k + offset
                             } else if (grids[1] ~ /[0-9]/) {
                              print grids[1] + offset
                             }
                         }
                  }
              }
        }
}

