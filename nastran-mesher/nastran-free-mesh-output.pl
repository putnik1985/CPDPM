use strict;

use Math::Trig;
use Cwd qw(getcwd);

    print "\n";
###usage: perl nastran-free-mesh-modifier.pl file_where_mesh file_where_commands scale_factor_for_length
	my $mesh_file = $ARGV[0];

	
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
                 #####print $words[1] . "\n";				 
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
		 if ($words[0] =~ /RBE|CTETRA|CHEXA|CQUAD|CELAS|CBUSH|GAP|CBEAM|CBAR|CONM/){
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

    my @output;
	my @fields;

	     print "----------------------------------------------------\n";	
	     print "List of commands:\n";
         print "----------------------------------------------------\n";		 
		 print "grid,20,25       - output grids from 20 to 25 inclusive\n";
		 print "rbe2,inputfile   - create rbe2 for the grids from input file\n";
		 print "bolt_joint,bolt  - joint.dat,grid-part-map.dat - create bolt joint based on the rbe2 connected two parts\n";
		 print "spreaders,bolt   - joint.dat - create spreaders from the file bolt-joit.dat\n";
		 print "cg,grids-file   - calculate cg of the grids fromn the grids-file\n";		 
		 print "write,outputfile - write the results of all commands into outputfile\n";
	     print "----------------------------------------------------\n";
		 print "\n";
		 
         while(<STDIN>){
         my $line = $_;
		 chomp($line);
		 my @words = split/,/,$line;
		 ####print $words[0], $words[1];
		 print "\n";
		 
		 if ($line =~ /^cg/){ ## cg,grid-file
		     open(grh, '<', $words[1]);
			 my @grids;
			      while (<grh>){
					 ####print $_;
					 chomp;
					 push(@grids, $_);
				  }
			 close(grh);
			 ###print @grids;
			 
			 my($xc, $yc, $zc) = &cg(@grids);
			 print "$xc,$yc,$zc\n";
		 }
		 
		 if ($line =~ /^grid/){ ##usage grid,20,25
		       for (my $i=$words[1]; $i <= $words[2]; $i++) {
				    print $file_grids{$i};
                    my @coord = split/,/,$file_grids{$i};
                    push(@output,join(",",$coord[3],$coord[4],$coord[5]));					
			   }
		 }

         if ($line =~ /^write/){ ## write,output.dat
			 my $filename = $words[1];
			 ####print $filename;
			 open(outputh, '>', $filename);
			 for (@output) {
				 printf outputh "%s", $_;
			 }
			 close(outputh);
		 }

         if ($line =~ /^rbe2/){ ## rbe2,fileofnodes
		     my $list = $words[1];
             &nastran_rbe2("rbe2,$list,0.001,");
		 }

         if ($line =~ /^bolt_joint/){ ## bolt_joint,bolt-joint.dat,grid-part-map.dat
		     my $rbe2_bolts = $words[1];
			 my $grid_part = $words[2];
			 my %grid_map;
			 #####print $rbe2_bolts, $grid_part;
			 
			     open(grid_parth,'<', $grid_part);
				      while(<grid_parth>){
						  chomp;
						  &fields($_);
						  $grid_map{$fields[0]} = $fields[1]; ###grid -- part
					  }	  						  
				 close(grid_parth);
				 
				 open(jointh,'<',$rbe2_bolts);
				      while(<jointh>){
						  chomp;
						  &fields($_);
			              my %sets;
						  for(@fields){
							  if ($grid_map{$_}){
						          $sets{$grid_map{$_}} = $sets{$grid_map{$_}} . "," . $_;
							  }
						  }
						  my   @keys =   keys %sets;
						  my @values = values %sets;
						  
						  if (@keys == 2 ){
							  $values[0] =~ s/^,//;
							  $values[1] =~ s/^,//;
							  
							  my @grids1 = split/,/,$values[0];
							  my @grids2 = split/,/,$values[1];

							  ####print @grids1, @grids2;
							  ###my ($x1, $y1, $z1) = &cg(@grids1);
							  ###print "$x1,$y1,$z1\n";						  
							  ###my ($x2, $y2, $z2) = &cg(@grids2);
							  ###print "$x2,$y2,$z2\n";

							  my ($first, $x1, $y1, $z1) = &grid_create_spreader_from_grids($values[0]);
							  my ($second, $x2, $y2, $z2) = &grid_create_spreader_from_grids($values[1]);
                              ###print "$first, $x1,$y1,$z1\n";
                              ###print "$second, $x2,$y2,$z2\n";
							  &grid_create_bolt($first, $x1, $y1, $z1, $second, $x2, $y2, $z2);
							  ####exit;
						  } else {
							  
						  }
					  }	  						  				  
				 close(jointh);
				 
				              my $E = 6.895E10;
			                  my $nu = 0.33;
							  my $bolt_dia = 0.007;
		 	                  my $spreader_radius = 2 * $bolt_dia / 2.; 
							  my $bolt_joint_radius = 3 * $bolt_dia / 2.;
							  my $rho = 2711.27;
							  my $cte = 2.237E-5;
							  my $tref = 20.;
                              ###### Spreader properties and material							  
			                  my $output_str = sprintf "PBARL,$next_property,$next_material,MSCBML0,ROD,,,,,+\n+,$spreader_radius,0.0,\n";
	                          push(@output, $output_str);
							  print $output_str;
		                      $output_str = sprintf "\$*  Material: Bolt Joint Spreader::Cone Compression::Mesher\n";
	                          push(@output, $output_str);
							  print $output_str;
	                          $output_str = sprintf "MAT1,%d,%.2E,,%.4f,%.4f,%.4e,%.4f,\n",$next_material,$E,$nu,0.0,$cte,$tref;
	                          push(@output, $output_str);
                              print $output_str;							  
			                  $next_property++;
			                  $next_material++;
							  
							  ###### Bolts properties and material
			                  my $output_str = sprintf "PBARL,$next_property,$next_material,MSCBML0,ROD,,,,,+\n+,$bolt_joint_radius,0.0,\n";
	                          push(@output, $output_str);
							  print $output_str;
		                      $output_str = sprintf "\$*  Material: Bolt Joint::Cone Compression::Mesher\n";
	                          push(@output, $output_str);
							  print $output_str;
	                          $output_str = sprintf "MAT1,%d,%.2E,,%.4f,%.4f,%.4e,%.4f,\n",$next_material,$E,$nu,$rho,$cte,$tref;
	                          push(@output, $output_str);
                              print $output_str;							  
			                  $next_property++;
			                  $next_material++;
		 }
		 
		 if ($line =~ /^spreaders/){ ## spreaders,bolt-joint.dat
		         my $rbe2_bolts = $words[1]; ## just the name no idea
				 open(jointh,'<',$rbe2_bolts);
				      while(<jointh>){
						  chomp;
						  &grid_create_spreader_from_grids_with_first_master($_);
						  }  						  				  

				 close(jointh);	
				 
				              my $E = 6.895E10;
			                  my $nu = 0.33;
							  my $bolt_dia = 0.007;
		 	                  my $spreader_radius = 2. * $bolt_dia / 2.; 
							  my $cte = 2.237E-5;
							  my $tref = 20.;
							  
                              ###### Spreader properties and material							  
			                  my $output_str = sprintf "PBARL,$next_property,$next_material,MSCBML0,ROD,,,,,+\n+,$spreader_radius,0.0,\n";
	                          push(@output, $output_str);
							  print $output_str;
		                      $output_str = sprintf "\$*  Material: Bolt Joint Spreader::Cone Compression::Mesher\n";
	                          push(@output, $output_str);
							  print $output_str;
	                          $output_str = sprintf "MAT1,%d,%.2E,,%.4f,%.4f,%.4e,%.4f,\n",$next_material,$E,$nu,0.0,$cte,$tref;
	                          push(@output, $output_str);
                              print $output_str;							  
			                  $next_property++;
			                  $next_material++;

		 }
		 print "\n";	   
         }
		 
sub nastran_rbe2 {

	       my @words = split /,/,@_[0];
		   my $list = $words[1];
		   my $scale = $words[2];

           my ($x0, $y0, $z0) = &cg_from_list($list);
		   $x0 *= $scale;
		   $y0 *= $scale;
		   $z0 *= $scale;
		   
		   &grid_create_rbe2_from_list("_grid_create_rbe2_from_list,$list,$x0,$y0,$z0,");

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

sub fields{
    @fields = split/,/,@_[0];
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
         ###print "$xc, $yc, $zc\n"; 
    } 
    $xc /= @grids;
    $yc /= @grids;
    $zc /= @grids;
    ($xc, $yc, $zc)
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
	open(h1, ">>", $mesh_file) or die $!;

	my $output_str = sprintf "\n\$_grid_create_rbe2_from_list:\n";
	push(@output,$output_str);

    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
    

	$output_str = sprintf "GRID,%d,0,%f,%f,%f,0\n",$next_grid,$x0,$y0,$z0;
	push(@output, $output_str);
	print $output_str;
	
	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element,$next_grid;
	push(@output, $output_str);
	print $output_str;
	$next_grid++;
	$next_element++;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@output, $output_str);
				print $output_str;
				
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@output, $output_str);
				print $output_str;
				
		        $output_str = sprintf "+,";
				push(@output, $output_str);
				print $output_str;
				
		        $output_str = sprintf "%d,",$grids[$k];				
				push(@output, $output_str);
				print $output_str;
				
                $current_field = 3; 				
            }

    }

}

