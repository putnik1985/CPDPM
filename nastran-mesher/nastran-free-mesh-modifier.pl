use strict;
use autodie;

use Math::Trig;
use Cwd qw(getcwd);

    print "\n";
###usage: perl nastran-free-mesh-modifier.pl file_where_mesh file_where_commands scale_factor_for_length
	my $mesh_file = $ARGV[0];
    my $command_file = $ARGV[1];
	###my $scale = $ARGV[2];
	
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
	
	
##	printf "command file: %12s\n",$command_file;
##	printf "  input file: %12s\n", $mesh_file;
##	printf "\n";

	my %file_grids;
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
            if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP|CBEAM/){
			    if ($next_element < $words[1]) {
				    $next_element = $words[1];
			    }

            if ($words[0] =~ /[sS][pP][cC]/){
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
	
	##my $test_str = sprintf "stat: %d,%d,%d,%d\n",$next_element,$next_grid,$next_material,$next_property;
	##print $test_str;
	
	open(fh, '<', $command_file) or die $!;
	my %commands;
	
	while (<fh>) {
	   ###print $_;	
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
           print "\$_grid_rbe2_cylinder completed\n";		   
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
           print "\$_grid_rbe2_contact completed\n";		   
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

	   if ($words[0] =~ /^_grid_rbe3_plane$/) {
		   ####print $_;
	       grid_rbe3_plane($_); 
           print "_grid_rbe3_plane completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_inf_rivet$/) {
		   ####print $_;
	       grid_inf_rivet($_); 
           print "_grid_inf_rivet completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_plane$/) {
		   ####print $_;
	       grid_rbe2_plane($_); 
           print "_grid_rbe2_plane completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_radius$/) {
		   ####print $_;
	       grid_rbe2_radius($_); 
           print "\$_grid_rbe2_radius completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_contact_cylinder_rotate$/) {
		   ####print $_;
	       grid_rbe2_contact_cylinder_rotate($_); 
           print "_grid_rbe2_contact_cylinder_rotate completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_bolt$/) {
		   ####print $_;
	       grid_bolt($_); 
           print "_grid_bolt completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_bolt_rotate$/) {
		   ####print $_;
	       grid_bolt_rotate($_); 
           print "_grid_bolt_rotate completed\n";		   
       }		   

	   if ($words[0] =~ /^_msc_nastran_solution$/) {
		   ####print $_;
	       msc_nastran_solution($_); 
           print "_msc_nastran_solution completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_translate$/) {
		   ####print $_;
	       grid_translate($_); 
           print "_grid_translate completed\n";		   
       }		   

	   if ($words[0] =~ /^_mesh_combine$/) {
		   ####print $_;
	       mesh_combine($_); 
           print "_mesh_combine completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rotate$/) {
		   ####print $_;
	       grid_rotate($_); 
           print "_grid_rotate completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_create_rbe2_from_list$/) {
		   ####print $_;
	       grid_create_rbe2_from_list($_); 
           print "\$_grid_create_rbe2_from_list completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_create_pin_rbe2_from_list$/) {
		   ####print $_;
	       grid_create_pin_rbe2_from_list($_); 
           print "\$_grid_create_pin_rbe2_from_list completed\n";		   
       }		   


	   if ($words[0] =~ /^_grid_modify_from_list$/) {
		   ####print $_;
	       grid_modify_from_list($_); 
           print "_grid_modify_from_list completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_bolt_translate$/) {
		   ####print $_;
	       grid_bolt_translate($_); 
           print "_grid_bolt_translate completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_create_rbe3_from_grid_and_list$/) {
		   ####print $_;
	       grid_create_rbe3_from_grid_and_list($_); 
           print "_grid_create_rbe3_from_grid_and_list completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_cylinder_master_from_list$/) {
		   ####print $_;
	       grid_rbe2_cylinder_master_from_list($_); 
           print "\$_grid_rbe2_cylinder_master_from_list completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_translate_enclosed_volume_file$/) {
		   ###print $_;
	       grid_translate_enclosed_volume_file($_); 
           print "_grid_translate_enclosed_volume_file completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_constraints_file$/) {
		   ###print $_;
	       grid_constraints_file($_); 
           print "\$_grid_constraints_file completed\n";		   
       }

	   if ($words[0] =~ /^_grid_rbe2_sphere_master_from_list$/) {
		   ####print $_;
	       grid_rbe2_sphere_master_from_list($_); 
           print "\$_grid_rbe2_sphere_master_from_list completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_rbe2_cylinder_points_master_from_list$/) {
		   ####print $_;
	       grid_rbe2_cylinder_points_master_from_list($_); 
           print "\$_grid_rbe2_cylinder_points_master_from_list completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_link_grid_to_set$/) {
		   ####print $_;
	       grid_link_grid_to_set($_); 
           print "\$_grid_link_grid_to_set completed\n";		   
       }		   
	   
	   if ($words[0] =~ /^_grid_link_grid_to_grid$/) {
		   ####print $_;
	       grid_link_grid_to_grid($_); 
           print "\$_grid_link_grid_to_grid completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_link_set_to_set$/) {
		   ####print $_;
	       grid_link_set_to_set($_); 
           print "\$_grid_link_set_to_set completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_create_rbe2$/) {
		   ####print $_;
	       grid_create_rbe2($_); 
           print "\$_grid_create_rbe2 completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_create_cbush$/) {
		   ####print $_;
	       grid_create_cbush($_); 
           print "\$_grid_create_cbush completed\n";		   
       }		   

	   if ($words[0] =~ /^_grid_strut_set_to_set$/) {
		   ####print $_;
	       grid_strut_set_to_set($_); 
           print "\$_grid_strut_set_to_set completed\n";		   
       }		   

	}
	close(fh);

    if ($grids_modified){
	my ( $file, $ext) = split/\./,$mesh_file;
	open(outh, '>', "$file-MODIFIED.dat") or die $!;
          foreach my $str (values %file_grids){
	        printf outh "%s",$str;			
	      }
	      open(fh1, '<', $mesh_file) or die $!;
	           while (<fh1>) {
		              my @words = split /,/,$_;
                      if ($words[0] =~ /[^GRID]/){
                          printf outh "%s",$_;
                      }				
		        }	
	      close(fh1);
    close(outh);
    }
   

    if ($file_update){
        for (@file_lines){
		     print $_;
		}
    }
sub grid_create_cbush {
	
	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my ($kx, $ky, $kz, $rx, $ry, $rz) = ($words[2], $words[3],$words[4],$words[5],$words[6],$words[7]);

	       my @grid_pairs = &read_labels($list);

           my $output_str = sprintf "\n\$_grid_create_cbush output:\n";
           push(@file_lines, $output_str);
           for (my $i = 0; $i < @grid_pairs; $i+=2) {
        	##print @grid_pairs[$i] . "," . @grid_pairs[$i+1];
			##print "\n";
			my $grid1 = @grid_pairs[$i];
			my $grid2 = @grid_pairs[$i+1];
			
         	$output_str = sprintf "CBUSH,$next_element,$next_property,$grid1,$grid2,,,,0,\n";
        	push(@file_lines, $output_str);
			$next_element++;
           }
         	$output_str = sprintf "PBUSH,$next_property,K,$kx,$ky,$kz,$rx,$ry,$rz,\n";
        	push(@file_lines, $output_str);
           $next_property++;
           $file_update = 1;
}

sub read_labels{
	
my $list = @_[0]; ## read filename
my @grids;
           open(gridsh, "<", $list) or die $!;
		   my @grids;
		   
	       while (<gridsh>) {
		   if ($_ =~ /Label|label/){
				 $_ =~ s/^\s+|\s+$//g; ## remove leading and trailing spaces
				 my @words = split/\s+/,$_;
				 ##print "\n";
				 ##print $words[1]."\n";
                 push(@grids,$words[1]);
			 }
		    }
	       close(gridsh);
		   ##print "read labels:\n";
		   ##print @grids;
		   ##print "\n";
		   return @grids;
}

sub cg_from_list{
	
my $list = @_[0]; ## read filename
my @grids;
           open(gridsh, "<", $list) or die $!;
           my $count = 0;
           my $x0;
           my $y0;
           my $z0;
		   		   
 	       while (<gridsh>) {
			 if ($_ =~ /Global coordinates/){
				 $_ =~ s/^\s+|\s+$//g; ## remove leading and trailing spaces
				 my @words = split/\s+/,$_;
                 my $x = $words[3];
				 my $y = $words[4];
				 my $z = $words[5];
				 $x0 += $x;
				 $y0 += $y;
				 $z0 += $z;
				 $count++;
			 }
		    }
			close(gridsh);
			$x0 /= $count;
			$y0 /= $count;
			$z0 /= $count;
			return($x0, $y0, $z0);
}

sub grid_create_rbe2 {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $scale = $words[2];

	       my $output_str = sprintf "\n\$_grid_create_rbe2 output:\n";
	       push(@file_lines, $output_str);
	
           my ($x0, $y0, $z0) = &cg_from_list($list);
		   $x0 *= $scale;
		   $y0 *= $scale;
		   $z0 *= $scale;

		   &grid_create_rbe2_from_list("_grid_create_rbe2_from_list,$list,$x0,$y0,$z0,");
		   $file_update = 1;
}

sub grid_strut_set_to_set {
	
	       my @words = split /,/,@_[0];
		   my $list1 = $words[1];
		   my $list2 = $words[2];
		   my $nastran_card = $words[3];
		   my $E = $words[4];
		   my $nu = $words[5];
		   my $rho = $words[6];
		   my $amount = $words[7];
		   my $scale = $words[8];
		   
		   $nastran_card =~ s/;/,/g;
           my @commands = split/\\n/,$nastran_card;
           my ($x0, $y0, $z0) = &cg_from_list($list1);
           my ($x1, $y1, $z1) = &cg_from_list($list2);
		   
			$x0 *= $scale;
			$y0 *= $scale;
			$z0 *= $scale;

			$x1 *= $scale;
			$y1 *= $scale;
			$z1 *= $scale;
			
    my $nx = $x1 - $x0;
    my $ny = $y1 - $y0;
    my $nz = $z1 - $z0;	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	my $ds = $mag / $amount;
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
    my ($rx, $ry, $rz) = &vector_normal($nx, $ny, $nz);
	
    &grid_create_rbe2_from_list("_grid_create_rbe2_from_list,$list1,$x0,$y0,$z0,");	 
    &grid_create_rbe2_from_list("_grid_create_rbe2_from_list,$list2,$x1,$y1,$z1,");
	my $grid_0 = $next_grid - 2;
	my $grid_1 = $next_grid - 1;
	
	my $output_str = sprintf "\n\$_grid_strut_set_to_set output:\n";
	push(@file_lines, $output_str);	
	
	my $first = $grid_0;
	my $second;
	for (my $current = 1; $current < $amount; ++$current){
		    $x0 += $ds * $nx;
		    $y0 += $ds * $ny;
		    $z0 += $ds * $nz;
			$output_str = sprintf "GRID,%d,0,%g,%g,%g,0\n",$next_grid,$x0,$y0,$z0;
	        push(@file_lines, $output_str);
			$second = $next_grid;
			$next_grid++;
            $output_str = sprintf "CBAR,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property,$first,$second,$rx,$ry,$rz;
            push(@file_lines, $output_str);
			$next_element++;
			$first = $second;
	}

            $output_str = sprintf "CBAR,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property,$first,$grid_1,$rx,$ry,$rz;
            push(@file_lines, $output_str);
			$next_element++;
	
	        for (@commands) {
				 $_ =~ s/prop/$next_property/g;
				 $_ =~ s/mat/$next_material/g;
	    	     push(@file_lines, $_);
				 push(@file_lines,"\n");
			}	

	        $output_str = sprintf "MAT1,%d,%.2E,,%.4f,%.4g,\n",$next_material,$E,$nu,$rho;
	        push(@file_lines, $output_str);
	$next_element++;
	$next_property++;
	$next_material++;
	$file_update = 1;
}

sub grid_link_set_to_set {
	
	       my @words = split /,/,@_[0];
		   my $list1 = $words[1];
		   my $list2 = $words[2];
		   my $bolt_radius = $words[3];
		   my $scale = $words[4];
 
           my ($x0, $y0, $z0) = &cg_from_list($list1);
           my ($x1, $y1, $z1) = &cg_from_list($list2);
		   
			$x0 *= $scale;
			$y0 *= $scale;
			$z0 *= $scale;

			$x1 *= $scale;
			$y1 *= $scale;
			$z1 *= $scale;
			
    my $nx = $x1 - $x0;
    my $ny = $y1 - $y0;
    my $nz = $z1 - $z0;	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
	
    &grid_create_rbe2_from_list("_grid_create_rbe2_from_list,$list1,$x0,$y0,$z0,");	 
    &grid_create_rbe2_from_list("_grid_create_rbe2_from_list,$list2,$x1,$y1,$z1,");
	
	my $first_grid =  $next_grid - 2;
    my $second_grid = $next_grid - 1;

    my ($rx, $ry, $rz) = &vector_normal($nx, $ny, $nz);	
	
	my $output_str = sprintf "\n\$_grid_link_grid_to_set output:\n";
	push(@file_lines, $output_str);
	
    $output_str = sprintf "CBEAM,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property,$first_grid,$second_grid,$rx,$ry,$rz;
    push(@file_lines, $output_str);
	
	$output_str = sprintf "PBEAML,%d,%d,MSCBML0,ROD,,,,,+\n",$next_property,$next_material;
	push(@file_lines, $output_str);
	
	$output_str = sprintf "+,%.4f,0.0,YES,1.0,%.4f,0.0,\n",$bolt_radius,$bolt_radius;
	push(@file_lines, $output_str);
	
	my   $E = 6.83E+10;
	my  $nu = 0.33;
	my $rho = 2848.23;
	
	$output_str = sprintf "MAT1,%d,%.2E,,%.4f,%.4g,\n",$next_material,$E,$nu,$rho;
	push(@file_lines, $output_str);
	
	$next_element++;
	$next_property++;
	$next_material++;
	$file_update = 1;
}

sub grid_link_grid_to_grid {
	
	       my @words = split /,/,@_[0];
		   my $first_grid = $words[1];
		   my $second_grid = $words[2];
		   my $bolt_radius = $words[3];
		   my $scale = $words[4];

	   
		   @words = split/,/,%file_grids{$first_grid};
		   my $x0 = $words[3];
		   my $y0 = $words[4];
		   my $z0 = $words[5];
		   

		   @words = split/,/,%file_grids{$second_grid};
		   my $x1 = $words[3];
		   my $y1 = $words[4];
		   my $z1 = $words[5];		   

	
    my $nx = $x1 - $x0;
    my $ny = $y1 - $y0;
    my $nz = $z1 - $z0;	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
    my ($rx, $ry, $rz) = &vector_normal($nx, $ny, $nz);	
	
	my $output_str = sprintf "\n\$_grid_link_grid_to_grid output:\n";
	push(@file_lines, $output_str);
	
    $output_str = sprintf "CBEAM,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property,$first_grid,$second_grid,$rx,$ry,$rz;
    push(@file_lines, $output_str);
	
	$output_str = sprintf "PBEAML,%d,%d,MSCBML0,ROD,,,,,+\n",$next_property,$next_material;
	push(@file_lines, $output_str);
	$output_str = sprintf "+,%.4f,0.0,YES,1.0,%.4f,0.0,\n",$bolt_radius,$bolt_radius;
	push(@file_lines, $output_str);
	
	my   $E = 6.83E+10;
	my  $nu = 0.33;
	my $rho = 2848.23;
	$output_str = sprintf "MAT1,%d,%.2E,,%.4f,%.4g,\n",$next_material,$E,$nu,$rho;
	push(@file_lines, $output_str);
	$next_element++;
	$next_property++;
	$next_material++;
	$file_update = 1;
}

sub grid_link_grid_to_set {
	
	       my @words = split /,/,@_[0];
		   my $fem_grid = $words[1];
		   my $list = $words[2];
		   my $bolt_radius = $words[3];
		   my $scale = $words[4];

           open(gridsh, "<", $list) or die $!;
           my $count = 0;
           my $x0;
           my $y0;
           my $z0;
		   
		   my @words = split/\s+/,%file_grids{$fem_grid};
		   my $x1 = $words[3];
		   my $y1 = $words[4];
		   my $z1 = $words[5];		   
		   
 	       while (<gridsh>) {
			 if ($_ =~ /Global coordinates/){
				 $_ =~ s/^\s+|\s+$//g; ## remove leading and trailing spaces
				 my @words = split/\s+/,$_;
                 my $x = $words[3];
				 my $y = $words[4];
				 my $z = $words[5];
				 $x0 += $x;
				 $y0 += $y;
				 $z0 += $z;
				 $count++;
			 }
		    }
			$x0 /= $count;
			$y0 /= $count;
			$z0 /= $count;
			
			$x0 *= $scale;
			$y0 *= $scale;
			$z0 *= $scale;
			
		   ##print("$x_min,$y_min,$z_min\n");
		   ##print("$x_max,$y_max,$z_max\n");
	       close(gridsh);
    my $nx = $x1 - $x0;
    my $ny = $y1 - $y0;
    my $nz = $z1 - $z0;	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
    &grid_create_rbe2_from_list("_grid_create_rbe2_from_list,$list,$x0,$y0,$z0,");	 

	my $first_grid =  $fem_grid;
    my $second_grid = $next_grid - 1;

    my ($rx, $ry, $rz) = &vector_normal($nx, $ny, $nz);	
	
	my $output_str = sprintf "\n\$_grid_link_grid_to_set output:\n";
	push(@file_lines, $output_str);
	
    $output_str = sprintf "CBEAM,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property,$first_grid,$second_grid,$rx,$ry,$rz;
    push(@file_lines, $output_str);
	
	$output_str = sprintf "PBEAML,%d,%d,MSCBML0,ROD,,,,,+\n",$next_property,$next_material;
	push(@file_lines, $output_str);
	$output_str = sprintf "+,%.4f,0.0,YES,1.0,%.4f,0.0,\n",$bolt_radius,$bolt_radius;
	push(@file_lines, $output_str);
	
	my   $E = 6.83E+10;
	my  $nu = 0.33;
	my $rho = 2848.23;
	$output_str = sprintf "MAT1,%d,%.2E,,%.4f,%.4g,\n",$next_material,$E,$nu,$rho;
	push(@file_lines, $output_str);
	$next_element++;
	$next_property++;
	$next_material++;
	$file_update = 1;
}

sub grid_constraints_file {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $dofs = $words[2];

           my @grids_to_constraint = &read_labels($list);
		   ####print "list from file $list\n";
           ####print @grids_to_constraint;
           ####print "\n";
		   
	       my $line_to_file;
           $line_to_file = "\n\$grid_spc_plane output:\n";
           push(@file_lines, $line_to_file);
		  
	    for (@grids_to_constraint) {
	 	     $line_to_file = sprintf "SPC,$next_spc,$_,$dofs,\n";
             push(@file_lines,$line_to_file);
	    }
        $file_update = 1;
		$next_spc++;
}


sub grid_translate_enclosed_volume_file {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my ($dx, $dy, $dz) = ($words[2], $words[3], $words[4]);
		   
		   my $x_min = $unreal_number;
		   my $x_max = -$unreal_number;
		   
		   my $y_min = $unreal_number;
		   my $y_max = -$unreal_number;

		   my $z_min = $unreal_number;
		   my $z_max = -$unreal_number;
		   
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 if ($_ =~ /Global coordinates/){
				 $_ =~ s/^\s+|\s+$//g; ## remove leading and trailing spaces
				 my @words = split/\s+/,$_;
                 my $x = $words[3];
				 my $y = $words[4];
				 my $z = $words[5];
				 
				 if ($x < $x_min){
					 $x_min = $x;
				 }

				 if ($y < $y_min){
					 $y_min = $y;
				 }

				 if ($z < $z_min){
					 $z_min = $z;
				 }

				 if ($x > $x_max){
					 $x_max = $x;
				 }

				 if ($y > $y_max){
					 $y_max = $y;
				 }

				 if ($z > $z_max){
					 $z_max = $z;
				 }

			 }
		    }
		   ##print("$x_min,$y_min,$z_min\n");
		   ##print("$x_max,$y_max,$z_max\n");
	       close(gridsh);
		   
           $x_min -= $tolerance;
		   $x_max += $tolerance;
		   
		   $y_min -= $tolerance;
		   $y_max += $tolerance;
		   
		   $z_min -= $tolerance;
		   $z_max += $tolerance;
		
        
		for(my $NR = 0; $NR <  @file_lines; ++$NR){
		    my @words = split /,/,$file_lines[$NR];
			if ($words[0] =~ /GRID/){
		        my $x = $words[3];
		        my $y = $words[4];
		        my $z = $words[5];
                if (&within($x,$x_min,$x_max) && &within($y,$y_min,$y_max) && &within($z,$z_min,$z_max)){
        	        (my $new_x, my $new_y, my $new_z) = ($x + $dx, $y + $dy, $z + $dz);
					$words[3] = $new_x;
					$words[4] = $new_y;
					$words[5] = $new_z;
					$file_lines[$NR] = join(",",@words);
                }
			}
		}
				
    $file_update = 1;
}

sub grid_rbe2_sphere_master_from_list {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $radius = $words[2];

  
           my @master_grids;
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 my @words = split / /,$_;
			 if ($words[0] =~ /Label|label/){
                 push(@master_grids,$words[1]);
			 }
		    }
	       close(gridsh);
		   
    ############print @grids;
    my $output_str;
 	$output_str = sprintf "\n\$ @_[0] \n";
    push(@file_lines,$output_str);	
	$output_str = sprintf "\n\$_grid_rbe2_sphere_master_from_list:\n";
    push(@file_lines,$output_str);
		
	for (@master_grids){

		my $current_grid = $_;
		my @words = split/,/,$file_grids{$current_grid};
		my ($x0, $y0, $z0) = ($words[3], $words[4], $words[5]);
		
		my @grids;
		while (my ($key, $value) = each %file_grids){
			my @list = split/,/,$value;
			my ($x, $y, $z) = ($list[3], $list[4], $list[5]);
		    my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
            if ($distance < $radius){
                if ($current_grid != $key) {
				    push(@grids, $key);
				}
            }				
		}
		
		##create RBE2
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
	
	$output_str = sprintf "\n";
	push(@file_lines, $output_str);
	
	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element++,$current_grid;
    push(@file_lines, $output_str);
	
	for(my $k = 0; $k < $last; $k++) {
			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@file_lines, $output_str);
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@file_lines, $output_str);
		        $output_str = sprintf "+,";
				push(@file_lines, $output_str);
		        $output_str = sprintf "%d,",$grids[$k];
                push(@file_lines, $output_str);				
                $current_field = 3; 				
            }				
	}
	}
	$file_update = 1;
}
sub grid_rbe2_cylinder_points_master_from_list {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $radius = $words[2];
		   my $h = $words[3];
		   my ($x0, $y0, $z0) = ($words[4], $words[5], $words[6]);
		   my ($x1, $y1, $z1) = ($words[7], $words[8], $words[9]);
		   my ($x2, $y2, $z2) = ($words[10], $words[11], $words[12]);
		   my @u = ($x1 - $x0, $y1 - $y0, $z1 - $z0);
		   my @v = ($x2 - $x0, $y2 - $y0, $z2 - $z0);

		   my $nx = $u[1] * $v[2] - $v[1] * $u[2];
		   my $ny = $u[2] * $v[0] - $v[2] * $u[0];
		   my $nz = $u[0] * $v[1] - $v[0] * $u[1];
		   
           my @master_grids;
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 my @words = split / /,$_;
			 if ($words[0] =~ /Label|label/){
                 push(@master_grids,$words[1]);
			 }
		    }
	       close(gridsh);
		   
    ############print @grids;
    my $output_str;
 	$output_str = sprintf "\n\$ @_[0] \n";
    push(@file_lines,$output_str);	
	$output_str = sprintf "\n\$_grid_rbe2_cylinder_master_from_list:\n";
    push(@file_lines,$output_str);
		
	for (@master_grids){

		my $current_grid = $_;
		my @words = split/,/,$file_grids{$current_grid};
		my ($x0, $y0, $z0) = ($words[3], $words[4], $words[5]);
		
		my @grids;
		while (my ($key, $value) = each %file_grids){
			my @list = split/,/,$value;
			my ($x, $y, $z) = ($list[3], $list[4], $list[5]);
		    my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cylinder($point, $cone)){
                if ($current_grid != $key) {
				    push(@grids, $key);
				}
            }				
		}
		
		##create RBE2
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
	
	$output_str = sprintf "\n";
	push(@file_lines, $output_str);
	
	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element++,$current_grid;
    push(@file_lines, $output_str);
	
	for(my $k = 0; $k < $last; $k++) {
			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@file_lines, $output_str);
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@file_lines, $output_str);
		        $output_str = sprintf "+,";
				push(@file_lines, $output_str);
		        $output_str = sprintf "%d,",$grids[$k];
                push(@file_lines, $output_str);				
                $current_field = 3; 				
            }				
	}
	}
	$file_update = 1;
}


