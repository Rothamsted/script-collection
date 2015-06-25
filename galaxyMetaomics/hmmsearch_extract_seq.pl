#!/usr/bin/perl

#script to extract given ids from a multi-line FASTA file
#author: keywan
#date: 22/10/2013
my $start=">";
my $usage = "usage: $0 sequence.fasta ids.txt\n\n";

my $fasta_file = $ARGV[0] or die $usage;
my $ids_file = $ARGV[1] or die $usage;
my $output   = $ARGV[2] or die $usage;

open FASTA, $fasta_file or die $!;
open IDS, $ids_file or die $!;
open (OUT, ">$output");

#put ids into a hash
%index;

while (<IDS>) {
	chomp;
	$index{$_} = 1;
}
#@size = keys %index;
#print "number of unique ids: " . @size . "\n";
close IDS;

#special operator to jump to next sequence in while loop
$/ = ">";

my $junkFirstOne = <FASTA>;

while (<FASTA>) {
	chomp;
	my ($def,@seqlines) = split /\n/, $_;
	my $seq = join '', @seqlines;

	my ($id, @desc) = split(" ", $def);
	
	#print $id."\n";
	
	if (exists $index{$id}) {
                
		print OUT ">$def";
                print OUT "\n$seq\n";

	}
	
}

close FASTA;





