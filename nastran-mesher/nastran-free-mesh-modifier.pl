use strict;
use autodie;

use Math::Trig;


    print "\n";

	my $mesh_file = $ARGV[0];
    my $command_file = $ARGV[1];
	my $rbe2_fields = 9;
	my $rbe3_fields = 9;
    my $error = 0.0001;	
	my $load_id = 100;
	my $spc_id = 100;
	my $mpc_id = 100;
	my $unreal_number = 1.e+38;
	
##	printf "command file: %12s\n",$command_file;
##	printf "  input file: %12s\n", $mesh_file;
##	printf "\n";
	
	open(fh, '<', $command_file) or die $!;
	my %commands;
	
	while (<fh>) {
	   ####print $_;	
	   my @words = split /,/,$_;
	   if ($words[0] =~ /^_grid_translate_box$/) {
		   ####print $_;
	       grid_translate_box($_);   
           print "_grid_translate_box completed\n";
       }		   

	   if ($words[0] =~ /^_grid_copy_rotate_y$/) {
		   ####print $_;
	       grid_copy_rotate_y($_); 
           print "_grid_copy_rotate_y completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_sphere$/) {
		   ####print $_;
	       grid_rbe2_sphere($_); 
           print "_grid_rbe2_sphere completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_sphere_copy_rotate_y$/) {
		   ####print $_;
	       grid_rbe2_sphere_copy_rotate_y($_); 
           print "_grid_rbe2_sphere_copy_rotate_y completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe3_cone$/) {
		   ####print $_;
	       grid_rbe3_cone($_); 
           print "_grid_rbe3_cone completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_cone$/) {
		   ####print $_;
	       grid_rbe2_cone($_); 
           print "_grid_rbe2_cone completed\n";		   
       }		   


	   if ($words[0] =~ /^_grid_spc_plane$/) {
		   ####print $_;
	       grid_spc_plane($_); 
           print "_grid_spc_plane completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_force_cone$/) {
		   ####print $_;
	       grid_force_cone($_); 
           print "_grid_force_cone completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_force_cylinder$/) {
		   ####print $_;
	       grid_force_cylinder($_); 
           print "_grid_force_cylinder completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_cylinder$/) {
		   ####print $_;
	       grid_rbe2_cylinder($_); 
           print "_grid_rbe2_cylinder completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe3_cylinder$/) {
		   ####print $_;
	       grid_rbe3_cylinder($_); 
           print "_grid_rbe3_cylinder completed\n";		   
       }		   


	   if ($words[0] =~ /^_grid_rbe2_sphere_copy_translate$/) {
		   ####print $_;
	       grid_rbe2_sphere_copy_translate($_); 
           print "_grid_rbe2_sphere_copy_translate completed\n";		   
       }		   

	   if ($words[0] =~ /^_mesh_stat$/) {
		   ####print $_;
	       mesh_stat($_); 
           print "_mesh_stat completed\n";		   
       }		   
	   if ($words[0] =~ /^_grid_rbe2_contact_copy_translate$/) {
		   ####print $_;
	       grid_rbe2_contact_copy_translate($_); 
           print "_grid_rbe2_contact_copy_translate completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_contact$/) {
		   ####print $_;
	       grid_rbe2_contact($_); 
           print "_grid_rbe2_contact completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_copy$/) {
		   ####print $_;
	       grid_copy($_); 
           print "_grid_copy completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_copy_rotate$/) {
		   ####print $_;
	       grid_copy_rotate($_); 
           print "_grid_copy_rotate completed\n";		   
       }		   

	}
	close(fh);


sub grid_translate_box {
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $x1 = $words[4];
		   my $y1 = $words[5];
		   my $z1 = $words[6];
		   my $dx = $words[7];
		   my $dy = $words[8];
		   my $dz = $words[9];
	
	open(fh1, '<', $mesh_file) or die $!;
	
	 while (<fh1>) {
		my @words = split /,/,$_;
        if ($words[0] =~ /GRID/){
			if ( within($words[3],$x0,$x1) &&
			     within($words[4],$y0,$y1) &&
                 within($words[5],$z0,$z1)				 
			   ) {
                ####print $_;
				$words[3] += $dx;
				$words[4] += $dy;
				$words[5] += $dz;
				print join(",",@words);
            } else {
                print $_;
            }				
        } else {
		        print $_;	
		}	
         		
	 }
	close(fh1);
}

