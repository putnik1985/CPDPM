use crate::krylov::*;
pub mod krylov;

use crate::numeric::*;
pub mod numeric;

use std::env;
use std::process;

use cylindrical_shell::{Config, matrix, vector, output};
use std::collections::HashMap;

///extern crate ndarray;
use num_traits::Pow;

//use ndarray::prelude::*;
//use ndarray_linalg::solve;



fn main() {
       
    let args: Vec<String> = env::args().collect();
    //dbg!(args);
    let config = Config::build(&args).unwrap_or_else(|err| { println!("Problem parsing arguments: {err}");
                                                             process::exit(1);
                                                           }); 
   let mut  E: f64; // Pa
   let mut  h: f64; //m 
   let mut  L: f64; //m
   let mut L0: f64; //m
   let mut  R: f64; //m
   let mut density: f64; //m

   let mut m0: f64 = cylindrical_shell::UNREAL_VALUE;
   let mut ml: f64 = cylindrical_shell::UNREAL_VALUE;

   let mut q0: f64 = cylindrical_shell::UNREAL_VALUE;
   let mut ql: f64 = cylindrical_shell::UNREAL_VALUE;

   let mut u0: f64 = cylindrical_shell::UNREAL_VALUE;
   let mut ul: f64 = cylindrical_shell::UNREAL_VALUE;

   let mut a0: f64 = cylindrical_shell::UNREAL_VALUE;
   let mut al: f64 = cylindrical_shell::UNREAL_VALUE;
   
   let  A: f64;
   let  B: f64;
   let  C: f64;
   let D1: f64;
   
   
   let mut data = HashMap::new(); // input data from the file

   if let Ok(lines) = cylindrical_shell::read_lines(config.file_path) {

      for line in lines.flatten() {
          //println!("-->>>{}", line);
          let words: Vec<&str> = line.split(',').collect();
		      if (words.len() > cylindrical_shell::MIN_WORDS.try_into().unwrap()) {
                  data.insert(String::from(words[0]),String::from(words[1]));
			  }
          }
      }
   
//   for (key, value) in &data {
//       println!("{key}: {value}");
//   } 
    
    E = data.get(&String::from("_E")).expect("not a E string").parse::<f64>().unwrap();
    h = data.get(&String::from("_h")).expect("not a dh string").parse::<f64>().unwrap();
    L = data.get(&String::from("_L")).expect("not a d string").parse::<f64>().unwrap();
   L0 = data.get(&String::from("_L0")).expect("not a L string").parse::<f64>().unwrap();
    R = data.get(&String::from("_r")).expect("not a R string").parse::<f64>().unwrap();
    A = data.get(&String::from("_A")).expect("not a A string").parse::<f64>().unwrap();
    B = data.get(&String::from("_B")).expect("not a B string").parse::<f64>().unwrap();
    C = data.get(&String::from("_C")).expect("not a C string").parse::<f64>().unwrap();
   D1 = data.get(&String::from("_D")).expect("not a D string").parse::<f64>().unwrap();	

   u0 = data.get(&String::from("_u0")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap();	
   ul = data.get(&String::from("_ul")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap();

   a0 = data.get(&String::from("_a0")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap();
   al = data.get(&String::from("_al")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap();

   q0 = data.get(&String::from("_q0")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap();
   ql = data.get(&String::from("_ql")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap(); 

   m0 = data.get(&String::from("_m0")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap();
   ml = data.get(&String::from("_ml")).unwrap_or(&String::from(cylindrical_shell::UNREAL_VALUE.to_string())).parse::<f64>().unwrap();

//   println!("Input data:\n");
//   println!("E,GPa:{E:12.1E}\n  h,m:{h:12.3}\n  L,m:{L:12.3}\nL0, m:{L0:12.3}\n  R,m:{R:12.3}");
//   println!("   u0:{u0:12.3 }\n   ul:{ul:12.3}\n   a0:{a0:12.3}\n   al:{al:12.3}\n   m0:{m0:12.3}\n   ml:{ml:12.3}\n   q0:{q0:12.3}\n   ql:{ql:12.3}\n");
   ////println!("{} {} {} {}",A, B, C, D1);
   
   let nu: f64 = 0.3;
   let mut D: f64 = E * h * h * h / (12. * (1. - nu * nu));
   let beta:f64 = Pow::pow(E * h / ( 4. * D * R * R ), 0.25f64);
//   println!("beta: {:12.2}",beta);
   
   
   // generate equations of the problem
   let mut a = matrix {
	                     m: [[0.,0.,0.,0.],
                             [0.,0.,0.,0.],
                             [0.,0.,0.,0.],
				             [0.,0.,0.,0.]],
   };
   let mut b = vector {
                         v:[0.,0.,0.,0.],
   };
   
   let mut p = vector {
	                      v:[0.,0.,0.,0.],
   };
   
   let mut current: usize = 0;

   if u0 < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = disp(0., beta);
	   b.v[current] = phi(0., R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);
       p.v[current] = u0 - b.v[current];	   
	   current+=1;
   }
   
   if ul < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = disp(L, beta);
	   b.v[current] =  phi(L, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);	   
       p.v[current] = ul - b.v[current];
	   current+=1;
   }   

   if a0 < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = angle(0., beta);
	   b.v[current] = dphi(0., R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);	   
       p.v[current] = a0 - b.v[current];
	   current+=1;
   }
   
   if al < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = angle(L, beta);
	   b.v[current] =  dphi(L, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);	   
       p.v[current] = al - b.v[current];
	   current+=1;
   }   

   if m0 < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = moment(0., beta, D);
	   b.v[current] = ddphi(0., R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);	   
       p.v[current] = m0 - b.v[current];
	   current+=1;
   }
   
   if ml < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = moment(L, beta, D);
	   b.v[current] = ddphi(L, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);	   
       p.v[current] = ml - b.v[current];
	   current+=1;
   }   

   if q0 < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = shear(0., beta, D);
	   b.v[current] = dddphi(0., R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);	   
       p.v[current] = q0 - b.v[current];
	   current+=1;
   }
   
   if ql < cylindrical_shell::UNREAL_VALUE {
	   a.m[current] = shear(L, beta, D);
	   b.v[current] = dddphi(L, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);	   
       p.v[current] = ql - b.v[current];
	   current+=1;
   }   

//   println!();
//   println!("matrix A of the equations Ac + b = 0:");
//   a.print(); 

//   println!();
//   println!("vector b of the equations Ac + b = 0:");
//   p.print();
   
   let mut solution = vector {
	                      v:[0.,0.,0.,0.],
   };

   solution.v = gauss_solve(&mut a.m, &mut p.v);

//   println!();
//   println!("Solution of the equations Ac + b = 0:");
//   solution.print();
   
   let steps: usize = 1000;
   let ds: f64 = L / steps as f64;
   let mut s0: f64 = 0.0;
  println!("{:12},{:12},{:12},{:12},{:12},","s m","u mm","Angle rad","Q N/m","M1 N.m/m"); 
   while s0 <= L {
	   let mut u: f64 = dot_prod(solution.v, disp(s0, beta));
       u += phi(s0, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);

	   let mut ang: f64 = dot_prod(solution.v, angle(s0, beta));
       ang += dphi(s0, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);

	   let mut m1: f64 = dot_prod(solution.v, moment(s0, beta, D));
       m1 += ddphi(s0, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);

	   let mut q1: f64 = dot_prod(solution.v, shear(s0, beta, D));
       q1 += dddphi(s0, R*R/(E*h) * A, R*R/(E*h) * B, R*R/(E*h) * C, R*R/(E*h) * D1);
	   
       println!("{:12.4},{:12.8},{:12.8},{:12.2},{:12.2},",s0,u * 1000.,ang,q1,m1); // m convert to mm
       s0+=ds;
   }

//   let mut m1: [[f64;4];4] =  [[2.,1.,-5.,1.],
//                             [1.,-3.,0.,-6.],
//                             [0.,2.,-1.,2.],
//				             [1.,4.,-7.,6.]];
//
//   let mut b1:[f64;4] = [8.,9.,-5.,0.];
//   solution.v = gauss_solve(&mut m1, &mut b1);
//   println!();
//   println!("Solution of the equations Ax = b:");
//   solution.print();

}