sub grid_rbe2_cylinder_master_from_list {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $radius = $words[2];
		   my $h = $words[3];
		   my ($nx, $ny, $nz) = ($words[4], $words[5], $words[6]);
  
           my @master_grids;
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 my @words = split / /,$_;
			 if ($words[0] =~ /Label|label/){
                 push(@master_grids,$words[1]);
			 }
		    }
	       close(gridsh);
		   
    ############print @grids;
    my $output_str;
 	$output_str = sprintf "\n\$ @_[0] \n";
    push(@file_lines,$output_str);	
	$output_str = sprintf "\n\$_grid_rbe2_cylinder_master_from_list:\n";
    push(@file_lines,$output_str);
		
	for (@master_grids){

		my $current_grid = $_;
		my @words = split/,/,$file_grids{$current_grid};
		my ($x0, $y0, $z0) = ($words[3], $words[4], $words[5]);
		
		my @grids;
		while (my ($key, $value) = each %file_grids){
			my @list = split/,/,$value;
			my ($x, $y, $z) = ($list[3], $list[4], $list[5]);
		    my $point = "$x,$y,$z,";
            my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
            if (within_cylinder($point, $cone)){
                if ($current_grid != $key) {
				    push(@grids, $key);
				}
            }				
		}
		
		##create RBE2
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
	
	$output_str = sprintf "\n";
	push(@file_lines, $output_str);
	
	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element++,$current_grid;
    push(@file_lines, $output_str);
	
	for(my $k = 0; $k < $last; $k++) {
			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@file_lines, $output_str);
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@file_lines, $output_str);
		        $output_str = sprintf "+,";
				push(@file_lines, $output_str);
		        $output_str = sprintf "%d,",$grids[$k];
                push(@file_lines, $output_str);				
                $current_field = 3; 				
            }				
	}
	}
	$file_update = 1;
}


