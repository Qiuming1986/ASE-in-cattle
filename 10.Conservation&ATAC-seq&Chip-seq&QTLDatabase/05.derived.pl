#!/usr/bin/perl
use strict;
die "Usage:$0<vcf><ase><mind><out>\n" unless @ARGV==4;
open (IN1,"gzip -dc $ARGV[0] |") or die "vcf.gz file requirement!\n";
open (IN2,"$ARGV[1]") or die "ase file requirement!\n";
open (OUT,">$ARGV[3]") or die "out file requirement!\n";
my $mind=$ARGV[2];

my %hash;
while(<IN1>){
	chomp;
	next if (/^#/);
	my @F=split/\t/,$_;
	my $total=0;
	my $alt=0;
	foreach my $index (9..$#F){
		if (($F[$index] =~ /^0\/1/)||($F[$index] =~ /^1\|0/)|| ($F[$index] =~ /^0\|1/)){
			$alt++;
			$total++;
		}elsif(($F[$index] =~ /^1\/1/)||($F[$index] =~ /^1\|1/)){
			$alt+=2;
			$total++;
		}elsif(($F[$index] =~ /^0\/0/)||($F[$index] =~ /^0\|0/)){
			$total++;
		}
	}
	next if ($total < $mind);
	my $af=$alt/($total*2);
	if ($af==0){
		$hash{$F[0]}{$F[1]}=$F[3];
	}elsif($af==1){
		$hash{$F[0]}{$F[1]}=$F[4];
	}
}
my $total;
my $change;
my $miss;
while(<IN2>){
	chomp;
	my @F=split/\t/,$_;
	$total++;
	if ($hash{$F[0]}{$F[1]} eq "$F[2]"){
		my $aFC=$F[4];
		print OUT "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$aFC\tNotChanged\n";
	}elsif($hash{$F[0]}{$F[1]} eq "$F[3]"){
		my $aFC=-$F[4];
		print OUT "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$aFC\tChanged\n";
		$change++;
	}else{
		$miss++;
	}
}
print "the number of ase variants is $total\n";
print "the number of ase varaints that derived allele have been changed is $change\n";
print "the number of ase varaints that derived allele could not identified is $miss\n";
close IN1;
close IN2;
close OUT;
