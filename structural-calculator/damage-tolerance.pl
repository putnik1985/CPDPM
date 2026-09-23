use strict;
use Math::Trig;
use Math::Complex;
### need to modify
    my $sine;
    my $launch;
    my $random;

    my $R;
    my $fcross;
    my $lambda;
    my $duration;
    my $df;

    my $material_name;
	
    my %data;
    my @cycles;
    my @stress_percentage;

    while (<>) {
	    ###print $_;
	    my $line = $_;
	    my @words = split/,/,$_;
            $data{$words[0]} = $words[1];		    
	    if ($_ =~ /cycles/) {
		push(@cycles, $words[3]);
##		push(@stress_percentage, 0.01 * ($words[2] - $words[1])/2.);
 		push(@stress_percentage, 0.01 * $words[2]);
	    }
    }

    $sine = $data{"sine"} * 0.145; ## convert to ksi
    $launch = $data{"launch"} * 0.145;
    $random = $data{"random"} * 0.145;
    $R = $data{"R"};
    $fcross = $data{"fcross"};
    $lambda = $data{"lambda"};
    $df = $data{"df"};
    $duration = $data{"duration"};
    $material_name = $data{"material"};
	
	print "Material:, $material_name,\n";
    
	my $damage = 0;
    my $neq;
	
    ####print "$sine, $launch, $random, $R, $fcross, $lambda\n";
    print "Launch Spectrum\n";
    for (my $i=0; $i < @cycles; ++$i){
	    my $stress = $stress_percentage[$i] * $launch;
	    my $cycle = $cycles[$i];
		&calculate_damage($stress, $cycle);
    }

    print "Sine Spectrum\n";
    my $sine_neq = 60. / ($lambda * log(2)) * $df;
    &calculate_damage($sine, $sine_neq);	
    &calculate_damage($sine, $sine_neq);
	&calculate_damage($sine, $sine_neq);
	
	
    print "Random Spectrum\n";	
    my $random_neq = $duration * 0.222 * $fcross;
    my $n_3sigma = 0.048 * $random_neq;
    my $n_2sigma =  0.25 * $random_neq;
    my  $n_sigma =   0.68 * $random_neq;
	
    &calculate_damage($random, $n_3sigma);
    &calculate_damage($random, $n_3sigma);    
	&calculate_damage($random, $n_3sigma);	

    &calculate_damage(2./3.* $random, $n_2sigma);
    &calculate_damage(2./3.* $random, $n_2sigma);    
    &calculate_damage(2./3.* $random, $n_2sigma);

    &calculate_damage(1./3.* $random, $n_2sigma);
    &calculate_damage(1./3.* $random, $n_2sigma);    
    &calculate_damage(1./3.* $random, $n_2sigma);

    printf "Total Damage, , ,%e\n",4. * $damage;
    

    print "\n\n";
	print "Aluminium 7075 S-N curve:\n";
    my $s = 80;
	while ($s > 1.) {
		my $n = &al7075($s);
		print "$n, $s\n";
		$s-=5.;
	}
	
    print "\n\n";
	print "Ti 6Al-4V S-N curve:\n";
    my $s = 125;
	while ($s > 60.) {
		my $n = &ti6al4v($s);
		print "$n, $s\n";
		$s-=5.;
	}

    print "\n\n";
	print "Custom 455 S-N curve:\n";
    my $s = 150;
	while ($s > 70.) {
		my $n = &custom455($s);
		print "$n, $s\n";
		$s-=5.;
	}	

sub al7075{
	my $s1 = 60.;
	my $s2 = 15.;
	
	my $n1 = 14.86 - 5.8 * &log10($s1);
	my $n2 = 14.86 - 5.8 * &log10($s2);
	
	my $s0 = @_[0] * (1 - $R)**0.49;
	my $n;
	
	if ( $s0 <= $s1 && $s0 >=$s2 ) {
		$n = 14.86 - 5.8 * &log10($s0);
	}
	
	if ( $s0 < $s2 ) {
		my $ds_dn = - $s2 * log(10.) / 5.8;
		$n = ($s0 - $s2) / $ds_dn + $n2;
	}	
	
	if ( $s0 > $s1 ) {
		my $ds_dn = - $s1 * log(10.) / 5.8;
		$n = ($s0 - $s1) / $ds_dn + $n1;
	}		
	return 10**$n;
}

sub ti6al4v{
	my $s1 = 115.;
	my $s2 = 88.;
	
	my $n1 = 12.59 - 4.89 * &log10($s1 - 82.8);
	my $n2 = 12.59 - 4.89 * &log10($s2 - 82.8);
	
	my $s0 = @_[0] * (1 - $R)**0.29;
	my $n;
	
	if ( $s0 <= $s1 && $s0 >=$s2 ) {
		$n = 12.59 - 4.89 * &log10($s0 - 82.8);
	}
	
	if ( $s0 < $s2 ) {
		my $ds_dn = - ($s2 - 82.8) * log(10.) / 4.89;
		$n = ($s0 - $s2) / $ds_dn + $n2;
	}	
	
	if ( $s0 > $s1 ) {
		my $ds_dn = - ($s1 - 82.9) * log(10.) / 4.89;
		$n = ($s0 - $s1) / $ds_dn + $n1;
	}		
	return 10**$n;
}

sub custom455{
	my $s1 = 140.;
	my $s2 = 98.;
	
	my $n1 = 38.1 - 15.7 * &log10($s1);
	my $n2 = 38.1 - 15.7 * &log10($s2);
	
	my $s0 = @_[0];
	my $n;
	
	if ( $s0 <= $s1 && $s0 >=$s2 ) {
		$n = 38.1 - 15.7 * &log10($s0);;
	}
	
	if ( $s0 < $s2 ) {
		my $ds_dn = - $s2 * log(10.) / 15.7;
		$n = ($s0 - $s2) / $ds_dn + $n2;
	}	
	
	if ( $s0 > $s1 ) {
		my $ds_dn = - $s1 * log(10.) / 15.7;
		$n = ($s0 - $s1) / $ds_dn + $n1;
	}		
	return 10**$n;
}

sub log10{
	my $x = @_[0];
	return log($x) / log(10);
}

sub calculate_damage{
	    my $stress = @_[0];
		my $cycle = @_[1];
		my $material = \&al7075;
		## material_name is a global variable
		
		if ($material_name =~ /al/) {
			          $material = \&al7075;
		}
		
		if ($material_name =~ /ti/) {
			          $material = \&ti6al4v;
		}

		if ($material_name =~ /custom/) {
			          $material = \&custom455;
		}
		
		my $neq = &$material($stress);
	    printf "%.2f,%ld,%.0e,%E\n", $stress, $cycle, $neq, $cycle / $neq;
	    $damage += $cycle / $neq;
}
