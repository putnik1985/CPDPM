BEGIN { FS=","; pi = 3.14159; conv_to_m = 0.001; conv_to_Pa = 1000000000.; MPa_to_Pa = 1000000.;}

$1 ~ "_element" { 
                  current_elem += 1;
                  x1 = $2;
                  x2 = $3;
                   a = conv_to_m * $4;
                   b = conv_to_m * $5;
                   L = conv_to_m * abs(x2-x1);
                   elem_length[current_elem] = L;
                   elem_a[current_elem] = a;
                   elem_b[current_elem] = b;
                   node[current_elem] = x1;
                   node[current_elem+1] = x2;
                 }

$1 ~ "_force" {
              current_force += 1
              force_x[current_force] = $2;
              force[current_force] = $3;
              }

$1 ~ "_moment" {
               current_moment += 1;
               moment_x[current_moment] = $2;
               moment[current_moment] = $3;
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
      
      for(i=1; i<=current_elem; i++){
       printf("%12d%12.4f%12.4f%12.4f\n", i, elem_length[i], elem_a[i], elem_b[i]) >> "Elements.dat"
      }

      print current_elem + 1 > "Nodes.dat"
      for(i=1; i<=current_elem+1; i++)
       printf("%12d%12.4f\n", i, node[i]) >> "Nodes.dat"

      print current_force + current_moment > "Loads.dat"
      for(i=1; i<=current_force; i++){
       x = force_x[i];
       n = find_node(x);
       printf("%12d%12.2f\n", 2 * n - 1, force[i]) >> "Loads.dat"
      }

      for(i=1; i<=current_moment; i++){
       x = moment_x[i];
       n = find_node(x);
       printf("%12d%12.2f\n", 2 * n, moment[i]) >> "Loads.dat"
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
