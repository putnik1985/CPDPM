BEGIN{ 
	
	if (ARGC < 2){
		print "usage awk -f qs-element-stress.awk files=elements.dat";
		exit;
	}

	for(i=1; i <= ARGC; i++){
	     input = ARGV[i];
	     split(input,a,"=");
	     ####print a[1], a[2]
	     data[a[1]] = a[2];
        }

	file  = data["files"];

	######print "Elements To Work With"
	while(getline < file > 0){
	  list[++nlist] = "../" $1
	  print "move " list[nlist] " ..."
	  system("mv " list[nlist] " ./")
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