
use std::env;
use std::process;

use bolt_joint::Config;
use std::collections::HashMap;

fn main() {
       
    let args: Vec<String> = env::args().collect();
    //dbg!(args);
//    let config = Config::build(&args).unwrap_or_else(|err| { println!("Problem parsing arguments: {err}");
//                                                             process::exit(1);
//                                                           }); 

    let config = Config::build(&args).unwrap_or_else(|err| { println!("Problem parsing arguments: ");
                                                             process::exit(1);
                                                           });
   let GPa_to_MPa: f64 = 1000.;
   let mut E: f64 = 205.; //GPa
   let mut dh: f64 = 25.; //mm 
   let mut Lc: f64 = 120.; //mm
   let mut L : f64 = 128.; //mm
   let mut d: f64 = 24.; //mm
   let mut Ar: f64 = 352.; //mm2
   let mut Ac: f64 = 452.; //mm2

   let mut data = HashMap::new(); // input data from the file

   if let Ok(lines) = bolt_joint::read_lines(config.file_path) {

      for line in lines.flatten() {
          //println!("{}", line);
          let words: Vec<&str> = line.split(',').collect();
          data.insert(String::from(words[0]),String::from(words[1]));
      }

   }
   
//   for (key, value) in &data {
//       println!("{key}: {value}");
//   } 
    
   E = data.get(&String::from("_E")).expect("not a E string").parse::<f64>().unwrap();
   dh = data.get(&String::from("_dh")).expect("not a dh string").parse::<f64>().unwrap();
   d = data.get(&String::from("_d")).expect("not a d string").parse::<f64>().unwrap();

   Ar = data.get(&String::from("_Ar")).expect("not a Ar string").parse::<f64>().unwrap();
   Ac = data.get(&String::from("_Ac")).expect("not a Ac string").parse::<f64>().unwrap();

   L = data.get(&String::from("_L")).expect("not a L string").parse::<f64>().unwrap();
   Lc = data.get(&String::from("_Lc")).expect("not a Lc string").parse::<f64>().unwrap();
   println!("Input data:\n");
   // did not work for Linux for the latest version will work
   //println!(" E, GPa: {E:.1}\n dh, mm: {dh:.1}\n  d, mm: {d:.1}\n Ar, mm2: {Ar:.1}\n Ac, mm2: {Ac:.1}\n  L, mm: {L:.1}\n Lc, mm: {Lc:.1}");

   let Lr: f64 = L - Lc;
   let Kb: f64 = GPa_to_MPa * E * Ac * Ar / (Lr * Ac + Lc * Ar);
   println!("                bolt stiffness, N/mm: {0:.1E}",Kb);
   let pi: f64 = std::f64::consts::PI;
   
   let Kgm: f64 = 0.91 * GPa_to_MPa * E * dh / ((2.89 * L + 2.5 * dh)/(0.58 * L + 2.5 * dh)).ln();
   println!("bolted group members stiffness, N/mm: {0:.1E}",Kgm);   
}
