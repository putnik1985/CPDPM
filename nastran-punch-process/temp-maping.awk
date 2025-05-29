BEGIN{
     if (ARGC < 3) {
        print "usage: awk -f split.awk grids=file1 temp=file2 id=temp-case"
        exit
      }


      for(i=1; i<=ARGC; ++i){
          n = split(ARGV[i], out,"=")
          data[out[1]] = out[2]
      }
	  
      grids = data["grids"] ## contains temperatures to map from the temp file
       temp = data["temp"]
	   id = data["id"]

      

      while (getline < temp > 0) {
	     if ($1 ~ /^TEMP/ && $2 == id) {
		                      temperature[$3] = $4
	     }						   
      }
      
      while (getline < grids > 0){
         gr = $1
		 print "TEMP" "," id "," gr "," temperature[gr]
      }
	  
} 


func find(gr){
   for(i=1; i<=record; ++i){
       if (gr == grid_number[i]) 
              return gr
   }
return 0
}
