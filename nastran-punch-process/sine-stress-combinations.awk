BEGIN{ 
	type["ctetra"] = 39; ## nastran nx element type from .pch file
	type["cquadr"] = 228; ## nastran nx element type for from .pch file
    type["chexa"] = 67; ## nastran nx element type from .pch file CHEXA8
    type["cquad4"] = 33
    type["ctria3"] = 74
	
	if (ARGC < 7){
		print "usage awk -f sine-stress-combinations.awk stress=list_of_all_stresses components=list_of_components_results Fy=44. Fu=44. FSy=1.25 FSu=2.0";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	stress  = data["stress"];
	Fy  = data["Fy"];
	Fu  = data["Fu"];

	FSy  = data["FSy"];
	FSu  = data["FSu"];

	components = data["components"]
	######print "Elements To Work With"
	while(getline < components > 0){
	  n = split($0, out, ".")
	  component[++ncomponent] = out[1]
	}
	
	#for(k=1;k<=ncomponent;++k)
	#    print component[k]
	
	n = split(stress, out, "/")
    (n==1) ? folder = "." : folder = out[1]
	###print folder
    while (getline < stress > 0){
      n = split($0, out, ".")
      ######################print $0, out[1]
	  all_components[out[1]] = all_components[out[1]] folder "/" $0 ","
	  ######################print all_components[out[1]]
    }	  


	for(k=1;k<=ncomponent;++k){
	    comp = component[k]
		n = split(all_components[comp], files, ",")

		vm_max = 0.;
        freq_max = 0.;
        id_max = 0;		
		for(i=1; i<n; ++i){
		    ##print files[i]
			while (getline < files[i] > 0){
			       split($0, values, ",")
				   
				   if (values[3] > vm_max){
				       vm_max = values[3]
					   freq_max = values[2]
					   id_max = values[1]
				   }
			}
		}
	
 
	if (vm_max > 0) {
        output = comp ".MoS"
	    print output
	    print "Input:" > output
	    printf("Fy =%f, Fu =%f, FSy = %f, FSu = %f\n", Fy, Fu, FSy, FSu) >> output	
        printf("\n\n%s,%s,%s,%s,%s,\n", "Element","Frequency", "VM", "MOS Yield", "MOS Ultimate") >> output
	    yield = Fy * 1000000. / (FSy * vm_max) - 1
	    ultimate = Fu * 1000000. / (FSu * vm_max) - 1
        printf("%d,%.2f,%.2f,%.2f,%.2f\n", id_max, freq_max, vm_max / 1000000. , yield, ultimate) >> output 
    }
	
	}
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