sub grid_create_rbe3_from_grid_and_list {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $new_grid = $words[2];
  
           my @grids;
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 my @words = split / /,$_;
			 if ($words[0] =~ /Label|label/){
                 push(@grids,$words[1]);
			 }
		    }
	       close(gridsh);
	
	open(h1, ">>", $mesh_file) or die $!;
	print h1 "\n\$_grid_create_rbe3_from_grid_and_list output:\n";
    my $current_field = 8;
	my $current = 0;
	my $last = @grids;
    
   (my $max_grid, my $max_elem, my $max_property, my $max_material) = &mesh_stat();
	my $new_eid = $max_elem + 1;

	printf h1 "RBE3,%d,,%d,123456,1.0,123,",$new_eid,$new_grid;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe3_fields) {
		        printf h1 "%d,",$grids[$k];
				++$current_field;
			} else {
		        printf h1 "+\n";
		        printf h1 "+,";
		        printf h1 "%d,",$grids[$k];				
                $current_field = 3; 				
            }
    }	
    close(h1);		
}

sub grid_bolt_translate {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];

		   my $x1 = $words[4];
		   my $y1 = $words[5];
		   my $z1 = $words[6];

		   my $nx = $words[7];
		   my $ny = $words[8];
		   my $nz = $words[9];

           my $h = $words[10];
           my $thread_radius = $words[11];
	   
	       my $head_radius = $words[12];
	       my $bolt_radius = $words[13];
		   
		   my $dx = $words[14];
		   my $dy = $words[15];
		   my $dz = $words[16];
		   
		   my $copies = $words[17];
     
	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$ @_[0] \n";	
	print fh1 "\n\$_grid_bolt_translate output:\n";
    close(fh1);    
	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
	
	for(my $k = 0; $k < $copies; $k++) {
		(my $new_x0, my $new_y0, my $new_z0) = ($x0 + $k * $dx, $y0 + $k * $dy, $z0 + $k * $dz);
		(my $new_x1, my $new_y1, my $new_z1) = ($x1 + $k * $dx, $y1 + $k * $dy, $z1 + $k * $dz);		
		my $command="_grid_bolt,$new_x0,$new_y0,$new_z0,$new_x1,$new_y1,$new_z1,$nx,$ny,$nz,$h,$thread_radius,$head_radius,$bolt_radius,";
		&grid_bolt($command);
    }
	
}
	
