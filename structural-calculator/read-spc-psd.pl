use strict;
use Math::Trig;
use Math::Complex;


    my $file = $ARGV[0];
    open(fh, '<', $file) ||
    die "can not open file: $file\n";

    my @lines = <fh>;

    for(my $i=0; $i<@lines; ++$i){
	    if ($lines[$i] =~ /SPCF - PSDF/){
		    $i += 4;
		    my $line = &trim($lines[$i]);
		    my @words = split/\s+/,$line;
		    while ($words[0] =~ /[0-9]/) {
			    printf "%.4f,%.4f,%.4f,%.4f\n", $words[0], $words[2], $words[3], $words[4]; 
			    $i += 2;
		            $line = &trim($lines[$i]);
		            @words = split/\s+/,$line;
		    }
		    last;
	    }
    }


sub trim {
	my $line = shift;
	$line =~ s/^\s+|\s$//;
	return $line;
}