sub grid_copy_rotate_y {
	
	       my @words = split /,/,@_[0];
		   my $x = $words[1];
		   my $y = $words[2];
		   my $z = $words[3];
		   my $copies = $words[4];
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
	 }
	close(fh1);
	###print "highest grid: " . $new_grid;

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rotate_output:\n";
	my $alpha = 2. * pi / $copies;
	
	for(my $k = 0; $k < $copies; $k++) {
		my $new_x = $x * cos($k * $alpha) - $z * sin($k * $alpha);
		my $new_y = $y;
		my $new_z = $x * sin($k * $alpha) + $z * cos($k * $alpha);
		printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$new_x,$new_y,$new_z;
    }	
    close(fh1);	
}

sub grid_rbe2_sphere {
	
	       my @words = split /,/,@_[0];
		   my $x = $words[1];
		   my $y = $words[2];
		   my $z = $words[3];
		   my $radius = $words[4];
		   
	my @grids;
	my $closest_grid;
	my $min_distance = $radius;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x0 = $words[3];
			my $y0 = $words[4];
			my $z0 = $words[5];	
            my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
            if ($distance <= $radius){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "closest grid: " . $closest_grid . "\n";
	##print "minimum distance: " . $min_distance . "\n";

	open(fh1, ">>", $mesh_file) or die $!;

	print fh1 "\n\$_grid_rbe2_sphere output:\n";
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x,$y,$z;
	printf fh1 "RBE2,%d,%d,123456,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }

    }	
    close(fh1);		
	
}


sub grid_rbe2_sphere_copy_rotate_y {
	
	       my @words = split /,/,@_[0];
		   my $x = $words[1];
		   my $y = $words[2];
		   my $z = $words[3];
		   my $copies = $words[4];
		   my $radius = $words[5];
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
	 }
	close(fh1);
	###print "highest grid: " . $new_grid;

	my $alpha = 2. * pi / $copies;
	
	for(my $k = 0; $k < $copies; $k++) {
		my $new_x = $x * cos($k * $alpha) - $z * sin($k * $alpha);
		my $new_y = $y;
		my $new_z = $x * sin($k * $alpha) + $z * cos($k * $alpha);
		my $command = "_grid_rbe2_sphere,$new_x,$new_y,$new_z,$radius,\n";
		grid_rbe2_sphere($command);
    }	
}

sub grid_rbe3_cylinder {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $h = $words[4];
		   my $radius = $words[5];
		   my $nx = $words[6];
		   my $ny = $words[7];
		   my $nz = $words[8];		   
		   
	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];
		
			my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cylinder($point, $cone)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe3_cone output:\n";
    my $current_field = 8;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "RBE3,%d,,%d,123456,1.0,123,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe3_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }
    }	
    close(fh1);		
}


sub grid_rbe3_cone {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $h = $words[4];
		   my $radius = $words[5];
		   my $nx = $words[6];
		   my $ny = $words[7];
		   my $nz = $words[8];		   
		   
	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];
			my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cone($point, $cone)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;

	print fh1 "\n\$_grid_rbe3_cone output:\n";
    my $current_field = 8;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "RBE3,%d,,%d,123456,1.0,123,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe3_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }
    }	
    close(fh1);		
	
}

sub grid_rbe2_cone {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $h = $words[4];
		   my $radius = $words[5];
		   my $nx = $words[6];
		   my $ny = $words[7];
		   my $nz = $words[8];		   
		   
	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];
			my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cone($point, $cone)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;

	print fh1 "\n\$_grid_rbe2_sphere output:\n";
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "RBE2,%d,%d,123456,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }

    }	
    close(fh1);		
	
}

