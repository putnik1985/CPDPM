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
	
	my %shells;
	my %grids;
    my %data;
 
    for(@ARGV){
            my @words = split/=/,$_;
            ####print $_ . "\n";
            ###print $words[0], $words[1];
            $data{$words[0]} = $words[1]; 
    }

	my $mesh_file = $data{"file"};
	open(inputh,'<', $mesh_file);
    while(<inputh>){
		my @words = split/,/,$_;
		if ($words[0] =~ /^GRID/){
			$grids{$words[1]} = $_;
        }
        if ($words[0] =~ /(^CQUAD)|(^CTRIA)/){
			$shells{$words[1]} = $_;
        }			
    }
    close(inputh);
  
    while (my ($key, $value) = each %shells) {
               my @nodes = &grids($value);
			   my ($x0, $y0, $z0) = &coordinates($grids{$nodes[0]});
			   my ($x1, $y1, $z1) = &coordinates($grids{$nodes[1]});
			   my ($x2, $y2, $z2) = &coordinates($grids{$nodes[2]});
			   
			   my ($ax, $ay, $az) = ($x1 - $x0, $y1 - $y0, $z1 - $z0);
			   my ($bx, $by, $bz) = ($x2 - $x0, $y2 - $y0, $z2 - $z0);
			   
			   my ($nx, $ny, $nz) = &cross_product("$ax,$ay,$az", "$bx,$by,$bz");
			   my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
			   if ($mag < 0.0001) {
				   print "element: $key has zero normal\n";
				   exit
			   }
			   
			   $nx /= $mag;
			   $ny /= $mag;
			   $nz /= $mag;
			   ### need to check if the element triangle or square to have proper area = 0.5 * mag or mag
               my $area;
			   if (@nodes == 3) {
			        $area = $mag / 2.;
					printf "%12d,%12d,%12d,%12d,%12.8f,%12.8f,%12.8f,%12.8f,\n", $key, $nodes[0], $nodes[1], $nodes[2], $area, $nx, $ny, $nz;
			   } else {
				    $area = $mag;
					printf "%12d,%12d,%12d,%12d,%12d,%12.8f,%12.8f,%12.8f,%12.8f,\n", $key, $nodes[0], $nodes[1], $nodes[2], $nodes[3], $area, $nx, $ny, $nz;
               }					
			   
	}		

sub trim{
	####print "input: @_[0]";
	my $s = @_[0];
	$s =~ s/^\s+|\s+$//g;
    return $s;
}

sub coordinates { ## input is the nastran GRID card
	my @words = split/,/,@_[0];
	($words[3], $words[4], $words[5])
}

sub grids { ## input is the nastran QUAD card
    ####chomp(@_[0]);
	my @words = split/,/,@_[0];
	if ($words[0] =~ /CTRIA/) {
		return ($words[3], $words[4], $words[5]);
	}

	if ($words[0] =~ /CQUAD/) {
		return ($words[3], $words[4], $words[5], $words[6]);
	}
	
}

sub dot_product{
	my @x = split /,/,@_[0];
	my @y = split /,/,@_[1];
	$x[0] * $y[0] + $x[1] * $y[1] + $x[2] * $y[2];
}

sub cross_product{
	my @x = split /,/,@_[0];
	my @y = split /,/,@_[1];
	
	( $x[1] * $y[2] - $x[2] * $y[1], 
	  $x[2] * $y[0] - $x[0] * $y[2],
	  $x[0] * $y[1] - $x[1] * $y[0]);
}

sub scalar_vector_product{
		my @x = split /,/,@_[0];
		my $scalar = @_[1];
		
        ( $scalar * $x[0],
		  $scalar * $x[1],
		  $scalar * $x[2]);
}
