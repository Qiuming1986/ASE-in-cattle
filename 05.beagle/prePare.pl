#!/usr/bin/perl
use strict;
die "Usage:$0<gzvcf in> <vcf out>\n" unless @ARGV==2;
open (IN,"gzip -dc $ARGV[0]|") or die "gzvcf input requirement!\n";
open (OUT,">$ARGV[1]") or die "vcf output requirement!\n";
while(<IN>){
	chomp;
	if (/^#/){
		print OUT "$_\n";
	}else{
		s/\s\.:/\t.\/.:/g;
		my @F=split/\t/,$_,4;
		print OUT "$F[0]\t$F[1]\t$F[0]:$F[1]\t$F[3]\n";
	}
}
system("bgzip -c $ARGV[1] > $ARGV[1].gz");
close IN;
close OUT;
