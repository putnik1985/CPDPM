BEGIN{

      FS=",";
      if (ARGC< 2) {
                   print "usage: awk -f add_cte_rbe2 file=input.dat"
                   exit
      }

      for(i=1;i<=ARGC;++i){
          n=split(ARGV[i],out,"=")
          ####print ARGV[i] out[1] out[2]
          data[out[1]] = out[2]
      }

      ######print "$$$$$$$$$$input file: " data["file"]
      file = data["file"]
      while(getline < file > 0){
            if ($0 ~ /^RBE2/) {
                rbe2[++record] = $2 
                while ($NF ~ /+/){
                  readline() 
                }
                end[record] = $NF
                if ($NF >= 1) 
                    skiped_elements[++skip] = rbe2[record]
            }
      }

      for(i=1;i<=record;++i)
          print rbe2[i] "," end[i]

      print ""
      print "Elements with skiped CTE:"
      for(i=1; i<=skip; ++i)
          print skiped_elements[i]

}

function readline(){
  if (getline < file > 0)
      return 0;
  else {
       printf("can not read file:%s\n", file);
	   exit;
	   }
}
