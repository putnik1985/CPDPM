use strict;
use Math::Trig;

    while(<>){
     ####print $_;
     $_ =~ s/^\s+//;
     my @line = split / /,$_;
     if ($line[0] =~ /^[0-9]/) { 
         printf("%s\n", $line[0]);
     }
    }
