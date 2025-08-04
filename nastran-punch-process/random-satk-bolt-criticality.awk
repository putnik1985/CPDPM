BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file CTETRA4
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
        type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
        type["cquad4"] = 33
        type["ctria3"] = 74

	if (ARGC < 4){
		print "usage awk -f random-satk-vm.awk dia=0.625 file=inp.txt elements=elements.dat ultimate=ult";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["file"];
	dia  = data["dia"];
	ultimate = data["ultimate"]
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
	FS = ","
	pi = 3.14159
	A = pi * dia * dia / 4
	Jd = pi * dia * dia * dia * dia / 64
	ymax = dia / 2
	
	while (readline()){
	       ##print $0
		       fx = $7
			   fy = $8
			   fz = $9
			   mx = $10
			   my = $11
			   mz = $12
			   
						 shear_force = sqrt(fy * fy + fz * fz)
						 bending = sqrt(my * my + mz * mz)
						 sx = bending * ymax / Jd + abs(fx) / A
			             sxy = shear_force / A
						 vm = sqrt(sx*sx + 3 * sxy * sxy)
			   #####print $2, fx, fy, fz, mx, my, mz, vm
			   id = sprintf("%d",$2)
               stress[id] = vm
	}

                                          for(i=1; i<=ngroup; ++i){
                                                 id =      group[i]
                                                 num = sprintf("%d",id)
												 
                                                 vm =   stress[num]
												 ###print num, vm
					         if (vm > vm_max){
						     vm_max = vm
					         }
                                          }
                                          
                                          printf("%.2f\%\n", vm_max * 100. / ultimate)
						  
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
