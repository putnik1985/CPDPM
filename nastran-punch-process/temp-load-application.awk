BEGIN{
      if (ARGC < 3){
	       print "usage: awk -f temp-load-application.awk file=input.txt groups_file=input.dat";
	       exit;
       }

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	 file  = data["file"];
	 groups_file = data["groups_file"];
	 print "$Input Files:", filesfile, groups_file;
	 
	       while(getline < file > 0){
		         ###print $0;
				 split($0, words, ",");
				 
				 if (words[1] ~ /_id/)
				     tid = words[2];
					 
				 if (words[1] ~ /_group/){
				     #####print "groups-", words[2], words[3];
					 ###print length(words[2]);
                     group[words[2]] = words[2];
                      temp[words[2]] = words[3];
                 }						
		   }
		   
		   ##print tid;
		   ##for(i=1; i<=record; ++i)
		   ##    print group[i], temp[i];
		   
		       group_name = group[1];
			   ###print group_name;
		       while (getline < groups_file > 0){
                  if ($0 ~ /Group \(nodes\)/){
				      print "$Group:", $0;
                      split($0, line, ":");
					  raw_name = line[3];
                      keyword = substr(raw_name, 2); ## remove leading space
					    n = split(keyword,a,"");
						word = a[1];
						for(i=2;i<=n; ++i){
						    ####print i,"-->",a[i];
							if (a[i] ~ /[a-zA-Z 0-9()\/-]/) word = word a[i]; ##concatenate only letters and space between
							}
							####print "word=", word
                      temperature = temp[word]; 
					  #####print length(word), length(group_name);
					  while (getline < groups_file > 0 && $0 !~ /\$\*/){
					         ######print "$Line:", $0;
					         if ($0 ~ /=/){ 
							     n = split($0, line1, "=");
								 if (line1[2] ~ /,/)
								     n = split(line1[2],line,",");
								 else { 
								     n=2;
                                     line[1] = line1[2];									 
                                 }							 
							 }
							 else
                                 n = split($0, line, ",");
                             								 
                            for(i=1; i<n; ++i){
                                ##print "$check: ",line[i];
								num = split(line[i], grids," ");
                                ##print num; 
									 
								if (num == 1)
								    print "TEMP" "," tid "," grids[1] "," temperature ",";
									
									
								if (num == 3){
								   ###print grids[1], grids[2], grids[3];
								    start_grid = grids[1];
									end_grid = grids[3]
									for(j = start_grid; j<= end_grid; ++j){
								        print "TEMP" "," tid "," j "," temperature ",";
									}
                                }									
							}	
                             							
					  }
					  
				  }
               }
}

function max(a,b){
	if (a > b)
            return a;
	else 
	    return b;
}

function calculate_sf(f, fnotch){
 if (f <= fnotch)
     return 1.; 
 else
     return fnotch / f;
}

function min(a,b){
	if (a > b)
            return b;
	else 
	    return a;
}

