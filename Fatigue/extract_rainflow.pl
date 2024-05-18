use strict;
use autodie;

    my $file = $ARGV[0];
##    print "input file: $file\n";
     
    open(fh,'<',$file);
    while (<fh>) {
      if ( m/^\s+cycles/) {
         last;
      }
    }
 
    while (<fh>) {
    my @words = split /\s+/,$_;
    print $words[1] . "," . $words[2] . "," . $words[3] , ",\n";
    }
    close(fh);
