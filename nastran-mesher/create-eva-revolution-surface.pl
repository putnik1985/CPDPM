use strict;

use Math::Trig;
use Cwd qw(getcwd);

    print "\n";
###usage: perl nastran-free-mesh-modifier.pl file=file_where_mesh surface_grid=66114774 r=0.03 h=0.001 origin_grid=66203118 cone_grid=66115037
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
	my $h = $data{"h"};
	my $grid = $data{"surface_grid"};
	my $origin_grid = $data{"origin_grid"};
	my $cone_grid = $data{"cone_grid"};
	
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

        &fields($file_grids{$origin_grid});	
        my ($x1, $y1, $z1) = ($fields[3], $fields[4], $fields[5]);

        &fields($file_grids{$grid});	
        my ($x0, $y0, $z0) = ($fields[3], $fields[4], $fields[5]);
        my $R0 = sqrt(($x0-$x1)**2 + ($z0-$z1)**2);

        &fields($file_grids{$cone_grid});	
        my ($x2, $y2, $z2) = ($fields[3], $fields[4], $fields[5]);
        my $R2 = sqrt(($x2-$x1)**2 + ($z2-$z1)**2);

        ####print "$cone_grid, $x2, $y2, $z2 \n";
        my @rbe3_grids;

        while ( my ($key, $value) = each %file_grids) {
            ####printf "$key\n";
            &fields($value);
            my ($x, $y, $z) = ($fields[3], $fields[4], $fields[5]);
            ####print "$key, $x, $y, $z\n";
            my $from_axis = sqrt(($x-$x1)**2 + ($z-$z1)**2);  
            my $R = $R0 + ($R2 - $R0) / ($y2 - $y0) * ($y - $y0);

            if ($from_axis >= ($R - $h) && $from_axis <= ($R + $h)) {
                    my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
                    if ($distance < $r) {
                        ####print "$key\n";
                            push(@rbe3_grids, $key);
                    }
                } 
        }
       
        #
        ###print @rbe3_grids;
        #
        #for(@rbe3_grids){
        #    print $_ ."\n";
        #}

        my ($xc, $yc, $zc) = &cg(@rbe3_grids);
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
    print "GRID,$grid,0,$xc,$yc,$zc,0\n";
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
    my @grids = @_[0];
    my $xc;
    my $yc;
    my $zc;

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
