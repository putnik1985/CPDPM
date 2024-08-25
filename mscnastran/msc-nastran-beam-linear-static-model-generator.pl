use strict;
use autodie;

use Math::Trig;


my      $grid = 0;
my      $beam = 0;
my $materials = 0;
my  $property = 0;
my %global_grids;


my $mid = 0;
my $all_mpc = "";
my $sid = 0;
my $all_spc = "";

my $load_id = 100;
my  $mpc_id = 100;
my  $spc_id = 100;


my $error = 1.e-5;
my $min_load_distance = 100.;


my   %mpc;
my   %spc;
my %loads;


print("
TIME 100000
SOL  101
CEND
TITLE = LINEAR STATIC ANALYSIS     
\$
MAXLINES = 500000
\$
\$ Output definition
\$
ECHO = NONE

DISP(SORT1,PUNCH) = ALL
FORCE(SORT1,PUNCH,REAL) = ALL

SPCFORCES(SORT1,PUNCH,REAL) = ALL
MPCFORCES(SORT1,PUNCH,REAL) = ALL

STRESS(SORT1,PUNCH,REAL,VONMISES) = ALL

load = $load_id
mpc = $mpc_id
spc = $spc_id

BEGIN BULK

PARAM,POST,-2
PARAM,PATVER,3.
PARAM,GRDPNT,0
PARAM,AUTOSPC,NO
PARAM,WTMASS,.002588
");


    while (<>) {
       ###print $_;
	   my @words = split /,/,$_;

          if ($words[0] =~ /_joint/) {
              $mpc{$words[1].",".$words[2]} = $words[3];
          }			  

          if ($words[0] =~ /_restrain/) {
              $spc{$words[1].",".$words[2]} = $words[3];
          }			  

          if ($words[0] =~ /_load/) {
              $loads{$words[1].",".$words[2]} = $words[3].",".$words[4];
          }			  

	   
	      if ($words[0] =~ /_beams/) {
            my        $J = $words[1];
			my $material = $words[2];
			my       $x0 = $words[3];
			my       $y0 = $words[4];
			my       $x1 = $words[5];
			my       $y1 = $words[6];
			my        $n = $words[7];
			####calculate radius for the equivalent section
			my $R = (4. * $J / pi)**0.25;
			
			my $L = sqrt(($x0-$x1)**2 + ($y0-$y1)**2);
			my $dl = $L / $n;
			my $nx = ($x1 - $x0) / $L;
			my $ny = ($y1 - $y0) / $L;

            my @grids;
            my @materials;
            my @sections;
			printf("\n\$Beams\n");
			### calculate grid coordinates
			for (my $i = 0; $i <= $n; ++$i) {
				 my $x = $x0 + $nx * $dl * $i;
				 my $y = $y0 + $ny * $dl * $i;
				 $grid+=1;
				 printf "grid,%d,%d,%.4f,%.4f,%.4f,%d,\n",$grid,0,$x,$y,0.0,0;
                 push(@grids,$grid);
				 $global_grids{$x.",".$y}.=$grid.",";
				 
		    }
			###############print @grids;
			### calculate beams
			my $number_grids = @grids;
			$property+=1;
			$materials+=1;
			
			for(my $i = 0; $i < $number_grids - 1; ++$i) {
				$beam+=1;
                printf("cbeam,%d,%d,%d,%d,%.4f,%.4f,%.4f,\n",$beam,$property,$grids[$i],$grids[$i+1],-$ny,$nx,0.0);
            }
            ### write beam property
			printf("pbeaml,%d,%d,MSCBML0,ROD,,,,,+\n",$property,$materials);
			printf("+,%.4f,0.0,YES,1.0,%.4f,0.0,\n",$R,$R);
			
			### write material
			my $E;
			my $nu;
			my $rho;
			
			if ($material =~ /steel/) {
		    	$E = 2.8e+7;
			    $nu = 0.296;
			    $rho = 0.283;
			} elsif ( $material =~ /titan/) {
                $E = 1.6e+7;
				$nu = 0.296;
				$rho = 0.16;
            } elsif ($material =~ /alum/) {
                $E = 1.e+7;
				$nu = 0.296;
                $rho = 0.098;
            } else {				
		    	$E = 2.8e+7;
			    $nu = 0.296;
			    $rho = 0.283;
            }	
            printf("mat1,%d,%.2E,,%.4f,%.4f,\n",$materials,$E,$nu,$rho);
		  }			 
	}
	       ##############print %mpc;
		   ############print(%global_grids);
		   
		   printf("\n\$MPC\n");		   
		   while ((my $key, my $value) = each(%mpc)){
			   my @numbers = split /,/,$key;
			   my $dofs = $value;
			   
			   ###############print $numbers[0]."+".$numbers[1];
			      
				  while ((my $key, my $value) = each(%global_grids)){
					  my @coords = split /,/,$key;
					  my $distance = sqrt(($numbers[0] - $coords[0])**2 + ($numbers[1] - $coords[1])**2);
					  
					  if ($distance < $error) {
						  ##print $value.",".$dofs."\n";
						  
						  ###split by letters
						  $mid+=1;
						  $all_mpc.=$mid.",";
						  my @grid = split /,/,$value;
						  my @letters = split //,$dofs;
						  
						  foreach (@letters){
							  #####print $_."\n";
							  printf("mpc,%d,%d,%d,1.0,%d,%d,-1.0\n",$mid,$grid[0],$_,$grid[1],$_);
						  }
					  }
				  }
		    }
		   printf("mpcadd,%d,%s\n",$mpc_id, $all_mpc);

			
		   printf("\n\$SPC\n");		   
		   while ((my $key, my $value) = each(%spc)){
			   my @numbers = split /,/,$key;
			   my $dofs = $value;
			      
				  while ((my $key, my $value) = each(%global_grids)){
					  my @coords = split /,/,$key;
					  my $distance = sqrt(($numbers[0] - $coords[0])**2 + ($numbers[1] - $coords[1])**2);
					  
					  if ($distance < $error) {
						  ##print $value.",".$dofs."\n";
						  ###split by letters
						  $sid+=1;
						  $all_spc.=$sid.",";
						  my @grid = $value;
						  printf("spc1,%d,%s,%d\n",$sid,$dofs,$value);
					  }
				  }
		    }
		    printf("spcadd,%d,%s\n",$spc_id, $all_spc);			
			
			
		   printf("\n\$LOADS\n");
           ##########print %loads;		   
		   while ((my $key, my $value) = each(%loads)){
			   my @numbers = split /,/,$key;
			   my ($dofs, $magnitude) = split /,/,$value;
			   ##########print @numbers;
                  my $grid = 0;
				  my $location;
				  my $min_distance = $min_load_distance; ### just assume point must be as close as possible
				  
				  while ((my $key, my $value) = each(%global_grids)){
					  my @coords = split /,/,$key;
					  my $distance = sqrt(($numbers[0] - $coords[0])**2 + ($numbers[1] - $coords[1])**2);
					  
					  if ($distance < $min_distance) {
						  $min_distance = $distance;
						  $grid = $value;
						  $location = $coords[0]."--".$coords[1];
					  }
				  }
				####print $grid.$location."\n";
                if ( $grid > 0 ) {
						  my @letters = split //,$dofs;
						  foreach (@letters){
							  #####print $_."\n";
							  my @null_direction = ("0.","0.","0.");
							  
							  if ($_ =~ /[1-3]/) {
								  $null_direction[$_ - 1] = "1.0";
							      my $direction = join(",",@null_direction);
							      printf("force,%d,%d,%d,%.2f,%s,\n",$load_id,$grid,0,$magnitude,$direction);
							  } 

							  if ($_ =~ /[4-6]/) {
								  $null_direction[$_ - 4] = "1.0";
							      my $direction = join(",",@null_direction);
							      printf("moment,%d,%d,%d,%.2f,%s,\n",$load_id,$grid,0,$magnitude,$direction);
							  } 


						  }
                }					
		    }


print("ENDDATA\n");