sub grid_modify_from_list {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $x0 = $words[2];
		   my $y0 = $words[3];
		   my $z0 = $words[4];

           my @grids;
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 my @words = split / /,$_;
			 if ($words[0] =~ /Label|label/){
                 push(@grids,$words[1]);
			 }
		    }
	       close(gridsh);


    for (@grids){
		    
			my @words = split/,/,$file_grids{$_};
			if ($x0 != '') { $words[3] = $x0;};
			if ($y0 != '') { $words[4] = $y0;};
			if ($z0 != '') { $words[5] = $z0;};
			
			my $str = join(",",@words);
			$file_grids{$_} = $str;

	}

    $grids_modified = 1;
}

sub grid_create_pin_rbe2_from_list {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $x0 = $words[2];
		   my $y0 = $words[3];
		   my $z0 = $words[4];
  
           my @grids;
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 my @words = split / /,$_;
			 if ($words[0] =~ /Label|label/){
                 push(@grids,$words[1]);
			 }
		    }
	       close(gridsh);
    ############print @grids;
	open(h1, ">>", $mesh_file) or die $!;

	my $output_str = sprintf "\n\$_grid_create_rbe2_from_list:\n";
	push(@file_lines,$output_str);

    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
    

	$output_str = sprintf "GRID,%d,0,%g,%g,%g,0\n",$next_grid,$x0,$y0,$z0;
	push(@file_lines, $output_str);
	
	$output_str = sprintf "RBE2,%d,%d,123,",$next_element,$next_grid;
	push(@file_lines, $output_str);
	$next_grid++;
	$next_element++;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@file_lines, $output_str);
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@file_lines, $output_str);
		        $output_str = sprintf "+,";
				push(@file_lines, $output_str);
		        $output_str = sprintf "%d,",$grids[$k];				
				push(@file_lines, $output_str);
                $current_field = 3; 				
            }

    }
}


