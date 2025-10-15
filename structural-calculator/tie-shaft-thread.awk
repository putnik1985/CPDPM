BEGIN{
      pi = 3.14159
      K = 0.15 ### nut factor

      yield["cres-15-5ph"] = 165000.
      ultim["cres-15-5ph"] = 175000.
      shear["cres-15-5ph"] = 130000.
            As["1-12-unf"] = 0.663
          
 
      for(i=1; i<=ARGC; ++i){
         n = split(ARGV[i],out, "=")
         data[out[1]] = out[2]
      }

          load = data["load"]
      material = data["material"]
          size = data["size"]
           SFy = data["SFy"]
           SFu = data["SFu"]

      
      stress = load / As[size]
      mos_yield = yield[material] / (SFy * stress) - 1. 
      mos_ultimate = ultim[material] / (SFu * stress) - 1. 

      D = sqrt(4.*As[size] / pi)
      Jr = pi * D * D * D * D / 32.
      Torque = K * load * D
      shear_stress = (Torque / Jr) * (D / 2)
      mos_shear = shear[material] / (SFu * shear_stress) - 1.
      
      printf("%12s,%12s,%12s\n", "Yield", "Ultimate","Shear")
      printf("%12.2f,%12.2f,%12.2f\n", mos_yield, mos_ultimate, mos_shear)
}
