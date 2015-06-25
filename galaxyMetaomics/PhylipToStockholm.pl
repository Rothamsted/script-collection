#!/usr/bin/perl -w

# usage : perl phyliptosto.pl phylipfile stofile

$end="//";
open (IN, "<$ARGV[0]");
open (OUT, ">$ARGV[1]");
while (<IN>) {
    chop;
    if (m/^\s+[0-9]+/) {
      #$line=$_;     
       print OUT "# STOCKHOLM 1.0\n";
    } else {
        print OUT "$_\n";
    }
}
 print OUT "$end\n";
close( IN );
close( OUT );

