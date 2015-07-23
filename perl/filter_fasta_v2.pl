#!/usr/bin/perl -w

use strict;

##RUN BY "./filter_fasta_v2.pl > filtered_fa.fasta"
##Neilfws author
##Taken from https://www.biostars.org/p/2822/

#CHANGE THESE TO MATCH YOUR FILES
my $idsfile = "ids.txt";
my $seqfile = "seqs.fa";


my %ids  = ();

open FILE, $idsfile;
while(<FILE>) {
  chomp;
  $ids{$_} += 1;
}
close FILE;

local $/ = "\n>";  # read by FASTA record

open FASTA, $seqfile;
while (<FASTA>) {
    chomp;
    my $seq = $_;
    my ($id) = $seq =~ /^>*(\S+)/;  # parse ID as first word in FASTA header
    if (exists($ids{$id})) {
        $seq =~ s/^>*.+\n//;  # remove FASTA header
        $seq =~ s/\n//g;  # remove endlines
        print "$seq\n";
    }
}
close FASTA;
