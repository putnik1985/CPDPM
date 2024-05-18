pub fn K1(x: f64) -> f64 {
   0.5 * (x.cosh() + x.cos())
}


pub fn K2(x: f64) -> f64 {
   0.5 * (x.sinh() + x.sin())
}


pub fn K3(x: f64) -> f64 {
   0.5 * (x.cosh() - x.cos())
}


pub fn K4(x: f64) -> f64 {
   0.5 * (x.sinh() - x.sin())
}


pub fn power(a: i32, n: u32) -> i32 {
   let mut i = 0;
   let mut pw = 1;
   while i < n {
    pw *= a;
     i += 1;
   } 
   pw
}

pub fn alpha_n(n: u32) -> f64{
    if n == 1 {
       4.73 // corresponds to the first non zero alpha for the free-free beam
    } else {
       std::f64::consts::PI / 2. * ( 2.0 * n as f64 + 1.0) // approximate solution of the cos(x) cosh(x) = 1
    }
}
