#!usr/bin/perl

my $usage = "usage: $0 hmmout output\n\n";

my $hmmfile = $ARGV[0] or die $usage;
open (OUT, ">$ARGV[1]");

$string = processFile($hmmfile);
@ids=split(";",$string);

foreach $id (@ids){

   print OUT $id,"\n";
}

sub processFile{
        my($file)=@_;
        my $result;
	open(FILE,$file);

	while(<FILE>){

	$line=$_;

	@data=split(" ",$line);

	$cnt=scalar(@data);

	#print $cnt;
		if ($cnt==9){
   			if(!($line=~/^Initial/)){
      				if(!($line=~/^#/)){
      					#print $line,"\n";
                                        $result.=$data[8];
                                        $result.=";"
     				}#endif
   			}#endif

 		}#endif
	}#endwhile
   return $result;

}