sub grid_create_rbe2_from_grids {

	my @grids = split /,/,@_[0];
    my ($x0, $y0, $z0) = &cg(@grids);
	##print "$x0,$y0,$z0";
	##exit;
	
	my $output_str = sprintf "\n\$_grid_create_rbe2_from_grids:\n";
	push(@output,$output_str);

    my $current_field = 5;
	my $current = 0;
	my $last = @grids;
    

	$output_str = sprintf "GRID,%d,0,%f,%f,%f,0\n",$next_grid,$x0,$y0,$z0;
	push(@output, $output_str);
	print $output_str;
	
	$output_str = sprintf "RBE2,%d,%d,123456,",$next_element,$next_grid;
	push(@output, $output_str);
	print $output_str;
	$next_grid++;
	$next_element++;
	for(my $k = 0; $k < $last; $k++) {

			if ($current_field <= $rbe2_fields) {
		        $output_str = sprintf "%d,",$grids[$k];
				push(@output, $output_str);
				print $output_str;
				
				++$current_field;
			} else {
		        $output_str = sprintf "+\n";
				push(@output, $output_str);
				print $output_str;
				
		        $output_str = sprintf "+,";
				push(@output, $output_str);
				print $output_str;
				
		        $output_str = sprintf "%d,",$grids[$k];				
				push(@output, $output_str);
				print $output_str;
				
                $current_field = 3; 				
            }

    }
	$output_str = sprintf "\n\n";
	push(@output, $output_str);
	print $output_str;

}

