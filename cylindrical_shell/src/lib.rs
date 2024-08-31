use std::error::Error;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

pub const MIN_WORDS: i32 = 2;
pub const UNREAL_VALUE: f64 = 2000000000.;
pub const PROBLEM_DIMENSION: usize = 4;
pub const problem_size: usize = 4;


pub struct Config {
    pub file_path: String,
}


impl Config {

     pub  fn build(args: &[String]) -> Result<Config, &'static str> {
          if args.len() < 2 {
             return Err("usage: cylindrical_shell inputfile");
         }

         let file_path = args[1].clone();
         Ok(Config{file_path})
     }
}

pub fn run(config: Config) ->Result<(), Box<dyn Error>> {
    println!("read file: {}", config.file_path);
    Ok(())
}

pub fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>> where P: AsRef<Path>, {
     let file = File::open(filename)?;
     Ok(io::BufReader::new(file).lines())
}

pub struct matrix {
	pub m: [[f64; problem_size];problem_size],
}

pub struct vector {
	pub v: [f64;problem_size],
}

pub trait output {
	fn print(&self) -> i32;
}

impl output for matrix {
   fn print(&self) -> i32 {
    let mut i: i32;
    let mut j: i32;
        for i in 0..problem_size {
          for j in 0..problem_size {
	    	print!("{:12.3e}",self.m[i][j]);
          }
	       println!();
        }	
	0
   }
}

impl output for vector {
   fn print(&self) -> i32 {
     let mut i: i32;
     for i in 0..problem_size {
	   println!("{:12.3e}",self.v[i]);
     }	
	 0
   }
}

pub fn print_matrix(a: [[f64; problem_size];problem_size] ) -> i32 {
   let mut i: i32;
   let mut j: i32;
   
   for i in 0..problem_size {
       for j in 0..problem_size {
		print!("{:12.3}",a[i][j]);
       }
	   println!();
   }	
	0
}

pub fn print_vector(b: [f64;problem_size] ) -> i32 {
   let mut i: i32;
   for i in 0..problem_size {
	   println!("{:12.3}",b[i]);
   }	
	0
}