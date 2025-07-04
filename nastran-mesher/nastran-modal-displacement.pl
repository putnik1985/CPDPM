use strict;
use Math::Trig;
use Math::Complex;


    my @lines;
	my @fields;
	my %grids;
	
    while(<>){
		push(@lines, $_); 
    }
	
	for(my $str = 0; $str < @lines; ++$str){
		####print $lines[$str];
		if ($lines[$str] =~ /\$EIGENVECTOR/){
			$str += 3;
			######print $lines[$str];
			@fields = split/\s+/,&trim($lines[$str]);
			my $w2 = $fields[2];
			my $frequency = sqrt($w2) / (2*pi);
			printf "%30s%30.6f\n", "Frequency:", $frequency;
			
			$str += 1;
			while ($str < @lines && $lines[$str] !~ /\$TITLE/){

			       ##print $lines[$str];
   			       @fields = split/\s+/,&trim($lines[$str]);
                   #####printf "%12d%12g%12g%12g\n", $fields[0], $fields[2], $fields[3], $fields[4];
                   my $grid = $fields[0];
				   my $x = $fields[2];
				   my $y = $fields[3];
				   my $z = $fields[4];
				   
			       $str += 1;
			       ###print $lines[$str];
   			       @fields = split/\s+/,&trim($lines[$str]);
                   #####printf "%12s%12g%12g%12g\n", $fields[0], $fields[1], $fields[2], $fields[3];
				   my $rx = $fields[1];
				   my $ry = $fields[2];
				   my $rz = $fields[3];
			       printf "%24d-DISPX%30.8E\n%24d-DISPY%30.8E\n%24d-DISPZ%30.8E\n%24d-ROTAX%30.8E\n%24d-ROTAY%30.8E\n%24d-ROTAZ%30.8E\n", $grid, $x, $grid, $y, $grid, $z, $grid, $rx, $grid, $ry, $grid, $rz;
				   
			       $str += 1;
			}
		}
	}

sub trim{
	####print "input: @_[0]";
	my $s = @_[0];
	$s =~ s/^\s+|\s+$//g;
    return $s;
}