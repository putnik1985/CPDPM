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

    my @output;
	my @fields;
	
	     print "List of commands:\n";
		 print "grid,20,25 - output grids from 20 to 25 inclusive\n";
		 print "rbe2,inputfile - create rbe2 for the grids from input file\n";
		 print "write,outputfile - write the results of all commands into outputfile\n";
		 
         while(<STDIN>){
         my $line = $_;
		 chomp($line);
		 my @words = split/,/,$line;
		 ####print $words[0], $words[1];
		 print "\n";
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