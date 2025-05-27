BEGIN { 
	for(i=1;i<=ARGC;++i){
		n = split(ARGV[i], out, "=")
		data[out[1]] = out[2]
	}
     next_element =  data["element"]
    next_property = data["property"]
         material = data["material"]
		   radius =   data["radius"]
 

    ###########print next_element, next_property, material, radius
}
    		 
{     
      for(i=1;i<=NF;++i)
	      grids[i] = $i
	  
	  for(i=2;i<=NF;++i)
	      printf("CBAR,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n", ++next_element, next_property, grids[1], grids[i], 1., 0., 0.)

      
}

END{
      printf("PBARL,%d,%d,MSCBML0,ROD,,,,,+\n+,%.6f,0.0,\n", next_property, material, radius)
	  printf("MAT1,%d,6.83E10,2.57E10,.33,0.0,2.28E-5,20.0,0.0,\n",material)

}