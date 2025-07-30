use strict;

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
	
         while(<STDIN>){
         my $line = $_;
		 chomp($line);
		 my @words = split/,/,$line;
		 ####print $words[0], $words[1];
		 print "\n";
		 if ($line =~ /grid/){ ##usage grid,20,25
		       for (my $i=$words[1]; $i <= $words[2]; $i++) {
				    print $file_grids{$i};
                    my @coord = split/,/,$file_grids{$i};
                    push(@output,join(",",$coord[3],$coord[4],$coord[5]));					
			   }
		 }

         if ($line =~ /write/){ ## write,output.dat
			 my $filename = $words[1];
			 ####print $filename;
			 open(outputh, '>', $filename);
			 for (@output) {
				 printf outputh "%s\n", $_;
			 }
			 close(outputh);
		 }
		 
		 print "\n";	   
         }