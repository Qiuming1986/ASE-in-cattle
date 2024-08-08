#!/usr/bin/perl
use strict;
die "Usage: $0 <ase list> <aseaFC out> <ase position>\n" unless @ARGV==3;
open (IN,"$ARGV[0]") or die "ase list file requirement!\n";
open (OUT1,">$ARGV[1]") or die "aseaFC out file\n";
open (OUT2,">$ARGV[2]") or die "ase position out file\n";
my %hash;
while(<IN>){
	chomp;
	open (IN22,"$_");
	while(<IN22>){
		chomp;
		next if (/^Chr/);
		my @F=split/\t/,$_;
		if ($F[8] =~ /\+/){
			$hash{$F[0]}{$F[1]}=1;
		}
	}
}
my %pos;
open (IN,"$ARGV[0]") or die "ase list file requirement!\n";
while(<IN>){
	chomp;
	open (IN2,"$_");
	while(<IN2>){
		chomp;
		next if (/^Chr/);
		my @F=split/\t/,$_;
		if (exists $hash{$F[0]}{$F[1]}){
		}else{
			print OUT1 "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[8]\n";
			$pos{$F[0]}{$F[1]}=1;
		}
	}
}
foreach my $key1 (sort {$a <=> $b} keys %pos){
	foreach my $key2 (sort {$a <=> $b} keys %{$pos{$key1}}){
		print OUT2 "$key1\t$key2\t$key2\n";
	}
}
close IN;
close IN22;
close IN2;
close OUT1;
close OUT2;
