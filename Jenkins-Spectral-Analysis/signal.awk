BEGIN{
     pi = 3.14159
     delta = 0.0001
	 print "Delta", "N"
	 print delta, 1001
	 print "cos"
     for(i=0;i<=1000;++i)
         print sin(2*pi*12.*i*delta) * cos(2*pi*24.*i*delta)
}
