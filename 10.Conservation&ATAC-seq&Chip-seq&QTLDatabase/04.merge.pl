#!/usr/bin/perl
use strict;
die "Usage:$0<sampleVStissue>" unless @ARGV==1;
open (IN,"$ARGV[0]") or die "sampleVStissue cannot open!\n";
my %hash;
while(<IN>){
	chomp;
	my @F=split/\t/,$_;
	if (exists $hash{$F[1]}){
		$hash{$F[1]} .= "\t".$F[0];
	}else{
		$hash{$F[1]} = $F[0];
	}
}
foreach my $key (keys %hash){
	my @value=split/\t/,$hash{$key};
	open (TMP,">tmp.txt");
	foreach my $index (0..$#value){
		open (IN1,"gzip -dc ../06.peak/$value[$index]_peaks.narrowPeak.gz |") or die "cannot open ../06.peak/$value[$index]_peaks.narrowPeak.gz\n";
		while(<IN1>){
			chomp;
			my @F=split/\t/,$_;
			if (/^\d+/){
				print TMP "$F[0]\t$F[1]\t$F[2]\t$value[$index]\n";
			}
		}
	}
	system("sort -n -k 1,1 -k 2,2 tmp.txt > tmp1.txt");
	system("bedtools merge -i tmp1.txt -c 1,4 -o count,collapse > tmp.txt");
	open (OUT,">$key.narrowPeak");
	open (IN2,"tmp.txt");
	my $num=@value;
	while(<IN2>){
		chomp;
		my @F=split/\t/,$_;
		if ($F[3] >= 3){
			print OUT "$_\n";
		}
	}
}
close IN1;
close IN2;
close OUT;
close TMP;
