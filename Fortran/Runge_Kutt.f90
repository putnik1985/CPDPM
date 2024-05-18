subroutine funct(f,t,x,n)
real*4 t;
real*4 x,f;
dimension x(n),f(n);
integer n;


f(1) = ( (1.38e-23)*(373 + 100000 * t) * 0.0001 / (0.001 * x(2)) ) - 10;
f(2) = 0.0001 * x(1) ;


end subroutine ! end function f



subroutine Runge1(dt,nt,n,x0,comp,unit)

real*4 dt,f,x0,k1,k2,k3,k4;
integer nt, n, comp, unit;
dimension f(n),x0(n),k1(n),k2(n),k3(n),k4(n);

integer i;

	open(unit,file = 'Runge.dat')
	write(unit,100), 0.0, x0(comp)
100 format(f8.4,F7.3)



	do i = 1, nt

		call funct(k1,(i-1)*dt,x0,n);
		call funct(k2,(i-1)*dt + dt * 0.5, x0 + 0.5 * k1 * dt, n);
		call funct(k3,(i-1)*dt + dt * 0.5, x0 + 0.5 * k2 * dt, n);
		call funct(k4,(i-1)*dt + dt, x0 + k3 * dt, n);

		x0 = x0 + (dt / 6.0) * (k1 + 2 * k2 + 2 * k3 + k4) ;

	write(unit,100), i*dt, x0(comp)
		
	enddo !end i 


close(unit);

end subroutine 