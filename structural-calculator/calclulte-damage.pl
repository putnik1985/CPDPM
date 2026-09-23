use strict;
use Math::Trig;
use Math::Complex;

    my $R = -1.;
    my $A = 14.86;
    my $B = -5.80;
    my $C = 0.;
    my $D = 0.49;

    my $cycles_threshold = 1.e+6;
    my $scatter = 4.;
    my $smax1 = 15.;
    my $smax2 = 70;


    my $seq1 = $smax1 * (1. - $R)**$D;
    my $seq2 = $smax2 * (1. - $R)**$D;

    my $total_damage =0.;
    while (<>) {
	   chomp;
	   my @words = split/,/,$_;
	   ##printf("%s %s\n", $words[0], $words[1]);
	   my $cycle = $words[0];
	   ##print "$cycle\n";
	   my $seq = $words[1];
	   my $n;

	   if ( $seq >= $seq1 && $seq <= $seq2) {
		   $n = &material($seq);
	   } else {
		   $n = &approximation($seq);
	   }

	   my $allow_cycles = 10.**$n;
       my $damage;
	   
	   $damage = $cycle / $allow_cycles;

	    
	   $total_damage += $damage;   
	   printf("%.2e,%.2f,%.1e,%.4e\n", $cycle, $seq, $allow_cycles, $damage);
    }
    $total_damage *= $scatter;
    print "\n\nTotal Damage:,$total_damage\n";


    my $seq = 2 * $seq2;
       while ($seq > 0.) {
	   my $n;
	   if ( $seq >= $seq1 && $seq <= $seq2) {
		   $n = &material($seq);
	   } else {
		   $n = &approximation($seq);
	   }
	   my $cycle = 10**$n;
	   print("$cycle,$seq\n");
	   $seq -= 1.;
       }

sub material{
	my $seq = shift;
	return $A + $B * &log10($seq + $C);
}

sub log10{
	my $x = shift;
        return log($x) / log(10);
}


sub approximation{
	my $seq = shift;
	my $s0;

	if ( $seq < $seq1) {
             $s0 = $seq1;
        };

	if ($seq > $seq2){
	     $s0 = $seq2;
	};

        my $n0 = &material($s0);

	return $n0 + $B / log(10.) * ($seq - $s0) / ($s0 + $C);
}
