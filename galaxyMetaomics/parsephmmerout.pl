#!/usr/bin/perl -w
 
use strict;
use warnings;

my $num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "\nUsage: parsehmmsearch.pl infile outfile\n";
    exit;
}
 

my $infile=$ARGV[0];
my $outfile=$ARGV[1];
open (OUT, ">$outfile");
my @ids=(); 

if (open (IN, "<$infile")) {
  while (my $line = <IN>) {
    chomp $line;
    #print $line,"\n";
    if($line =~/^sp/){
        my @data= split(" - ", $line);
        my $result=$data[1];
    	push (@ids,$result);
     }
  }
} else {
  warn "Could not open file '$infile' $!";
}

my @unique_ids;
my %seen;
 
foreach my $id (@ids) {
  if (! $seen{$id}++ ) {
    $id =~ s/^\s+//;
    print OUT $id,"\n";
  }
} 
close(IN);
close(OUT);

