BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file CTETRA4
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
        type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
        type["cquad4"] = 33
        type["ctria3"] = 74

	if (ARGC < 3){
		print "usage awk -f random-satk-vm.awk dia=0.625 file=inp.txt elements=elements.dat";
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

    ###Ref. SPAR-SS-1604 Rev B_10, page 96
    meters = 0.0254	## convert in to meters
	t1 = 0.6 * meters 
	t2 = 0.567 * meters 
	dia = 0.625 * meters
	gap= 0.096 * meters
	Pumin = 37800. * 4.44822 ## convert to N
	gamma = 0.8
	b = 0.5 * t1 + gap + gamma * 0.25 * t2
    ###Ref. SPAR-SS-1604 Rev B_10, page 96
	
	while (readline()){
	       ##print $0
		       fx = $7
			   fy = $8
			   fz = $9
			   mx = $10
			   my = $11
			   mz = $12
			   
						 shear_force = sqrt(fy * fy + fz * fz)
						 bending = shear_force * b / 2
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
