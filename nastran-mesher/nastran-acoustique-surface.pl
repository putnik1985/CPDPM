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
			   print "$key, $nodes[0], $nodes[1], $nodes[2], $nodes[3]\n";
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