sub grid_create_rbe2_from_list {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $x0 = $words[2];
		   my $y0 = $words[3];
		   my $z0 = $words[4];
  
           my @grids;
           open(gridsh, "<", $list) or die $!;
	       while (<gridsh>) {
			 my @words = split / /,$_;
			 if ($words[0] =~ /Label|label/){
                 push(@grids,$words[1]);
			 }
		    }
	       close(gridsh);
    ############print @grids;
	open(h1, ">>", $mesh_file) or die $!;

	my $output_str = sprintf "\n\$_grid_create_rbe2_from_list:\n";
	push(@file_lines,$output_str);

    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
    

	$output_str = sprintf "GRID,%d,0,%g,%g,%g,0\n",$next_grid,$x0,$y0,$z0;
	push(@file_lines, $output_str);
	
	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element,$next_grid;
	push(@file_lines, $output_str);
	$next_grid++;
	$next_element++;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@file_lines, $output_str);
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@file_lines, $output_str);
		        $output_str = sprintf "+,";
				push(@file_lines, $output_str);
		        $output_str = sprintf "%d,",$grids[$k];				
				push(@file_lines, $output_str);
                $current_field = 3; 				
            }

    }
}

sub grid_rotate {

	       my @words = split /,/,@_[0];
		   my $rot_x = $words[1];
		   my $rot_y = $words[2];
		   my $rot_z = $words[3];
		   my $nx = $words[4];
		   my $ny = $words[5];
		   my $nz = $words[6];
		   my $angle = $words[7];
		   
		   $angle *= pi / 180.;
		   my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
		   $nx /= $mag;
		   $ny /= $mag;
		   $nz /= $mag;
	
		
		while (my ($key, $value) = each %file_grids){
		       my @words = split /,/,$value;
		       my $x0 = $words[3];
		       my $y0 = $words[4];
		       my $z0 = $words[5];

        	  (my $new_x, my $new_y, my $new_z) = &rotate_rodrig_formula("$x0,$y0,$z0,$rot_x,$rot_y,$rot_z,$nx,$ny,$nz,$angle");

                $words[3] = $new_x;
                $words[4] = $new_y;
                $words[5] = $new_z;	
				my $str = join(",",@words);

				$file_grids{$key} = $str;
		}	
    $grids_modified = 1;
}

