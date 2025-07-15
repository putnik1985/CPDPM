BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file CTETRA4
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
        type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
        type["cquad4"] = 33
        type["ctria3"] = 74

	if (ARGC < 2){
		print "usage awk -f random-satk-vm.awk file=inp.txt elements=elements.dat";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	
	elements = data["elements"]
	while(getline < elements > 0){
	  group[++ngroup] = $1
	}

#	print "Elements Of The Group"
#	for(i=1; i<=ngroup; ++i)
#	    print group[i]
#
#	print ""
#	print ""
	
	while (readline()){
	       ##print $0
               stress[$1] = $NF
	}

                                          for(i=1; i<=ngroup; ++i){
                                                 id =      group[i]
                                                 num = sprintf("%d",id)
                                                 vm =   stress[num]
					         if (vm > vm_max){
						     vm_max = vm
					         }
                                          }
                                          print "Input assumed in Pa convert to ksi"
                                          printf("%.2f\n", vm_max * 1.45038E-7)
						  
}

function abs(x){
  if (x > 0) 
      return x
  else 
      return -x;
}

function readline(){
   err = getline < file;
   if (err < 0){
       print "can not read file: " file;
	   exit;
   } else 
       return err;
}

function max(a, b){
 if (a>b) 
     return a
 else 
     return b
}
