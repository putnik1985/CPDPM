use strict;
use Math::Trig;
use Math::Complex;

    my $fb = 65.;
    my $C2 = 5.;
    my $M0 = 215.1;

    my $f0 = 20.;
    my $fm = 2000.;

    my $N = 1980;

    my %data;
    foreach my $arg (@ARGV) {
	    ###print $arg . "\n";
	    my @words = split/=/,$arg;
	    $data{$words[0]} = $words[1];
    }

    ###print $data{"file"};
    $M0 = $data{"Mass"};
    $C2 = $data{"C2"};
    $fb = $data{"fb"};
    my $G = $data{"g"};

    my $M02 = $M0 * $M0;
    open fh,'<', $data{"asd"} || 
    die "can not open asd file\n";
    my @lines = <fh>;


    my @freq;
    my @power;

    foreach my $line (@lines) {
	    ####print $line;
	    my @words = split/,/,$line;
	    push(@freq, $words[0]);
	    push(@power,$words[1]);
	    #####print $words[0] . "," . $words[1] . "\n";
    }

    open resp,'<', $data{"fsd"} || 
    die "can not open fsd file\n";
    my @lines = <resp>;


    my @fr;
    my @fx;
    my @fy;
    my @fz;

    foreach my $line (@lines) {
	    ####print $line;
	    my @words = split/,/,$line;
	    push(@fr,$words[0]);
	    push(@fx,$words[1]);
	    push(@fy,$words[2]);
	    push(@fz,$words[3]);
    }

    printf "Mass:, $M0, fb:, $fb, C2:, $C2\n";
    printf("Frequency(Hz),FSD\n");
    my $dB = 0.;

    my @notching;
    for(my $i=0; $i<@fr; ++$i){
	    my $f = $fr[$i];
	    my $asd = &calculate_asd($f) * $G * $G; 
	    my $fsd;
	    if ($f < $fb) {
		    $fsd = $C2 * $M02 * $asd ;
	    } else {
		    $fsd = $C2 * $M02 * ($fb/$f)**2 * $asd;
	    }

	    my $notch;
	    my $maxf = &max($fx[$i], &max($fy[$i],$fz[$i]));
	    if ($maxf > $fsd) {
		    $notch = $asd * $fsd / $maxf;
	    } else {
		    $notch = $asd;
	    }

	    $asd /= $G*$G;
	    $notch /= $G*$G;

	    push(@notching, $notch);
            if (10. * log10($notch/$asd) < $dB) {
	        $dB = 10.*log10($notch/$asd); 	    
	    };

	    printf "%.4f,%.4f,%.4f,%.2f,%.2f,%.2f,%.2f\n", $fr[$i], $asd, $notch, $fx[$i], $fy[$i], $fz[$i], $fsd;
    }

    printf "\ndB notch:, $dB\n";

    my $nastran = $data{"fsd"} . "-notched.txt";
    open fwh, '>', $nastran ||
    die "can not write file\n";

    printf fwh "Nastran Table\n";
    my $fields = 8;
    my $written = 0;
    printf fwh "+,";
    for(my $i=0; $i<@notching; ++$i) {
        if ($written < $fields) {
		printf fwh "%.4f,%.4f,", $fr[$i], $notching[$i];
		$written += 2;
	} else {
                printf fwh "\n+,";
		$written = 0;
	}
    }
    printf fwh "endt\n";


sub calculate_asd {
	my $f = shift;
	my $P;
	for (my $i=0; $i<@freq-1; ++$i) {
		if ($freq[$i] <= $f && $f <=$freq[$i+1]){
			my $P1 = $power[$i];
			my $P2 = $power[$i+1];
			my $f1 = $freq[$i];
			my $f2 = $freq[$i+1];
			####print "$f, found in, $f1, $f2, $P1, $P2\n";
			$P = exp(log($f2/$f) / log($f2/$f1) * log($P1) + log($f/$f1) / log($f2/$f1) * log($P2));
			last;
		}
	}
	return $P;
}

sub log10 {
	my $x = shift;
	return log($x) / log(10);
}

sub max {
	my $a = shift;
	my $b = shift;
	if ($a>$b) {
		return $a;
	} else {
		return $b;
	}
}

