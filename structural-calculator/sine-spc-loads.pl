use strict;
use Math::Complex;
use Math::Trig;

    my %data;
    foreach my $arg (@ARGV) {
	    my @words = split/=/,$arg;
	    $data{$words[0]}=$words[1];
    }
    ##print $data{"file"};
    my $file = $data{"file"};

    open fh, '<', $file ||
    die "can not open file: $file\n";

    my @lines = <fh>;

    for (my $i = 0; $i<@lines; ++$i) {
	    my $line = $lines[$i];
	    if ($line =~ /SPCF/) {
		$line = &trim($lines[$i+=3]);
	        my @words = split/\s+/,$line;
		my $freq = $words[2];
		$line = &trim($lines[$i+=1]);
	        my @words = split/\s+/,$line;
		my $fx = $words[2];
		my $fy = $words[3];
		my $fz = $words[4];
		print "$freq,$fx,$fy,$fz\n";
	    }
    }


sub trim{
	my $line = shift;
	$line =~ s/^\s+|\s+$//;
	return $line;
}
