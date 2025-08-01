use strict;

use Math::Trig;
use Cwd qw(getcwd);

    print "\n";
###usage: perl nastran-free-mesh-modifier.pl file=file_where_mesh surface_grid=66114774 r=0.03 dcs=0 rcs=0
#
        my %data;
        for(@ARGV){
            my @words = split/=/,$_;
            ####print $_ . "\n";
            ###print $words[0], $words[1];
            $data{$words[0]} = $words[1]; 
        }

	my $mesh_file = $data{"file"};
	my $r = $data{"r"};
	my $grid = $data{"surface_grid"};
	my $dcs = $data{"dcs"};
	my $rcs = $data{"rcs"};
	
	my $rbe2_fields = 9;
	my $rbe3_fields = 9;
        my $error = 0.001;	
	my $load_id = 100;
	my $spc_id = 100;
	my $mpc_id = 100;
	my $unreal_number = 1.e+38;
	my $total_dofs = 6;
	my $grids_modified = 0;
	my $tolerance = 0.002;
	my $file_update = 0;
	my $next_element  = -$unreal_number;
	my $next_grid     = -$unreal_number;
	my $next_property = -$unreal_number;
	my $next_material = -$unreal_number;
	my $next_spc = 1;
        my $error = 1.E-12;
	
        my @fields;
	
        ##printf "Read:\n";
        ###printf "$r, $h, $grid\n";
	my %file_grids;
	my %file_cbars;
	my @file_lines;
	
	open(gridh,'<',$mesh_file);
	     while (<gridh>){
	         push(@file_lines,$_);
			 my @words = split/,/,$_;
			 if ($words[0] =~ /^GRID/){
				 if ($next_grid < $words[1]){
					 $next_grid = $words[1];
				 }
                 $file_grids{$words[1]} = $_;				 
			 }

			 if ($words[0] =~ /^CBAR/){
				 ######print $words[1] . $_ ;
                 $file_cbars{$words[1]} = $_;				 
			 }


            if ($words[0] =~ /PSOLID|PBUSH|PSHELL|PBEAML|PBAR/){
		        if ($next_property < $words[1]) {
				    $next_property = $words[1];
			    }				
		    }
            if ($words[0] =~ /MAT1/){
		        if ($next_material < $words[1]) {
				    $next_material = $words[1];
			    }				
		    }
		 if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP|CBEAM|CBAR/){
			    if ($next_element < $words[1]) {
				    $next_element = $words[1];
			    }

            if ($words[0] =~ /SPC/){
			    if ($next_spc < $words[1]) {
				    $next_spc = $words[1];
			    }
		    }

		    }
		}
	close(gridh);
	$next_element++;
	$next_grid++;
	$next_material++;
	$next_property++;
	$next_spc++;

        &fields($file_grids{$grid});	
        my ($x0, $y0, $z0) = ($fields[3], $fields[4], $fields[5]);

        my @rbe3_grids;

        while ( my ($key, $value) = each %file_grids) {
            ####printf "$key\n";
            &fields($value);
            my ($x, $y, $z) = ($fields[3], $fields[4], $fields[5]);
            ####print "$key, $x, $y, $z\n";
            my $distance = sqrt(($x-$x0)**2 + ($z-$z0)**2); ### distance in place y=const
            ####print "$key, $distance, $r\n";
                if ($distance < $r && abs($y-$y0) < $error) {
                   #####print "$key,$x,$y,$z\n";
                   push(@rbe3_grids, $key);
                }
        } 
       
        #
        ###print @rbe3_grids;
        #
        #for(@rbe3_grids){
        #    print $_ ."\n";
        #}

        my ($xc, $yc, $zc) = &cg(@rbe3_grids);
        #####my ($xc, $yc, $zc) = ($x0, $y0, $z0);
        &nastran_grid($next_grid, $xc, $yc, $zc);     
        &nastran_rbe3($next_grid, $next_element, @rbe3_grids);
        $next_grid++;
        $next_element++;
 

sub fields{
    @fields = split/,/,@_[0];
}

sub nastran_grid{
    my $grid = @_[0];
    my ($xc, $yc, $zc) = (@_[1], @_[2], @_[3]);
    print "GRID,$grid,$rcs,$xc,$yc,$zc,$dcs\n";
}

sub nastran_rbe3 {
        my $grid = @_[0];
        my $element = @_[1];
        my @grids;
        for(my $i=2; $i<@_; $i++){
            push(@grids,@_[$i]);
            ####print @_[$i] . "\n";
        }

        my $current_field = 8;
	my $current = 0;
	my $last = @grids;
        #####print @grids;
	printf "RBE3,%d,,%d,123456,1.0,123,",$element,$grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe3_fields) {
		        printf "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf "+\n";
		        printf "+,";
		        printf "%d,",$grids[$k];				
                $current_field = 3; 				
            }
    }	
}

sub cg {

    my @grids;
    my $xc;
    my $yc;
    my $zc;

    for(my $i=0; $i < @_; $i++){
        push(@grids, @_[$i]);
    }

    for (@grids) {
         my $grid = $_;
         &fields($file_grids{$grid});
         $xc += $fields[3];
         $yc += $fields[4];
         $zc += $fields[5]; 
    } 
    $xc /= @grids;
    $yc /= @grids;
    $zc /= @grids;
    ($xc, $yc, $zc)
}
