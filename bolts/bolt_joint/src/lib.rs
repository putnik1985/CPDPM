use std::error::Error;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;


pub struct Config {
    pub file_path: String,
}


impl Config {

     pub  fn build(args: &[String]) -> Result<Config, &'static str> {
          if args.len() < 2 {
             return Err("usage: bolt_joint inputfile");
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
