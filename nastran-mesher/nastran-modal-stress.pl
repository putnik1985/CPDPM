use strict;
use Math::Trig;
use Math::Complex;


    my @lines;
	my @fields;
	my %grids;
	my %types;
	
	$types{"chexa8"} = 67;
	$types{"penta6"} = 68;
    $types{"cquad4"} = 33;
    $types{"cquadr"} = 228;	
	
    while(<>){
		push(@lines, $_); 
    }
        my $current_frequency = 0.;	
	for(my $str = 0; $str < @lines; ++$str){
		####print $lines[$str];
		if ($lines[$str] =~ /\$ELEMENT STRESSES/){
			$str += 3;
			###print $lines[$str];
			@fields = split/\s+/,&trim($lines[$str]);
			my $type = $fields[3];
			###print $type;
			$str += 1;
			@fields = split/\s+/,&trim($lines[$str]);
			my $w2 = $fields[2];
			my $frequency = sqrt($w2) / (2*pi);	
            ###print "$type $frequency\n";
			
		        if ($current_frequency != $frequency) {
				$current_frequency = $frequency; 
				printf "%34s%30.2f\n", "Frequency:", $current_frequency
			}
            if ($type == $types{"chexa8"} || $type == $types{"penta6"}){
				$str += 1;
				while($str < @lines && $lines[$str] !~ /\$TITLE/){
					@fields = split/\s+/,&trim($lines[$str]);
					my $element = $fields[0];
					if ($element =~ /^[0-9]/){
					    ###print "$frequency $element\n";	
						$str += 1;
						@fields = split/\s+/,&trim($lines[$str]);
						my $sxx = $fields[2];
						my $sxy = $fields[3];
						
						$str += 3;
						@fields = split/\s+/,&trim($lines[$str]);
						my $syy = $fields[1];
						my $syz = $fields[2];
						
						$str += 2;
						@fields = split/\s+/,&trim($lines[$str]);
						my $szz = $fields[1];
						my $szx = $fields[2];
						
						printf "%30d-SXX%30.6E\n%30d-SYY%30.6E\n%30d-SZZ%30.6E\n%30d-SXY%30.6E\n%30d-SYZ%30.6E\n%30d-SZX%30.6E\n", $element, $sxx, $element, $syy, $element, $szz, $element, $sxy, $element, $syz, $element, $szx;
						
						
					    $str += 1;
					}
                    $str += 1;					
				}
            } ### if ($type == $types{"chexa8"} || $type == $types{"penta6"})

            if ($type == $types{"cquad4"} || $type == $types{"cquadr"}){
				$str += 1;
				while($str < @lines && $lines[$str] !~ /\$TITLE/){
					@fields = split/\s+/,&trim($lines[$str]);
					my $element = $fields[0];
					if ($element =~ /^[0-9]/){
					    ###print "$frequency $element\n";	
						
						my $sxx = $fields[2];
						my $syy = $fields[3];
						
						$str += 1;
						@fields = split/\s+/,&trim($lines[$str]);
						my $sxy = $fields[1];
						my $syz = 0.0;
						my $szx = 0.0;
						my $szz = 0.0;
						#### top stresses
						printf "%30d-SXX%30.6E\n%30d-SYY%30.6E\n%30d-SZZ%30.6E\n%30d-SXY%30.6E\n%30d-SYZ%30.6E\n%30d-SZX%30.6E\n", $element, $sxx, $element, $syy, $element, $szz, $element, $sxy, $element, $syz, $element, $szx;
						
						$str += 2;
						@fields = split/\s+/,&trim($lines[$str]);
						my $sxx = $fields[1];
						my $syy = $fields[2];
						my $sxy = $fields[3];
						my $syz = 0.0;
						my $szx = 0.0;
						my $szz = 0.0;
						#### bottom stresses
						printf "%30d-SXX%30.6E\n%30d-SYY%30.6E\n%30d-SZZ%30.6E\n%30d-SXY%30.6E\n%30d-SYZ%30.6E\n%30d-SZX%30.6E\n", $element, $sxx, $element, $syy, $element, $szz, $element, $sxy, $element, $syz, $element, $szx;
						
					    $str += 1;
					}
                    $str += 1;					
				}
            } ### if ($type == $types{"cquad4"} || $type == $types{"cquadr"})			
		}
	}

sub trim{
	####print "input: @_[0]";
	my $s = @_[0];
	$s =~ s/^\s+|\s+$//g;
    return $s;
}
