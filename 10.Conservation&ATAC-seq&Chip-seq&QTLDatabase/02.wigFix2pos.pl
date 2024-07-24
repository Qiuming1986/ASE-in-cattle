#!/usr/bin/perl
use strict;
die "Usage:$0 <wigFix file> <position file>\n" unless @ARGV==2;
open (IN,"gzip -dc $ARGV[0] |") or die "wigFix file requirement!\n";
open (OUT,">$ARGV[1]") or die "position file requirement!\n";
open (TMP,">tmp.txt");
while (<IN>){
	chomp;
	if (/fixed/){
		print TMP "\n$_";
	}else{
		print TMP "\t$_";
	}
}
open (IN1,"tmp.txt");
while (<IN1>){
        chomp;
	my @F=split/\s+/,$_;
	next unless (/fixedStep/);
	my $chr=$F[1];
	$chr=~s/chrom=chr//;
	my $start=$F[2];
	$start=~s/start=//;
	foreach my $index (4..$#F){
		print OUT "$chr\t$start\t$F[$index]\n";
		$start++;
	}
}
system ("rm -f tmp.txt");
close IN;
close OUT;
close TMP;
close IN1;
