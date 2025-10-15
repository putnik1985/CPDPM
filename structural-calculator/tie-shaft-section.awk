BEGIN{
      pi = 3.14159
      K = 0.15 ### nut factor

      yield["cres-15-5ph"] = 165000.
      ultim["cres-15-5ph"] = 175000.
      shear["cres-15-5ph"] = 130000.
          
 
      for(i=1; i<=ARGC; ++i){
         n = split(ARGV[i],out, "=")
         data[out[1]] = out[2]
      }

          load = data["load"]
      material = data["material"]
           SFy = data["SFy"]
           SFu = data["SFu"]
          area = data["A"]
             J = data["J"]
             D = data["D"]
      
      stress = load / area
      mos_yield = yield[material] / (SFy * stress) - 1. 
      mos_ultimate = ultim[material] / (SFu * stress) - 1. 

      Torque = K * load * D
      shear_stress = (Torque / J) * (D / 2)
      mos_shear = shear[material] / (SFu * shear_stress) - 1.
      
      printf("%12s,%12s,%12s\n", "Yield", "Ultimate","Shear")
      printf("%12.2f,%12.2f,%12.2f\n", mos_yield, mos_ultimate, mos_shear)
}
