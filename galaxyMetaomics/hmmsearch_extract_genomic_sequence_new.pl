#!usr/bin/perl

use Bio::SeqIO;
#use home::apps::perl::lib::Bio::SeqIO;
use List::MoreUtils qw/ uniq /;

# (1) quit unless we have the correct number of command-line args
$num_args = $#ARGV + 1;
if ($num_args != 3) {
  print "\nUsage: extract_genomic_sequence.pl infile1 infile2 outfile\n";
  exit;
}


# (2) we got two command line args, so assume they are the
# protein iDs  file, result file(fasta)

@ids_d=();
@start=();
@end=();
@acc=();
@seq=();

$infile=$ARGV[0];
$infile1=$ARGV[1];
$outfile=$ARGV[2];
open FASTA, $infile1 or die $!;
my %hash = (); 

my @unique_d;
my @unique_c;

sub reverse_complement_IUPAC {
        my $dna = shift;

	# reverse the DNA sequence
        my $revcomp = reverse($dna);

	# complement the reversed DNA sequence
        $revcomp =~ tr/ABCDGHMNRSTUVWXYabcdghmnrstuvwxy/TVGHCDKNYSAABWXRtvghcdknysaabwxr/;
        return $revcomp;
}

sub reverse_complement {
        my $dna = shift;

	# reverse the DNA sequence
        my $revcomp = reverse($dna);

	# complement the reversed DNA sequence
        $revcomp =~ tr/ACGTacgt/TGCAtgca/;
        return $revcomp;
}



open (OUT, ">$outfile");

open(FILE,$infile) || die "Can not open the desired file $infile\n";

while(<FILE>){

	$line = $_;
        print $line,"\n";
        chomp($line);
	#print $line,"\n";
        @data=split(/\t/,$line);
        if($data[2] eq "D"){
		push(@ids_d,$data[1]);
        }else{
               push(@ids_c,$data[1]);
        }
}

@unique_d = uniq @ids_d;
@unique_c = uniq @ids_c;

#put ids into a hash
%index_c;
%index_d;

for($i=0;$i<=$#unique_c;$i++)
{
    $index_c{$unique_c[$i]} = 1;
}

for($j=0;$j<=$#unique_d;$j++)
{
    $index_d{$unique_d[$j]} = 1;
}

#@size = keys %index_c;
#print "number of unique ids: " . @size . "\n";

#special operator to jump to next sequence in while loop
$/ = ">";

my $junkFirstOne = <FASTA>;

while (<FASTA>) {
        chomp;
        my ($def,@seqlines) = split /\n/, $_;
        my $seq = join '', @seqlines;

        my ($id, @desc) = split(" ", $def);

        #print $id."\n";

        if (exists $index_d{$id}) {
                 print OUT ">$def\n$seq\n";

        }elsif(exists $index_c{$id}) {
          $string2 = reverse_complement($seq);
          print OUT ">$def\n$string2\n";
      }

}

close FASTA;
