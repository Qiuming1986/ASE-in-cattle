#!/usr/bin/perl
use strict;
die "Usage:$0<peak list>" unless @ARGV==1;
open (IN,"$ARGV[0]") or die "peak list cannot open!\n";
my %hash;
while(<IN>){
	chomp;
	my @F=split/\./,$_,2;
	if (exists $hash{$F[1]}){
		$hash{$F[1]} .= "\t".$_;
	}else{
		$hash{$F[1]} = $_;
	}
}
foreach my $key (keys %hash){
	my @value=split/\t/,$hash{$key};
	open (TMP,">tmp.txt");
	foreach my $index (0..$#value){
		open (IN1,"gzip -dc ../05.peak/$value[$index]_peaks.narrowPeak.gz |") or die "cannot open ../05.peak/$value[$index]_peaks.narrowPeak.gz\n";
		while(<IN1>){
			chomp;
			my @F=split/\t/,$_;
			if (/^\d+/){
				print TMP "$F[0]\t$F[1]\t$F[2]\t$F[3]\n";
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
		my $threshold=$num*0.6;
		if ($F[3]>=3){
			print OUT "$_\n";
		}
	}
}
close IN1;
close IN2;
close OUT;
close TMP;