sub file_mesh_stat {
	
	my $filename = @_[0];
	open(fh1, '<', $filename) or die $!;
	
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
	my $max_material = 1;
	my $min_material = $unreal_number;
	my $max_property = 1;
	my $min_property = $unreal_number;

	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 

        if ($words[0] =~ /PSOLID|PBUSH|PSHELL|PBEAML|PBAR/){
		    if ($max_property < $words[1]) {
				$max_property = $words[1];
			}				

		    if ($min_property > $words[1]) {
				$min_property = $words[1];
			}				

		}

        if ($words[0] =~ /MAT1/){
		    if ($max_material < $words[1]) {
				$max_material = $words[1];
			}				

		    if ($min_material > $words[1]) {
				$min_material = $words[1];
			}				

		}


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

	print STDOUT "\n\$_mesh_stat $filename output:\n";
	print STDOUT "\$grids: $grids\n";
	print STDOUT "\$lower grid: $min_grid\n";
	print STDOUT "\$highest grid: $max_grid\n";
	print STDOUT "\n";
	print STDOUT "\$elements: $elems\n";
	print STDOUT "\$lower element: $min_elem\n";
	print STDOUT "\$highest element: $max_elem\n";
	print STDOUT "\n";
	print STDOUT "\$RBE2 element: $rbe2_eid\n";
	print STDOUT "\$RBE3 element: $rbe3_eid\n";
	print STDOUT "\$CTETRA element: $ctetra_eid\n";
	print STDOUT "\$CHEXA element: $chexa_eid\n";
	print STDOUT "\$CQUAD element: $cquad_eid\n";
	print STDOUT "\$CELAS element: $celas_eid\n";
	print STDOUT "\$CBUSH element: $cbush_eid\n";
	print STDOUT "\$GAP element: $gap_eid\n";
	
    ($min_grid,$max_grid,$min_elem,$max_elem,$min_property,$max_property,$min_material,$max_material);	
}

sub mesh_combine {

	       my @words = split /,/,@_[0];
		   my $add_file = $words[1];

           print "combine $mesh_file and $add_file\n";
		   (my $min_grid,my $max_grid, my $min_elem, my $max_elem, my $min_property, my $max_property, my $min_material, my $max_material) = &file_mesh_stat($mesh_file);
		   (my $min_grid1,my $max_grid1, my $min_elem1, my $max_elem1, my $min_property1, my $max_property1, my $min_material1, my $max_material1) = &file_mesh_stat($add_file);
		   
		   my $grid_offset = 0;
		   my $elem_offset = 0;
		   my $mat_offset = 0;
		   my $prop_offset = 0;

		   if ( $max_grid + 1 > $min_grid1) {
			    $grid_offset = $max_grid + 1 - $min_grid1;
		   }

		   if ( $max_elem + 1 > $min_elem1) {
			    $elem_offset = $max_elem + 1 - $min_elem1;
		   }

		   if ( $max_material + 1 > $min_material1) {
			    $mat_offset = $max_material + 1 - $min_material1;
		   }

		   if ( $max_property + 1 > $min_property1) {
			    $prop_offset = $max_property + 1 - $min_property1;
		   }
		   
		   (my $file1, my $ext1) = split /\./,$mesh_file;
		   (my $file2, my $ext2) = split /\./,$add_file;
		   
		   open(infile, '>', $mesh_file) or die $!;
		   open(addfile, '>', $add_file) or die $!;
		   open(combine, '>', "$file1+$file2.dat") or die $!;
		   
		        printf combine "\$file: $mesh_file\n";
				
		        while (<infile>){
					printf combine $_;
				}

		        printf combine "\$file: $add_file\n";
				
		        while (<addfile>){
		          my @words = split /,/,$_;

                     if ($words[0] =~ /PSOLID|PBUSH|PSHELL|PBEAML|PBAR/){
			         }				

                     if ($words[0] =~ /MAT1/){

               		}

                     if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP/){
             		}

                     if ($words[0] =~ /^GRID/){
		            }	

				}

		   
		   close(infile);
		   close(addfile);
		   close(combine);
		   
}

sub msc_nastran_solution{
    my @words = split /,/,@_[0];
	(my $file, my $ext) = split/\./,$mesh_file;
	my $nastran_path = $words[2];
	my $filename;
	
	if($words[1] =~ /static/){
	   $filename = $file."-sol101.nas";
	   open(newfh,">",$filename) or die $!;
	   printf newfh "
SOL 101
CEND

echo = none
DISPLACEMENT(PLOT,REAL) = ALL
load = $load_id
spc = $spc_id
mpc = $mpc_id

BEGIN BULK

\$* PARAM CARDS
PARAM     OIBULK     YES
PARAM    OMACHPR     YES
PARAM       POST      -2
PARAM    POSTEXT     YES
param,autospc,yes

\$---------------------------
\$ Solver
\$---------------------------
grav,$load_id,0,386.1,1.,1.,1.
include '$mesh_file'

ENDDATA";
	   close newfh;	   
	}
	
	if($words[1] =~ /modal/){
	   $filename = $file."-sol103.nas";
	   open(newfh,">",$filename) or die $!;
	   printf newfh "
SOL 103
CEND

echo = none
DISPLACEMENT(PLOT,REAL) = ALL
method = 100
spc = $spc_id

BEGIN BULK

\$* PARAM CARDS
PARAM     OIBULK     YES
PARAM    OMACHPR     YES
PARAM       POST      -2
PARAM    POSTEXT     YES
param,autospc,yes

\$---------------------------
\$ Solver
\$---------------------------
EIGRL,100,,,12
include '$mesh_file'

ENDDATA";
	   close newfh;
	}
	
	open(newfh,">","nastran-run.cmd") or die $!;
	     my $fullname = getcwd."/".$filename;
		 chomp($nastran_path);
		 
	     printf newfh "$nastran_path $fullname old=no news=no";
	close newfh;
	
}

