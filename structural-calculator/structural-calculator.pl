use strict;

use Math::Trig;
use Cwd qw(getcwd);

    print "\n";
###usage: perl structural-calculator.pl
         my $mmtoin = 0.0394;
		 my $intomm = 25.4;
		 
	     print "----------------------------------------------------\n";	
	     print "List of commands:\n";
             print "----------------------------------------------------\n";		 
		 print "circle,D       - output geometric properies of the circle\n";
		 print "rectangle,a,b  - output geometric properies of the rectangle\n";
		 print "mm2-to-in2,area - convert area in mm2 to area in in2\n";
		 print "mm4-to-in4,inertia - convert inertia in mm4 to inertia in in4\n";
                 print "stress-area,D,n    - output stress area of the treads D, n - threads per in\n";		 
                 print "bolt-joint,P,Kb,Kj,Preload  - output bolt and joint loads when apply P external when prelaoded with Preload force\n";		 
	     print "----------------------------------------------------\n";
      	     print "\n";
		 
         while(<STDIN>){
         my $line = $_;
		 chomp($line);
		 my @words = split/,/,$line;
		 ####print $words[0], $words[1];
		 print "\n";
         if ($line =~ /^bolt-joint/){
		 my $P = $words[1];
		 my $KB = $words[2];
		 my $KJ = $words[3];
		 my $Preload = $words[4];
		 my $boltload = $Preload + $P * (1. / (1. + $KJ/$KB));
		 my $jointload = $Preload - $P * (($KJ/$KB) / (1. + $KJ/$KB));
		 my $sepload = $Preload * (1. + $KJ/$KB) / ($KJ/$KB);
		 printf "%12s%12s%12s\n","Bolt Load", "Joint Load", "Separation Load";
		 printf "%12.2f%12.2f%12.2f\n", $boltload, $jointload, $sepload
	 }
         if ($line =~ /^stress-area/){
			 my $D = $words[1];
			 my $n = $words[2];
			 
			 my $area = pi / 4. * ($D - 0.9743 / $n )**2;			 
			 printf "%12s\n", "Area";
			 printf "%12.4f\n", $area;
		 }			 

		 
         if ($line =~ /^circle/){
			 my $D = $words[1];
			 
			 my $area = pi * $D**2 / 4.;
			 my $Jr = pi * $D**4 / 32.;
			 my $Jd = $Jr / 2.;
			 my $p = pi * $D;
			 
			 printf "%12s%12s%12s%12s\n", "Area", "Jr", "Jd", "Length";
			 printf "%12.4f%12.4f%12.4f%12.4f\n", $area, $Jr, $Jd, $p;
		 }			 

         if ($line =~ /^rectangle/){
			 my $a = $words[1];
			 my $b = $words[2];			 
			 
			 my $area = $a * $b;
			 
			 my $Jx = $a * $b * $b**2 / 12.;
			 my $Jy = $a * $b * $a**2 / 12.;			 
             my $Jr = $Jx + $Jy;
			 
			 my $p = 2. * ($a + $b);
			 
			 printf "%12s%12s%12s%12s%12s\n", "Area", "Jr", "Jx", "Jy", "Length";
			 printf "%12.4f%12.4f%12.4f%12.4f%12.4f\n", $area, $Jr, $Jx, $Jy, $p;
		 }

         if ($line =~ /^mm2-to-in2/) {
             my $area = $words[1];
			 my $cnvarea = $mmtoin * $mmtoin * $area;
			 print "$area, mm2 = $cnvarea, in2\n";
		 }			 

         if ($line =~ /^mm4-to-in4/) {
             my $inertia = $words[1];
			 my $cnvinertia = $mmtoin * $mmtoin * $mmtoin * $mmtoin * $inertia;
			 print "$inertia, mm4 = $cnvinertia, in4\n";
		 }			 

		 print "\n";	   
         }
