BEGIN{
      if (ARGC<2) {
                  print "usage: awk -f create_sassi_input.awk file=file_w_group_sets.dat set=5"
                  exit
      }

      for(i=1; i<=ARGC; ++i){
          n = split(ARGV[i],out,"=")
          data[out[1]] = out[2]
      }

        file = data["file"]
      set_id = data["set"] 
      while(getline < file > 0){
            if ($1 ~ /^SET$/  && $2 == set_id) {
                   n = split($0, line, "=")
                   print_ranges(line[2])
                   while (getline < file > 0 && $0 !~ /^\$/) {
                          print_ranges($0)
                   }
            }
      } 
}

function print_ranges(line){

  m = split(line, ranges, ",")
      for(i=1;i<=m; ++i){
              n = split(ranges[i],output," ")
              if (n > 1){
                    print output[1] " " output[2] " " output[3]
              } else if (n == 1 && output[1] ~ /^[0-9]/) {
                    print output[1]  " THRU " output[1]
              }
              #####print n " - " ranges[i]
      }
}
