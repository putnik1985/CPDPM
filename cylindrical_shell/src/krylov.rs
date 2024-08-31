pub fn K1(x: f64) -> f64 {
   x.cosh() * x.cos()
}

pub fn K2(x: f64) -> f64 {
   0.5 * (x.cosh() * x.sin() + x.sinh() * x.cos())
}

pub fn K3(x: f64) -> f64 {
   0.5 * x.sinh() * x.sin()
}

pub fn K4(x: f64) -> f64 {
   0.25 * (x.cosh() * x.sin() - x.sinh() * x.cos())
}

pub fn disp(s: f64, beta: f64) -> [f64; cylindrical_shell::problem_size]{
	[K1(beta*s), K2(beta*s), K3(beta*s), K4(beta*s)]
}

pub fn angle(s: f64, beta: f64) -> [f64; cylindrical_shell::problem_size]{
	[-4. * beta * K4(beta*s),
	       beta * K1(beta*s),
		   beta * K2(beta*s),
		   beta * K3(beta*s)]
}

pub fn moment(s: f64, beta: f64, D: f64) -> [f64; cylindrical_shell::problem_size] {
	[ D * 4. * beta * beta * K3(beta*s),
	  D * 4. * beta * beta * K4(beta*s),
	 -D * beta * beta * K1(beta*s),
	 -D * beta * beta * K2(beta*s)]
}

pub fn shear(s: f64, beta:f64, D:f64) -> [f64; cylindrical_shell::problem_size] {
	[ D * 4. * beta * beta * beta * K2(beta*s),
	  D * 4. * beta * beta * beta * K3(beta*s),
	  D * 4. * beta * beta * beta * K4(beta*s),
	 -D * 4. * beta * beta * beta * K1(beta*s)]
}

pub fn phi(s: f64, A: f64, B: f64, C:f64, D:f64) -> f64 {
	A * s * s * s + B * s * s + C * s + D 
}

pub fn dphi(s: f64, A: f64, B: f64, C:f64, D:f64) -> f64 {
	3. * A * s * s + 2. * B * s + C  
}

pub fn ddphi(s: f64, A: f64, B: f64, C:f64, D:f64) -> f64 {
	6. * A * s + 2. * B   
}

pub fn dddphi(s: f64, A: f64, B: f64, C:f64, D:f64) -> f64 {
	6. * A   
}

pub fn dot_prod(a:[f64;cylindrical_shell::problem_size], b:[f64;cylindrical_shell::problem_size]) ->f64 {
	let mut i: usize = 0;
    let mut s: f64 = 0.0;
	
	for i in 0..cylindrical_shell::problem_size {
		s+= a[i] * b[i];
	}
	s
}