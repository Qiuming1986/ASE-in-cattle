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
	system("rm -f tmp*");
	open (OUT1,">tmp.txt");
	my @value=split/\t/,$hash{$key};
	foreach my $index (0..($#value-1)){
		open (TMP,">$value[$index].narrowPeak");
		open (IN1,"gzip -dc ../12.peak3/$value[$index]_peaks.narrowPeak.gz |") or die "cannot open ../12.peak3/$value[$index]_peaks.narrowPeak.gz\n";
		while(<IN1>){
			chomp;
			my @F=split/\t/,$_;
			if (/^\d+/){
				print TMP "$F[0]\t$F[1]\t$F[2]\n";
			}
		}
		foreach my $index1 (($index+1)..$#value){
			open (TMP1,">$value[$index1].narrowPeak");
			open (IN2,"gzip -dc ../12.peak3/$value[$index1]_peaks.narrowPeak.gz |") or die "cannot open ../12.peak3/$value[$index1]_peaks.narrowPeak.gz\n";
			while(<IN2>){
				chomp;
				my @F=split/\t/,$_;
				if (/^\d+/){
					print TMP1 "$F[0]\t$F[1]\t$F[2]\n";
				}
			}
			system("bedtools intersect -a $value[$index].narrowPeak -b $value[$index1].narrowPeak > tmp1.txt");
			open (IN3,"tmp1.txt");
			while(<IN3>){
				chomp;
				my @F=split/\s+/,$_;
				print OUT1 "$F[0]\t$F[1]\t$F[2]\t$value[$index]_$value[$index1]\n";
			}
		}
		system("rm -f $value[$index].narrowPeak");
	}
	system("rm -f $value[$#value].narrowPeak");
	system("sort -n -k 1,1 -k 2,2 tmp.txt > tmp1.txt");
	system("bedtools merge -i tmp1.txt -c 1,4 -o count,collapse > tmp.txt");
	open (OUT,">$key.narrowPeak");
	open (IN4,"tmp.txt");
	while(<IN4>){
		chomp;
		my @F=split/\s+/,$_;
		my @tmp=split/,/,$F[4];
		my %hash;
		foreach my $index (0..$#tmp){
			my @id=split/_/,$tmp[$index];
			foreach my $index1 (0..$#id){
				$hash{$id[$index1]}=1;
			}
		}
		my @srr;
		foreach my $key (keys %hash){
			push @srr,$key;
		}
		my $count=@srr;
		my $srr=join ",",@srr;
		print OUT "$F[0]\t$F[1]\t$F[2]\t$count\t$srr\n";
	}
}
close IN1;
close IN2;
close OUT;
close OUT1;
close TMP;
close TMP1;