sub grid_spc_plane {
	my @words = split /,/,@_[0];
	my $dofs = $words[1];
	my $x0 = $words[2];
	my $y0 = $words[3];
	my $z0 = $words[4];
	my $nx = $words[5];
	my $ny = $words[6];
	my $nz = $words[7];

	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
	
	 while (<fh1>) {
		my @words = split /,/,$_;
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];
			my $point = "$x,$y,$z,";
            my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 			
            if (within_plane($point, $plane)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_spc_plane output:\n";	
	for (@grids) {
		printf fh1 "spc,$spc_id,$_,$dofs,\n";
	}
	close(fh1);
}

sub grid_force_cone {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $h = $words[4];
		   my $radius = $words[5];
		   my $nx = $words[6];
		   my $ny = $words[7];
		   my $nz = $words[8];
           my $fx = $words[9];
           my $fy = $words[10];
           my $fz = $words[11]; 		   
		   
	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];
			my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cone($point, $cone)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;

	print fh1 "\n\$_grid_force_cone output:\n";
    my $current_field = 8;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "FORCE,$load_id,%d,0,1.0,$fx,$fy,$fz,\n",$new_grid;	
	printf fh1 "RBE3,%d,,%d,123456,1.0,123,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe3_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }
    }	
    close(fh1);		
	
}

sub grid_force_cylinder {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $h = $words[4];
		   my $radius = $words[5];
		   my $nx = $words[6];
		   my $ny = $words[7];
		   my $nz = $words[8];
           my $fx = $words[9];
           my $fy = $words[10];
           my $fz = $words[11]; 		   
		   
	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];
			my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cylinder($point, $cone)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;

	print fh1 "\n\$_grid_force_cylinder output:\n";
    my $current_field = 8;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "FORCE,$load_id,%d,0,1.0,$fx,$fy,$fz,\n",$new_grid;	
	printf fh1 "RBE3,%d,,%d,123456,1.0,123,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe3_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }
    }	
    close(fh1);		
	
}

sub grid_rbe2_cylinder {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $h = $words[4];
		   my $radius = $words[5];
		   my $nx = $words[6];
		   my $ny = $words[7];
		   my $nz = $words[8];
		   
	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];
			my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cylinder($point, $cone)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	open(fh1, ">>", $mesh_file) or die $!;

	print fh1 "\n\$_grid_rbe2_cylinder output:\n";
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "RBE2,%d,%d,123456,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }

    }	
    close(fh1);		
	
}

sub grid_rbe2_sphere_copy_translate {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];

		   my $dx = $words[4];
		   my $dy = $words[5];
		   my $dz = $words[6];
		   
		   my $copies = $words[8];
		   my $radius = $words[7];
	
	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe2_sphere_copy_translate output:\n";
    close(fh1);	
	
	for(my $k = 0; $k < $copies; $k++) {
		my $new_x = $x0 + $dx * $k;
		my $new_y = $y0 + $dy * $k;
		my $new_z = $z0 + $dz * $k;
		my $command = "_grid_rbe2_sphere,$new_x,$new_y,$new_z,$radius,\n";
		grid_rbe2_sphere($command);
    }	
}


sub grid_rbe2_contact_copy_translate {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];

           (my $nx, my $ny, my $nz) = ($words[4], $words[5], $words[6]);

		   my $dx = $words[7];
		   my $dy = $words[8];
		   my $dz = $words[9];
		   

		   my $radius = $words[10];
		   my $copies = $words[11];

	
	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe2_contact_copy_translate output:\n";
    close(fh1);	
	
	for(my $k = 0; $k < $copies; $k++) {
		my $new_x = $x0 + $dx * $k;
		my $new_y = $y0 + $dy * $k;
		my $new_z = $z0 + $dz * $k;
		my $command = "_grid_rbe2_contact,$new_x,$new_y,$new_z,$nx,$ny,$nz,$radius,\n";
		grid_rbe2_contact($command);
    }	
}

sub grid_rbe2_contact {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		  (my $nx, my $ny, my $nz) = ($words[4], $words[5], $words[6]);
		   my $radius = $words[7];
		   
		   
	my @grids;
	my $closest_grid;
	my $min_distance = $radius;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
			####print $_;
			if ($new_eid < $words[1]) {
				$new_eid = $words[1];
			}	
		}
		
        if ($words[0] =~ /GRID/){
			##print "$words[1] -->> $new_grid\n";
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
		
        if ($words[0] =~ /GRID/){
			my $x = $words[3];
			my $y = $words[4];
			my $z = $words[5];	
            my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
			my $point = "$x,$y,$z,";
            my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 			
         
            if ($distance <= $radius && within_plane($point,$plane)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "closest grid: " . $closest_grid . "\n";
	##print "minimum distance: " . $min_distance . "\n";

	open(fh1, ">>", $mesh_file) or die $!;

	print fh1 "\n\$_grid_rbe2_contact output:\n";
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "RBE2,%d,%d,123456,",++$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        printf fh1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }

    }	
    close(fh1);			
}

