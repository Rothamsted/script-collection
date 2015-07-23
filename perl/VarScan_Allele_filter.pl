#!/usr/bin/perl

use warnings;

##Run script using the command "./VarScan_Allele_filter.pl vcffile.vcf > output.vcf"

my $vcfFile = shift;
open (VCF, "<$vcfFile");

my $X = 2;
my $Y = 5;



while (<VCF>) {
	#skip header line
	if ($. < 25){
      print $_;

      }else{

	#remove return character
	chomp;
	
	#split columns by tabs
	my @col = split /\t/;

	#keep only lines where data from all three samples if atleast one data set is not available
	if($col[7] !~ /NC=0/){
		next;
	}

	#only consider transition SNPs

	
	
      if ($col[9] =~ /^\./ || $col[10] =~ /^\./ || $col[11] =~ /^\./){	

     }else{	


	my @lastcol1 = split /:/, $col[9];
	my @lastcol2 = split /:/, $col[10];
	my @lastcol3 = split /:/, $col[11];

	my $test1 = 0;
	my $test2 = 0;

     my $num1 = substr($lastcol1[6], 0, -1);
     my $num2 = substr($lastcol2[6], 0, -1);
     my $num3 = substr($lastcol3[6], 0, -1);


			if($num1 < $X){
			$test1++;
		}
	
		if($num1 > $Y){
			$test2++
		}
	

	if($num2 < $X){
			$test1++;
		}
		if($num2 > $Y){
			$test2++
		}

	if($num3 < $X){
			$test1++;
		}
		if($num3 > $Y){
		$test2++
		}

	#test if variation in two samples is <X and in one sample >Y
if($test1==2 && $test2==1){
		print "$_\n";
		
	}
}
	
}
}