sub grid_create_spreader_from_grids {

	my @grids = split /,/,@_[0];
    my ($x0, $y0, $z0) = &cg(@grids);
	##print "$x0,$y0,$z0";
	##exit;
	
	my $output_str = sprintf "\n\$_grid_create_spreader_from_grids:\n";
	push(@output,$output_str);
	print $output_str;
    

	$output_str = sprintf "GRID,%d,0,%f,%f,%f,0\n",$next_grid,$x0,$y0,$z0;
    my $first = $next_grid;
	$next_grid++;
	
	push(@output, $output_str);
	print $output_str;

	
			for(@grids){
				  my $grid_1 = $_;
				  
				  if ($grid_1 != $first){
		              my @node = split /,/,$file_grids{$grid_1};
  		              my ($x, $y, $z) = ($node[3], $node[4], $node[5]);
                      my $dx = $x - $x0;
					  my $dy = $y - $y0;
					  my $dz = $z - $z0;
					  my ($rx, $ry, $rz) = &vector_normal($dx, $dy, $dz);
			          $output_str = sprintf "CBAR,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property,$first,$grid_1,$rx,$ry,$rz;
                      push(@output, $output_str);
					  print $output_str;
					  $next_element++;
				  }
            }

	$output_str = sprintf "\n\n";
	push(@output, $output_str);
	print $output_str;
    return ($first, $x0, $y0, $z0);
}

sub grid_create_bolt {

    my ($first, $x1, $y1, $z1) = (@_[0], @_[1], @_[2], @_[3],);
    my ($second, $x2, $y2, $z2) = (@_[4], @_[5], @_[6], @_[7],);
	
    ####print "$first, $x1,$y1,$z1\n";
    #####print "$second, $x2,$y2,$z2\n";

	my $output_str = sprintf "\n\$grid_create_bolt\n";
	push(@output,$output_str);
	print $output_str;

    my $dx = $x2 - $x1;
    my $dy = $y2 - $y1;
	my $dz = $z2 - $z1;
	my ($rx, $ry, $rz) = &vector_normal($dx, $dy, $dz);
	
	$output_str = sprintf "CBAR,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property + 1,$first,$second,$rx,$ry,$rz;
    push(@output, $output_str);
	print $output_str;
	$next_element++;

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

sub grid_create_spreader_from_grids_with_first_master {

	my @grids = split /,/,@_[0];
    
	##print "$x0,$y0,$z0";
	##exit;
	
	my $output_str = sprintf "\n\$grid_create_spreader_from_grids_with_first_master:\n";
	push(@output,$output_str);
	print $output_str;
    

	
    my $first = $grids[0];
    my @node = split /,/,$file_grids{$first};
  	my ($x0, $y0, $z0) = ($node[3], $node[4], $node[5]);

	push(@output, $output_str);
	print $output_str;

	
			for(@grids){
				  my $grid_1 = $_;
				  
				  if ($grid_1 != $first){
		              my @node = split /,/,$file_grids{$grid_1};
  		              my ($x, $y, $z) = ($node[3], $node[4], $node[5]);
                      my $dx = $x - $x0;
					  my $dy = $y - $y0;
					  my $dz = $z - $z0;
					  my ($rx, $ry, $rz) = &vector_normal($dx, $dy, $dz);
			          $output_str = sprintf "CBAR,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$next_element,$next_property,$first,$grid_1,$rx,$ry,$rz;
                      push(@output, $output_str);
					  print $output_str;
					  $next_element++;
				  }
            }

	$output_str = sprintf "\n\n";
	push(@output, $output_str);
	print $output_str;
    return ($first, $x0, $y0, $z0);
}