Instructions for FindInsertSeq.pl

Software required in PATH:
SAMtools (Tested with Version: 0.1.19-44428cd but shouldn't be an issue which version you have)
Bowtie2 (Any version should be fine)


Open up linux command line (contact your IT support if you are unsure how to do this):

Go to: https://github.com/Rothamsted/AppliedBioinformatics

Click on "download ZIP" which is on the right of the screen and put it in a location of your choice i.e. /home/data/rking/


unzip the file to a location of your choice, for example

cd /home/data/rking
unzip [download filename].zip


Go to the location where the FindInsertSeq folder is:

cd [download filename]/FindInsertSeq

Get the sample data files from below and place in the FindSeq directory below. Please note these files have been reduced to 10% the original size but are still 600 Mb total. They were not reduced further because it's important to retain coverage across the plasmid and genomic sequence to demonstrate the observation of plasmid insertion copy number by comparison with the genomic coverage and that there were no large scale deletions events across the genome using this example.
https://rrescloud.rothamsted.ac.uk/public.php?service=files&t=6b600b040d42a3e31f126da37119d01d

Here you should find 2 scripts for FindSeq either using novoalign (FindSeq_Novo.pl) if you have it or Bowtie2 (FindSeq_bow2.pl), a Reads.txt file which contains your set of paired read filenames separated by a comma, and sample data "3002subR1_25.fastq", "3002subR2_25.fastq", "plasmid1.fasta", "RRes_GZ.fasta".

Open the "Reads.txt" file and you will see the names of the left and right fastq files separated by a comma that matches the sample data. If you change this file by adding additional or different paired data in windows make sure it is in linux format by doing a "dos2unix Reads.txt".

Run the FindInsertSeq script by typing:
[The script] [plasmid sequence] [genomic reference sequence]
./FindInsertSeq.pl plasmid1.fasta RRes_GZ.fasta bowtie

The end output will print to the screen the mapped genomic reads in coordinate sorted order so you can visually identify where the insertion points are by a number of reads of similar positions (cluster or stack). The output is also printed to a file too if you look in the folder. 

Example output for the sample data is:
****PAIRED READ SET 3002sub1R1_25.fastq.sam COMPLETED****

Chromosome_4    1518752
Chromosome_4    1518843
Chromosome_4    1518890
Chromosome_4    1518890
Chromosome_4    1518890
Chromosome_4    1518928
Chromosome_4    1518977
Chromosome_4    1519002
Chromosome_4    1519021
Chromosome_4    1519104
Chromosome_4    1519112
Chromosome_4    1519148
Chromosome_4    1519151
Chromosome_4    1519175
Chromosome_4    1519188
Chromosome_4    1519223
Chromosome_4    1519281


Now run the second script to identify the insert position as below (default window size is 300) which scans the mpileup file produced by the earlier script to locate coverage peaks:

python ./find_high_cov.py unmapped_3002sub1R1_25.fastq.sam.sort.bam.mpileup

Example output:
[contig, start of maximum coverage window, end of maximum coverage window]
('Chromosome_4', 1518949, 1519249)

If this method is unable to locate the insert position it is likely the plasmid is inserted in sequence that is not present in your reference therefore the alternative route to locate the flanking sequences of your insertion is to take the reads that were paired mates of the mapped plasmid reference i.e. unmapped_R1_3002.fastq.sam.fastq and de novo assemble them. 