sub mesh_stat {
	
	
	open(fh1, '<', $mesh_file) or die $!;
	
    my $rbe2_eid;
    my $rbe3_eid;
    my $ctetra_eid;
    my $chexa_eid;
    my $cbush_eid;
	my $gap_eid;
	my $celas_eid;
	my $cquad_eid;
	
	my $min_grid = $unreal_number;
	my $max_grid;
	my $grids;

	my $min_elem = $unreal_number;
	my $max_elem;
	my $elems;

	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 

        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){

            ++$elems;
			
			if ($max_elem < $words[1]) {
				$max_elem = $words[1];
			}
			
			if ($min_elem > $words[1]) {
				$min_elem = $words[1];
			}
			
            if ($words[0] =~ /^RBE2/) { ++$rbe2_eid; }
			if ($words[0] =~ /^RBE3/) { ++$rbe3_eid; }
			if ($words[0] =~ /^CTETRA/) { ++$ctetra_eid; }
			if ($words[0] =~ /^CHEXA/) { ++$chexa_eid; }
			if ($words[0] =~ /^CQUAD/) { ++$cquad_eid; }
			if ($words[0] =~ /^CELAS/) { ++$celas_eid; }
			if ($words[0] =~ /^CBUSH/) { ++$cbush_eid; }
			if ($words[0] =~ /^GAP/) { ++$gap_eid; }			
		}
		
        if ($words[0] =~ /^GRID/){
			if ($max_grid < $words[1]) {
				$max_grid = $words[1];
			}	
			
			if ($min_grid > $words[1]) {
				$min_grid = $words[1];
			}	
            ++$grids;
		}	
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "closest grid: " . $closest_grid . "\n";
	##print "minimum distance: " . $min_distance . "\n";

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_mesh_stat output:\n";
	print fh1 "\$grids: $grids\n";
	print fh1 "\$lower grid: $min_grid\n";
	print fh1 "\$highest grid: $max_grid\n";
	print fh1 "\n";
	print fh1 "\$elements: $elems\n";
	print fh1 "\$lower element: $min_elem\n";
	print fh1 "\$highest element: $max_elem\n";
	print fh1 "\n";
	print fh1 "\$RBE2 element: $rbe2_eid\n";
	print fh1 "\$RBE3 element: $rbe3_eid\n";
	print fh1 "\$CTETRA element: $ctetra_eid\n";
	print fh1 "\$CHEXA element: $chexa_eid\n";
	print fh1 "\$CQUAD element: $cquad_eid\n";
	print fh1 "\$CELAS element: $celas_eid\n";
	print fh1 "\$CBUSH element: $cbush_eid\n";
	print fh1 "\$GAP element: $gap_eid\n";
    close(fh1);			
}


sub grid_copy {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];

		   my $dx = $words[4];
		   my $dy = $words[5];
		   my $dz = $words[6];
		   
		   my $copies = $words[7];
	
	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe2_sphere_copy_translate output:\n";
	close(fh1);	
	
	for(my $k = 0; $k < $copies; $k++) {
		my $new_x = $x0 + $dx * $k;
		my $new_y = $y0 + $dy * $k;
		my $new_z = $z0 + $dz * $k;
		my $new_grid = new_grid();
		
	    open(fh1, ">>", $mesh_file) or die $!;		
	    printf fh1 "GRID,%d,0,%g,%g,%g,0\n",$new_grid,$new_x,$new_y,$new_z;
	    close(fh1);
    }	

}

