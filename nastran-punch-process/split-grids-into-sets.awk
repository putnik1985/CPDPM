BEGIN{

      FS=",";
      if (ARGC< 4) {
                   print "usage: awk -f split-grids-into-sets.awk file=grids_per_row.dat first=set1 second=set2"
                   exit
      }

      for(i=1;i<=ARGC;++i){
          n=split(ARGV[i],out,"=")
          data[out[1]] = out[2]
      }

      file = data["file"]
	  set1 = data["first"]
	  set2 = data["second"]

      while (getline < set1 > 0){
	         set_grids[$1] = set1 ## mark grids of the first set as 1
	  }
	  
      while (getline < set2 > 0){
	         set_grids[$1] = set2 ## mark grids of the second set as 2
	  }

      
      ####print file, set1, set2	  
      while (getline < file > 0){
	         ############print $0
			 line = $0 ## read the whole line which contains grid numbers to be split
			 n = split(line, numbers, ",")
			 
			 nset1 = 0
			 nset2 = 0
			 for(i=1;i<=n;++i){
			 
			     if (set_grids[numbers[i]] == set1) {
				         first[++nset1] = numbers[i]
				 }
				 
			     if (set_grids[numbers[i]] == set2) {
				         second[++nset2] = numbers[i]
				 } 

			 }
			 
			 printf("first set: %s\n", set1)
			 for(i=1;i<=nset1;++i)
			     printf("%d,",first[i])
			 printf("\n");
			 
			 printf("second set: %s\n", set2)
			 for(i=1;i<=nset2;++i)
			     printf("%d,",second[i])				 
             printf("\n"); 
			 
			 printf("\n")
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
