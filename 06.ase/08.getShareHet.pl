#!/usr/bin/perl
use strict;
die "Usage:$0 <binom.test in> <output aseEnd file> \n" unless @ARGV==2;
open (IN,"$ARGV[0]") or die "binom.test list file requirement!\n";
open (OUT,">$ARGV[1]") or die "output aseEnd file requirement!\n";

my %refCount;
my %hash;
while(<IN>){
	chomp;
	open (IN1,"$_") or die "$_ file requirement\n";
	my $sample=$_;
	$sample=~s/.aseBinom//;
	$sample=~s/\/(.*)\///;
	while(<IN1>){
		chomp;
		next if (/^V1/);
		my @F=split/\t/,$_;
		my $pos=$F[0]."\t".$F[1];
		$hash{$F[0]}{$F[1]}=1;
		$refCount{$pos}{$sample}=$F[4];
	}
}

my %anno;

foreach my $key1 (sort {$a <=> $b} keys %hash){
	foreach my $key2 (sort {$a <=> $b} keys %{$hash{$key1}}){
		my $key3 = $key1."\t".$key2;
		my @pos=split/\t/,$key3;
		my $hetCount;
		foreach my $key4 (sort {$a <=> $b} keys %{$refCount{$key3}}){
			$hetCount++;
		}
		if ($hetCount > 5){
			print OUT "$pos[0]\t$pos[1]\n";
		}
	}
}


close IN;
close IN1;
close OUT;
