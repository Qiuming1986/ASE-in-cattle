#!/use/bin/perl
use strict;
die "Usage:$0 <in gzvcf> <out gzvcf>" unless @ARGV==2;
open (IN,"gzip -dc $ARGV[0] |") or die "cannot open gzvcf file";
my $tmp=$ARGV[1];
$tmp=~s/\.gz$//;
open (TMP,">$tmp");
while(<IN>){
	chomp;
	if (/^#/){
		print TMP "$_\n";
	}else{
		s/1\/1/0\/0/g;
		print TMP "$_\n";
	}
}
system("bcftools view $tmp -Oz -o $ARGV[1]");
system("rm -f $tmp");
system("bcftools index -t $ARGV[1]");
close IN;
close TMP;
