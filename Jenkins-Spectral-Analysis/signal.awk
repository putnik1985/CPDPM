BEGIN{
     pi = 3.14159
     delta = 0.0001
	 print "Delta", "N", "NF"
	 print delta, 1001, 1000
	 print "cos"
     for(i=0;i<=1000;++i)
         print cos(2*pi*24.*i*delta) + sin(2*pi*56.*i*delta)*sin(2*pi*458.*i*delta)
}