sub grid_translate {

	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $x1 = $words[4];
		   my $y1 = $words[5];
		   my $z1 = $words[6];
	      (my $dx, my $dy, my $dz) = ($x1-$x0, $y1-$y0, $z1-$z0);

		while (my ($key, $value) = each %file_grids){
		       my @words = split /,/,$value;
		       my $x0 = $words[3];
		       my $y0 = $words[4];
		       my $z0 = $words[5];

        	  (my $new_x, my $new_y, my $new_z) = ($x0 + $dx, $y0 + $dy, $z0 + $dz);

                $words[3] = $new_x;
                $words[4] = $new_y;
                $words[5] = $new_z;	
				my $str = join(",",@words);

				$file_grids{$key} = $str;
		}	
    $grids_modified = 1;
}

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
	####print "$x0,$y0,$z0,$nx,$ny,$nz\n";
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
		printf fh1 "SPC,$spc_id,$_,$dofs,\n";
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
        ####print $h . "," . $radius . "\n";
		for(my $NR = 0; $NR <  @file_lines; ++$NR){
		    my @words = split /,/,$file_lines[$NR];
				
            if ($words[0] =~ /GRID/){
			    my $x = $words[3];
			    my $y = $words[4];
			    my $z = $words[5];
			    my $point = "$x,$y,$z,";
                my $cone = "$x0,$y0,$z0,$h,$radius,$nx,$ny,$nz,"; 			
                if (within_cylinder($point, $cone)){
					####print $words[1] . "," . $cone ."\n";
                    push(@grids, $words[1]);				
                }				
            }			
		}

	
	my $output_str = sprintf "\n\$_grid_rbe2_cylinder output:\n";
	push(@file_lines,$output_str);
	
    my $current_field = 5;
	my $current = 0;
	my $last = @grids;

	my $output_str = sprintf "GRID,%d,0,%g,%g,%g,0\n",$next_grid,$x0,$y0,$z0;
	push(@file_lines,$output_str);

	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element,$next_grid;
	push(@file_lines,$output_str);
    $next_element++;
	$next_grid++;
	
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@file_lines,$output_str);
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@file_lines,$output_str);
		        $output_str = sprintf "+,";
				push(@file_lines,$output_str);
		        $output_str = sprintf "%d,",$grids[$k];
                push(@file_lines,$output_str);				
                $current_field = 3; 				
            }
    }	
    $file_update = 1;	
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
	
	
		for(my $NR = 0; $NR <  @file_lines; ++$NR){
		    my @words = split /,/,$file_lines[$NR];
				
            if ($words[0] =~ /GRID/){
			  my $gr_id = $words[1];	
			  my $x = $words[3];
			  my $y = $words[4];
			  my $z = $words[5];	
              my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
			  my $point = "$x,$y,$z,";
              my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,";
              ####my $chplane = within_plane($point,$plane);			  
              ####print "$gr_id, $distance, $radius, $chplane\n";
              if ($distance < $radius && within_plane($point,$plane)){
                  push(@grids, $words[1]);				
              }				
			}
			}

	
	##print "highest eid: " . $new_eid . "\n";
	##print "closest grid: " . $closest_grid . "\n";
	##print "minimum distance: " . $min_distance . "\n";

	my $output_str = sprintf "\n\$_grid_rbe2_contact output:\n";
	push(@file_lines,$output_str);

    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
    #########print "last: $last\n";
	$output_str = sprintf "GRID,%d,0,%g,%g,%g,0\n",$next_grid,$x0,$y0,$z0;
	push(@file_lines,$output_str);
	
	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element,$next_grid;
	push(@file_lines, $output_str);

	$next_grid++;
	$next_element++;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@file_lines, $output_str);
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@file_lines, $output_str);
		        $output_str = sprintf "+,";
				push(@file_lines, $output_str);
		        $output_str = sprintf "%d,",$grids[$k];	
                push(@file_lines, $output_str);				
                $current_field = 3; 				
            }

    }	
	$file_update = 1;
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
	my $max_material = 1;
	my $max_property = 1;

	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 

        if ($words[0] =~ /PSOLID|PBUSH|PSHELL|PBEAML|PBAR/){
		    if ($max_property < $words[1]) {
				$max_property = $words[1];
			}				
		}

        if ($words[0] =~ /MAT1/){
		    if ($max_material < $words[1]) {
				$max_material = $words[1];
			}				
		}


        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP|CBEAM/){

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
	
    ($max_grid,$max_elem,$max_property,$max_material);	
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


sub grid_rbe2_plane {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $nx = $words[4];
		   my $ny = $words[5];
		   my $nz = $words[6];		   
		   
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
            my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 			
            if (within_plane($point, $plane)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe2_plane output:\n";
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

sub grid_rbe3_plane {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $nx = $words[4];
		   my $ny = $words[5];
		   my $nz = $words[6];		   
		   
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
            my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 			
            if (within_plane($point, $plane)){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe3_plane output:\n";
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

sub grid_rbe2_radius {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];
		   my $nx = $words[4];
		   my $ny = $words[5];
		   my $nz = $words[6];
           my $radius = $words[7];		   
		   
	my @grids;
	
	open(fh1, '<', $mesh_file) or die $!;
    my $new_eid;
	my $new_grid;
	
	 while (<fh1>) {
		###print $_;
		my @words = split /,/,$_;
		####print $words[1]."\n"; 
        if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP|CBEAM/){
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
            my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 
            my $dist = sqrt(($x-$x0)**2+($y-$y0)**2+($z-$z0)**2);			
            if (within_plane($point, $plane) && $dist <= $radius){
                push(@grids, $words[1]);				
            }				
        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe2_radius output:\n";
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

sub grid_bolt {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];

		   my $x1 = $words[4];
		   my $y1 = $words[5];
		   my $z1 = $words[6];

		   my $nx = $words[7];
		   my $ny = $words[8];
		   my $nz = $words[9];

           my $h = $words[10];
           my $thread_radius = $words[11];
	   
	       my $head_radius = $words[12];
	       my $bolt_radius = $words[13];
     
    &grid_rbe2_radius("_grid_rbe2_radius,$x0,$y0,$z0,$nx,$ny,$nz,$head_radius,");	 
	&grid_rbe2_cylinder("_grid_rbe2_cylinder,$x1,$y1,$z1,$h,$thread_radius,$nx,$ny,$nz,");

    my $materials;
	my $property;
	my $element;
	my $grid;
	
	($grid,$element,$property,$materials) = &mesh_stat();
	
	my $first_grid = $grid - 1;
    my $second_grid = $grid;

	open(fh1, ">>", $mesh_file) or die $!;
    ## want to find vector normal to nx, ny, nz: nx * k + ny * l + nz * m = 0.
	
    my ($rx, $ry, $rz) = &vector_normal($nx, $ny, $nz);	
	
	printf fh1 "\n\$_grid_bolt output:\n";
    printf fh1 "CBEAM,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",++$element,++$property,$first_grid,$second_grid,$rx,$ry,$rz;	
	printf fh1 "PBEAML,%d,%d,MSCBML0,ROD,,,,,+\n",$property,++$materials;
	printf fh1 "+,%.4f,0.0,YES,1.0,%.4f,0.0,\n",$bolt_radius,$bolt_radius;

	my   $E = 2.8e+7;
	my  $nu = 0.296;
	my $rho = 0.283;
	printf fh1 "MAT1,%d,%.2E,,%.4f,%.4g,\n",$materials,$E,$nu,$rho / 386.1;
	close fh1;
}

sub vector_normal{
	my $nx = @_[0];
	my $ny = @_[1];
	my $nz = @_[2];
	
	my $rx; 
	my $ry;
	my $rz;
	
	if ($nx != 0.) { 
	    $ry = 1.0; 
		$rz = 0.; 
		$rx = -$ny / $nx;
	} elsif ($ny != 0.) {
	    $rz = 1.0; 
		$rx = 0.; 
		$ry = -$nz / $ny;		
	} else {
	    $rx = 1.0; 
		$ry = 0.; 
		$rz = -$nx / $nz;		
	}
		
	my $mag = sqrt($rx**2 + $ry**2 + $rz**2);
	$rx /= $mag;
	$ry /= $mag;
	$rz /= $mag;
	($rx, $ry, $rz);
}


sub grid_bolt_rotate {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];

		   my $x1 = $words[4];
		   my $y1 = $words[5];
		   my $z1 = $words[6];

		   my $nx = $words[7];
		   my $ny = $words[8];
		   my $nz = $words[9];

           my $h = $words[10];
           my $thread_radius = $words[11];
	   
	       my $head_radius = $words[12];
	       my $bolt_radius = $words[13];
		   
		   my $rot_x = $words[14];
		   my $rot_y = $words[15];
		   my $rot_z = $words[16];
		   
		   my $copies = $words[17];
     
	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_bolt_rotate output:\n";
	my $alpha = 2. * pi / $copies;
    close(fh1);    
	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
	
	for(my $k = 0; $k < $copies; $k++) {
		my $angle = $alpha * $k;
		(my $new_x0, my $new_y0, my $new_z0) = &rotate_rodrig_formula("$x0,$y0,$z0,$rot_x,$rot_y,$rot_z,$nx,$ny,$nz,$angle");
		(my $new_x1, my $new_y1, my $new_z1) = &rotate_rodrig_formula("$x1,$y1,$z1,$rot_x,$rot_y,$rot_z,$nx,$ny,$nz,$angle");		
		my $command="_grid_bolt,$new_x0,$new_y0,$new_z0,$new_x1,$new_y1,$new_z1,$nx,$ny,$nz,$h,$thread_radius,$head_radius,$bolt_radius,";
		&grid_bolt($command);
    }
	
}

sub grid_inf_rivet {
	
	       my @words = split /,/,@_[0];
		   my $x0 = $words[1];
		   my $y0 = $words[2];
		   my $z0 = $words[3];

		   my $x1 = $words[4];
		   my $y1 = $words[5];
		   my $z1 = $words[6];

		   my $nx = $words[7];
		   my $ny = $words[8];
		   my $nz = $words[9];		   
		   
	my @grids0;
	my @grids1;	
	
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
            my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 			
            if (within_plane($point, $plane)){
                push(@grids0, $words[1]);				
            }				

			$point = "$x,$y,$z,";
            $plane = "$x1,$y1,$z1,$nx,$ny,$nz,"; 			
            if (within_plane($point, $plane)){
                push(@grids1, $words[1]);				
            }				

        }			
	 }
	close(fh1);
	
	##print "highest eid: " . $new_eid . "\n";
	##print "highets grid: " . $new_grid . "\n";

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe3_plane output:\n";

    my $current_field = 5;
	my $current = 0;
	my $last = @grids0;


	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x0,$y0,$z0;
	printf fh1 "RBE2,%d,%d,123456,",++$new_eid,$new_grid;
	my $first_grid = $new_grid;	
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        printf fh1 "%d,",$grids0[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids0[$k];				
                $current_field = 3; 				
            }

    }	
    close(fh1);			


	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe3_plane output:\n";

    $current_field = 5;
	$current = 0;
	$last = @grids1;

	printf fh1 "GRID,%d,0,%g,%g,%g,0\n",++$new_grid,$x1,$y1,$z1;
	printf fh1 "RBE2,%d,%d,123456,",++$new_eid,$new_grid;
	my $second_grid = $new_grid;	
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        printf fh1 "%d,",$grids1[$k];
				++$current_field;
			} else {
		        printf fh1 "+\n";
		        printf fh1 "+,";
		        printf fh1 "%d,",$grids1[$k];				
                $current_field = 3; 				
            }

    }	
    close(fh1);	
	
	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rivet output:\n";	
	for(my $i=1; $i<=$total_dofs;++$i){
		++$new_eid;
		print fh1 "CELAS2,$new_eid,1.E+9,$first_grid,$i,$second_grid,$i,\n";
    }
	close fh1;
}