sub grid_copy_rotate {
	
	       my @words = split /,/,@_[0];
    	   (my $x, my $y, my $z) = ($words[1], $words[2], $words[3]);
		   (my $x0, my $y0, my $z0) = ($words[4], $words[5], $words[6]);
		   (my $nx, my $ny, my $nz) = ($words[7], $words[8], $words[9]);
		   my $copies = $words[10];
		   
           my $new_grid = &new_grid();      

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_copy_rotate output:\n";
	my $alpha = 2. * pi / $copies;
    
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
	
	for(my $k = 0; $k < $copies; $k++) {
		my $angle = $alpha * $k;
		(my $new_x, my $new_y, my $new_z) = &rotate_rodrig_formula("$x,$y,$z,$x0,$y0,$z0,$nx,$ny,$nz,$angle");
		printf fh1 "GRID,%d,0,%g,%g,%g,0\n",$new_grid++,$new_x,$new_y,$new_z;
    }	
    close(fh1);	
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

sub rotate_rodrig_formula{
    my $new_x;
	my $new_y;
	my $new_z;
	
	my @words = split /,/,@_[0];
	(my $x, my $y, my $z) = ($words[0], $words[1], $words[2]);
	(my $x0, my $y0, my $z0) = ($words[3], $words[4], $words[5]);
	(my $nx, my $ny, my $nz) = ($words[6], $words[7], $words[8]);
    my $alpha = $words[9];
	
	(my $rx, my $ry, my $rz) = ($x - $x0, $y - $y0, $z - $z0);
	
	(my $vx, my $vy, my $vz) = &cross_product("$nx,$ny,$nz","$rx,$ry,$rz");	
#	print "$rx, $ry, $rz\n";
#	print "$vx, $vy, $vz\n";
#	print "$nx, $ny, $nz\n";
	
    (my $new_x1, my $new_y1, my $new_z1) = &scalar_vector_product("$rx,$ry,$rz",cos($alpha));
	$new_x += $new_x1;
	$new_y += $new_y1;
	$new_z += $new_z1;
	
    ($new_x1, $new_y1, $new_z1) = &scalar_vector_product("$nx,$ny,$nz",(1.-cos($alpha)) * &dot_product("$nx,$ny,$nz","$rx,$ry,$rz"));
	$new_x += $new_x1;
	$new_y += $new_y1;
	$new_z += $new_z1;

    ($new_x1, $new_y1, $new_z1) = &scalar_vector_product("$vx,$vy,$vz",sin($alpha));
	$new_x += $new_x1;
	$new_y += $new_y1;
	$new_z += $new_z1;

	#print "$x0, $y0, $z0\n";
    #print "$new_x, $new_y, $new_z\n";
	#print "$rx, $ry, $rz\n";	
	
    ($new_x + $x0, $new_y + $y0, $new_z + $z0);	
}

sub new_grid{
	
	open(fh1, '<', $mesh_file) or die $!;
	my $new_grid;
	
	 while (<fh1>) {
		my @words = split /,/,$_;
        if ($words[0] =~ /GRID/){
			if ($new_grid < $words[1]) {
				$new_grid = $words[1];
			}	
		}	
	 }
	close(fh1);
	++$new_grid;
}

sub within{
    ((@_[1] <= @_[0]) && (@_[0] <= @_[2]))
 }
 
sub within_cone{
	
    my @point = split /,/,@_[0];
	my  @cone = split /,/,@_[1];

    my $x = $point[0];
    my $y = $point[1];
    my $z = $point[2];

    my $x0 = $cone[0];
    my $y0 = $cone[1];
    my $z0 = $cone[2];
    my  $h = $cone[3];
    my $R0 = $cone[4];
	
	my $nx = $cone[5];
	my $ny = $cone[6];
	my $nz = $cone[7];
	
	my $alpha = atan2($R0,$h);
	
	my $t = ($x - $x0) * $nx + ($y - $y0) * $ny + ($z - $z0) * $nz;
	my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
	
   (abs($t) <= $h) && ( abs($t) >= $distance * cos($alpha)); 
}


sub within_cylinder{
	
    my @point = split /,/,@_[0];
	my  @cone = split /,/,@_[1];

    my $x = $point[0];
    my $y = $point[1];
    my $z = $point[2];

    my $x0 = $cone[0];
    my $y0 = $cone[1];
    my $z0 = $cone[2];
    my  $h = $cone[3];
    my $R0 = $cone[4];
	
	my $nx = $cone[5];
	my $ny = $cone[6];
	my $nz = $cone[7];
	
	my $alpha = atan2($R0,$h);
	
	my $t = ($x - $x0) * $nx + ($y - $y0) * $ny + ($z - $z0) * $nz;
	my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
	
   ($distance**2 - $t**2 <= $R0**2) && (abs($t) <= $h) ; 
}


sub within_plane{
##	my $point = "$x,$y,$z,";
##  my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 			
	(my $x, my $y, my $z) = split /,/,@_[0];
	(my $x0, my $y0, my $z0, my $nx, my $ny, my $nz) = split /,/,@_[1];
	abs( ($x-$x0) * $nx + ($y-$y0) * $ny +($z-$z0) * $nz ) < $error;
}