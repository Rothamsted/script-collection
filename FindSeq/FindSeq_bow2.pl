#!/usr/bin/perl

use strict;
use warnings;

##requirements
#bowtie2 and samtools in path
##commands
#dos2unix Reads.txt
#./FindSeq_bow.pl plasmid1.fasta RRes_GZ.fasta
#novoalign is a more accurate mapper and preferred but not multi-threaded without buying the licence, in this example bowtie does not show the deletion because two reads cover it which are missmappings
#TEST DATA
#The reference genome information for F. graminearum strain PH-1 (NRRL 31084) is available at GenBank under accession AACM00000000 (Cuomo et al., 2007).
#Whole-genome sequencing information for the strains described in this study are available at the Sequence Read Archive (SRA). Accession numbers are: ERS430784 (DAF139), ERS430785 (DAF140), ERS430786 (DAF141), ERS430787 (TP11.1). 

#get plasmid and genome fasta files (needs to be in same directory as perl script)
my ($plasmidRef, $genomeRef) = @ARGV;

return if (not defined($plasmidRef));
return if (not defined($genomeRef));

#index plasmid
print "bowtie2-build $plasmidRef plasmid.ndx\n";
system("bowtie2-build $plasmidRef plasmid.ndx") == 0  or die "system indexing plasmid failed: $?";

#index genome reference
print "bowtie2-build $genomeRef genome.ndx\n";
system("bowtie2-build $genomeRef genome.ndx") == 0  or die "system indexing genomic reference failed: $?";


print "+++++ STEP 1 +++++\n";

my @SAMdata;

open (READS, "<Reads.txt");
while (<READS>) {
	chomp;
	my ($reads1, $reads2) = split /,/;
	print "bowtie2 -p 20 -x plasmid.ndx -1 $reads1 -2 $reads2 -S $reads1.sam\n";
	system("bowtie2 -p 20 -x plasmid.ndx -1 $reads1 -2 $reads2 -S $reads1.sam") == 0  or die "system Bowtie2 failed: $?";
	print "samtools view -uhS $reads1.sam | samtools sort - $reads1.sort\n";
	system("samtools view -uhS $reads1.sam | samtools sort - $reads1.sort") == 0  or die "system samtools sam to bam: $?";
	#print "samtools sort $reads1.bam $reads1.sort\n";
	#system("samtools sort $reads1.bam $reads1.sort") == 0  or die "system samtools sort: $?";
	print "samtools index $reads1.sort.bam\n";
	system("samtools index $reads1.sort.bam") == 0  or die "system samtools index: $?";

	#add sam file to new array
	push (@SAMdata, "$reads1\.sam");

}
close(READS);

print "+++++ STEP 2 +++++\n";
#take unmapped reads from mapped pair reads and convert to fastq, map to full reference, convert, sort, index.
foreach my $SAM (@SAMdata){
	print "samtools view -h -S -f 5 -F 8 $SAM > unmapped_$SAM\n";
	system("samtools view -h -S -f 5 -F 8 $SAM > unmapped_$SAM") == 0  or die "system samtools take unmapped reads: $?";
	print "SAM To FASTQ: cat unmapped_$SAM | grep... | awk... > unmapped_$SAM.fastq\n";
	system("cat unmapped_$SAM | grep -v ^\@ | awk '{print \"\@\"\$1\"\\n\"\$10\"\\n+\\n\"\$11\}' > unmapped_$SAM.fastq ") == 0  or die "system samtools convert unmapped reads to Fastq: $?";
	#FASTQ file contains mixed R1/R2 reads so not all are paired in one fastq file. BWA does not seem to keep te orientation of the mapped reads in this format which is assumed why it was unsuccessful identifying some plasmid insertions. BOWTIE2 and Novoalign do kepp orientation of the reads and do identify insertion site for all samples tested
	print "bowtie2 -x genome.ndx -U unmapped_$SAM.fastq -S unmapped_$SAM.sam\n";
	system("bowtie2 -x genome.ndx -U unmapped_$SAM.fastq -S unmapped_$SAM.sam") == 0  or die "system Bowtie2: $?";
	print "samtools view -uhS unmapped_$SAM.sam | samtools sort - unmapped_$SAM.sort\n";
	system("samtools view -uhS unmapped_$SAM.sam | samtools sort - unmapped_$SAM.sort") == 0  or die "system samtools sam to bam: $?";
	#print "samtools sort unmapped_$SAM.bam unmapped_$SAM.sort\n";
	#system("samtools sort unmapped_$SAM.bam unmapped_$SAM.sort") == 0  or die "system samtools sort: $?";
	print "samtools index unmapped_$SAM.sort.bam\n";
	system("samtools index unmapped_$SAM.sort.bam") == 0  or die "system samtools index: $?";

	print "\n****PAIRED READ SET $SAM COMPLETED****\n\n";

#hash
my %Chrom;
#used to make key unique
my $counter=0;

open (READS, "<unmapped_$SAM.sam");
while (<READS>) {
	chomp;
	if($_ =~ /^@/){
		next;
	}
	#split columns by tabs
	my @col = split /\t/;

#key is made unique by addition to name of counter and both key and value added to hash (probably simple way of doing this but works fine)
#don't include unmapped reads
if ($col[3] != 0){
$Chrom{$col[2].":".$counter} = $col[3];
$counter++;
}
}
close(READS);	


my $filename = "unmapped_$SAM\.sort\.bam\.txt";
#print the hash to screen and collate results to files
open FILE, ">$filename" or die "Could not open file '$filename' $!";
foreach my $name (sort { $Chrom{$a} <=> $Chrom{$b} or $a cmp $b } keys %Chrom) {
    
	my ($a,$b)=split(/:/, $name);
	print $a . "\t" . $Chrom{$name} . "\n";
	print FILE "$a" . "\t" . $Chrom{$name} . "\n";
}

close FILE;


print "\n****Visualise your BAM file in Tablet using the common chromosome and positions entrys displayed in report files****\n\n";

}