sub grid_rbe2_contact_cylinder_rotate {
	
	       my @words = split /,/,@_[0];
    	  (my $x, my $y, my $z) = ($words[1], $words[2], $words[3]);
		  (my $x0, my $y0, my $z0) = ($words[4], $words[5], $words[6]);
		  (my $nx, my $ny, my $nz) = ($words[7], $words[8], $words[9]);
		   my $copies = $words[10];
		   my $h = $words[11];
		   my $radius = $words[12];

	open(fh1, ">>", $mesh_file) or die $!;
	print fh1 "\n\$_grid_rbe2_contact_cylinder_rotate output:\n";
	my $alpha = 2. * pi / $copies;
    close(fh1);    
	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
	
	for(my $k = 0; $k < $copies; $k++) {
		my $angle = $alpha * $k;
		(my $new_x, my $new_y, my $new_z) = &rotate_rodrig_formula("$x,$y,$z,$x0,$y0,$z0,$nx,$ny,$nz,$angle");
		my $command="_grid_rbe2_cylinder,$new_x,$new_y,$new_z,$h,$radius,$nx,$ny,$nz,";
		&grid_rbe2_cylinder($command);
    }	
	
}


sub within{
    ((@_[1] < @_[0]) && (@_[0] < @_[2]))
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

	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
	
	my $alpha = atan2($R0,$h);
	
	my $t = ($x - $x0) * $nx + ($y - $y0) * $ny + ($z - $z0) * $nz;
	my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
	
   (abs($t) < $h) && ( abs($t) > $distance * cos($alpha)); 
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
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;
	
	my $t = ($x - $x0) * $nx + ($y - $y0) * $ny + ($z - $z0) * $nz;
	my $distance = sqrt(($x-$x0)**2 + ($y-$y0)**2 + ($z-$z0)**2);
	#####print sqrt($distance**2 - $t**2) . "," .$R0 . "," . abs($t) . "," . $h . ",";
   (abs($distance**2 - $t**2) < $R0**2) && (abs($t) < $h) ; 
}


sub within_plane{
##	my $point = "$x,$y,$z,";
##  my $plane = "$x0,$y0,$z0,$nx,$ny,$nz,"; 			
	(my $x, my $y, my $z) = split /,/,@_[0];
	(my $x0, my $y0, my $z0, my $nx, my $ny, my $nz) = split /,/,@_[1];
	
	my $mag = sqrt($nx**2 + $ny**2 + $nz**2);
	$nx /= $mag;
	$ny /= $mag;
	$nz /= $mag;

	my $d = abs( ($x-$x0) * $nx + ($y-$y0) * $ny +($z-$z0) * $nz );
	##print "$x,$y,$z,$x0,$y0,$z0,$nx,$ny,$nz,$d\n";
	abs( ($x-$x0) * $nx + ($y-$y0) * $ny +($z-$z0) * $nz ) < $error;
}