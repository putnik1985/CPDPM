use strict;
use Math::Trig;
use Math::Complex;

    my %data;
    foreach my $arg (@ARGV) {
	    my @words = split/=/,$arg;
	    $data{$words[0]} = $words[1];
    }

    my $C = $data{"C"};
    my $M0 = $data{"mass"};
    my $G = $data{"g"};
    my $fsd = $data{"fsd"};
    my $sine = $data{"sine"};

    my $fb = $data{"fb"};

    open fh,'<', $fsd || 
         die "can not open $fsd\n";
 
	 my @lines = <fh>;
	 my @freq;
	 my @ampl;
	 foreach my $line (@lines) {
		 my @words = split/,/,$line;
		 push(@freq,$words[0]);
		 push(@ampl,&max($words[1], &max($words[2],$words[3])));
	 }
    close(fh);


    open sfh, '<', $sine ||
         die "can not open $sine\n";
  
	 @lines = <sfh>;
	 my @sfreq;
	 my @sampl;
	 foreach my $line (@lines) {
		 my @words = split/,/,$line;
		 push(@sfreq,$words[0]);
		 push(@sampl,$words[1]);
	 }
    close(sfh);

         for(my $i=0; $i<@freq; ++$i){
		 my $f = $freq[$i];
		 my $force = $ampl[$i];
		 my $a = $G * &calculate_g($f);
                 
		 my $limit;
                 my $notch;

		 if ($f < $fb) {
			 $limit = $C * $M0 * $a;
		 } else {
			 $limit = $C * $M0 * ($fb/$f) * $a;
		 }
                 if ($force > $limit) {
			 $notch = $limit / $force * $a;
		 } else {
			 $notch = $a;
		 }
		 printf "%.4f,%.2f,%.2f,%.2f,%.2f\n", $freq[$i], $a/$G, $notch/$G, $force, $limit;
	 }

sub max{
	my $a = shift;
	my $b = shift;

	if ($a > $b) {
		return $a;
	} else {
		return $b;
	}
}

sub calculate_g {
	my $f = shift;
	my $a;

	for(my $i=0; $i<@sfreq-1; ++$i){
		if ($f>=$sfreq[$i] && $f<=$sfreq[$i+1]){
			my $a1 = $sampl[$i];
			my $a2 = $sampl[$i+1];
                        my $f1 = $sfreq[$i];
			my $f2 = $sfreq[$i+1];

			$a = $a1 + ($a2 - $a1) / ($f2 - $f1) * ($f - $f1);
			last;
		}
	}
	return $a;
}
