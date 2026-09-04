use strict;
use Math::Trig;
use Math::Complex;

    my $file = $ARGV[0];
    ######print $file;
    my $case;
    open(fh,'<', $file);
         while (<fh>) {
		 chomp;
		 ####print $_;
		 if ($_ =~ /Load/) {
			 ###print $_;
			 my $line = $_;
			 $line =~ s/\s//g;
			 my @words = split/:/,$line;
			 $case = $words[1];
		 }
			 my $line = $_;
			 $line =~ s/^\s+//;
			 ###print $line;
			 if ($line =~ /^[0-9]/) {
				 ####print $case, $line;
				 my @words = split/\s+/, $line;
				 my ($id, $ma1, $ma2, $sa1, $sa2, $aa1, $ta1);
				 $id = $words[0];
				 $ma1 = $words[5];
				 $ma2 = $words[6];
				 $sa1 = $words[7];
				 $sa2 = $words[8];
				 $aa1 = $words[9];
				 $ta1 = $words[10];
				 $line = <fh>;
				 chomp($line);
				 $line =~ s/^s+//;
				 my ($mb1, $mb2, $sb1, $sb2, $ab1, $tb1);
				 @words = split/\s+/, $line;
				 $mb1 = $words[2];
				 $mb2 = $words[3];
				 $sb1 = $words[4];
				 $sb2 = $words[5];
				 $ab1 = $words[6];
				 $tb1 = $words[7];
                                 my ($fx, $fy, $fz, $mx, $my, $mz);
				 $fx = sqrt($aa1**2 + $ab1**2);
				 $fy = sqrt($sa1**2 + $sb1**2);
				 $fz = sqrt($sa2**2 + $sb2**2);
				 $mx = sqrt($ta1**2 + $tb1**2);
				 $my = sqrt($ma1**2 + $mb1**2);
				 $mz = sqrt($ma2**2 + $mb2**2);
				 print "$id,$case,$fx,$fy,$fz,$mx,$my,$mz,0\n";

			 }
	 }
    close(fh)

