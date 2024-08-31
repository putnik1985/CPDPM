pub fn gauss_solve(a:&mut[[f64; cylindrical_shell::problem_size]; cylindrical_shell::problem_size], b: &mut[f64; cylindrical_shell::problem_size]) -> [f64; cylindrical_shell::problem_size] {
	let mut x: [f64; cylindrical_shell::problem_size] = [0., 0., 0., 0.];
	let mut factor: f64;
	let mut i: usize;
	let mut j: usize;
	let mut k: usize;
	
	let n: usize = b.len();
	
	for i in 0..n {
		for j in (i+1)..n {
			factor = -a[j][i] / a[i][i];
			for k in i..n {
				a[j][k] += factor * a[i][k];
			}
		b[j] += factor * b[i];
		}
	}
	
	k = n - 1;
	while k>=0 {
		let mut s: f64 = 0.;
		for j in k+1..n {
			s+=a[k][j] * x[j];
		}
		x[k] = (b[k] - s) / a[k][k];
	    //println!("{}",k);
		if k>0 {
			k-=1;
		} else { break; }
	}
	x
}
