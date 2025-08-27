BEGIN{

      FS=",";
      if (ARGC< 3) {
                   print "usage: awk -f define_rbe2_connections file=input.dat elements=rbe2list"
                   exit
      }

      for(i=1;i<=ARGC;++i){
          n=split(ARGV[i],out,"=")
          ####print ARGV[i] out[1] out[2]
          data[out[1]] = out[2]
      }

      ######print "$$$$$$$$$$input file: " data["file"]
      file = data["file"]
	  elements = data["elements"]
	  while (getline < elements > 0){
	         group[++ng] = $1
	  }
	  ##for(i=1;i<=ng;++i)
      ##    print group[i]
		  
      while(getline < file > 0){
            if ($0 ~ /^RBE2/) {
			    element = $2
                rbe2[element] = $3
                for(field=5; field<=NF;++field) ## for rbe2 element start from field #5
                    if ($field ~ /[0-9]/) rbe2[element] = rbe2[element] "," $field
					
                while ($NF ~ /+/){
                  readline()
				  ###############print $0
                  for(field=1; field<=NF; ++field)
                      if ($field ~ /^[0-9]+$/) rbe2[element] = rbe2[element] "," $field				  
                }
            }
      }

	  for(i=1;i<=ng;++i){
          n = group[i]
		  print rbe2[n]
	  }

}

function readline(){
  if (getline < file > 0)
      return 0;
  else {
       printf("can not read file:%s\n", file);
	   exit;
	   }
}
