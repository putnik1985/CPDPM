BEGIN { FS=","; pi = 3.14159;}

$1 ~ "_element" { 
                  current_elem += 1;
                  x1 = $2;
                  x2 = $3;
                   D = $4;
                   L = abs(x2-x1);
                   J = pi * D * D * D * D / 64.;
                   elem_length[current_elem] = L;
                   elem_J[current_elem] = J;
                   node[current_elem] = x1;
                   node[current_elem+1] = x2;
                 }

$1 ~ "_E" { E = $2 ; }
$1 ~ "_Nu" { Nu = $2; }
$1 ~ "_Su" { SU = $2; }
$1 ~ "_Sy" { SY = $2; }

$1 ~ "_fillet" {
               current_fillet += 1;
               fillet_x[current_fillet] = $2;
               fillet_rad[current_fillet] = $3;
               }

$1 ~ "_hole" {
              current_hole += 1;
              hole_x[current_hole] = $2;
              hole_d[current_hole] = $3;
             }

$1 ~ "_force" {
              current_force += 1
              force_x[current_force] = $2;
              force_mean[current_force] = $3;
              force_ampl[current_force] = $4;
              }

$1 ~ "_moment" {
               current_moment += 1;
               moment_x[current_moment] = $2;
               moment_mean[current_moment] = $3;
               moment_ampl[current_moment] = $4;
               }

$1 ~ "_u" {
              current_u += 1;
              u_x[current_u] = $2;
          }

$1 ~ "_angle" {
              current_angle += 1;
              angle_x[current_angle] = $2;
              }

$1 ~ "_Kr" {
             current_kr += 1;
             kr_x[current_kr] = $2;
             kr_s[current_kr] = $3;
           }

$1 ~ "_Ka" {
             current_ka += 1;
             ka_x[current_ka] = $2;
             ka_s[current_ka] = $3;
           }

END {
      print current_elem > "Elements.dat"
      for(i=1; i<=current_elem; i++)
       printf("%12d%12.4f%12.2E\n", i, elem_length[i], E * elem_J[i]) >> "Elements.dat"

      print current_elem + 1 > "Nodes.dat"
      for(i=1; i<=current_elem+1; i++)
       printf("%12d%12.4f\n", i, node[i]) >> "Nodes.dat"

      print current_force + current_moment > "Loads.dat"
      for(i=1; i<=current_force; i++){
       x = force_x[i];
       n = find_node(x);
       printf("%12d%12.2f%12.2f\n", 2 * n - 1, force_mean[i], force_ampl[i]) >> "Loads.dat"
      }

      for(i=1; i<=current_moment; i++){
       x = moment_x[i];
       n = find_node(x);
       printf("%12d%12.2f%12.2f\n", 2 * n, moment_mean[i], moment_ampl[i]) >> "Loads.dat"
      }

      print current_u  + current_angle > "Restraints.dat"
      for(i=1; i<=current_u; i++){
         x = u_x[i];
         n = find_node(x);
         printf("%12d\n",2 * n - 1) >> "Restraints.dat";
      }

      for(i=1; i<=current_angle; i++){
         x = angle_x[i];
         n = find_node(x);
         printf("%12d\n",2 * n) >> "Restraints.dat";
      }

      print current_fillet > "Fillets.dat"
      for(i=1; i<=current_fillet; i++){
         x = fillet_x[i];
         n = find_node(x);
         printf("%12d%12.2f\n",n, fillet_rad[i]) >> "Fillets.dat";
      }

      print current_hole > "Holes.dat"
      for(i=1; i<=current_hole; i++){
         x = hole_x[i];
         n = find_node(x);
         printf("%12d%12.2f\n",n, hole_d[i]) >> "Holes.dat";
      }
}

function abs(x){
 if (x > 0.) {
              return x;
 } else {
              return -x;
 }
}

function find_node(x){
 for(j=1; j<= current_elem + 1; j++) 
  if ( node[j] == x ) {
                      return j;
  }
  return -1;
}
