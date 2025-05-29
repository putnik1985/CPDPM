BEGIN{
     if (ARGC < 3) {
        print "usage: awk -f split.awk grids=file1 temp=file2"
        exit
      }


      for(i=1; i<=ARGC; ++i){
          n = split(ARGV[i], out,"=")
          data[out[1]] = out[2]
      }
	  
      grids = data["grids"]
       temp = data["temp"]

      while (getline < grids > 0) {
	     set1[$1] = 0
		 union[++record] = $1
      }

      while (getline < temp > 0){
         set1[$1] += 1
      }
	  
	  for(i=1;i<=record;++i) {
		  gr = union[i]
	      location = set1[gr]

	      if ( location > 0) { 
		      print gr > "intersection.dat"
	      } else {
		      print gr > "difference.dat"		    
          }
      }
} 


func find(gr){
   for(i=1; i<=record; ++i){
       if (gr == grid_number[i]) 
              return gr
   }
return 0
}
