#!/usr/bin/perl
use strict;
die "Usage:$0<pca> <peer matrix> <peer factor> <out fastqtl prepare>\n" unless @ARGV==4;
open (IN1,"$ARGV[0]") or die "pca input file requirement\n";
open (IN2,"$ARGV[1]") or die "peer matrix file requirement\n";
open (IN3,"$ARGV[2]") or die "peer factor file requirement\n";
open (OUT,">$ARGV[3]") or die "out fastqtl file requirement\n";

my %hash;
my @sample;
while(<IN1>){
	chomp;
	my @F=split/\s+/,$_;
	foreach my $index (2..$#F){
		my $pca=$index-1;
		$hash{$pca}{$F[1]}=$F[$index];
	}
	push @sample,$F[1];
}

my %sample;
my $seq=0;
while(<IN2>){
	chomp;
	next if (/^\s+/);
	$seq++;
	my @F=split/\s+/,$_;
	$sample{$seq}=$F[0];
}

my %peer;
my $peerSeq;
while(<IN3>){
	chomp;
	$peerSeq++;
	my $sample=$sample{$peerSeq};
	my @F=split/\s+/,$_;
	foreach my $index (0..9){
		my $peerFactor=$index+1;
		$peer{$peerFactor}{$sample}=$F[$index];
	}
}
print OUT "id";
foreach my $index (0..$#sample){
	print OUT "\t$sample[$index]";
}
print OUT "\n";

my $count=@sample;
my $retainPCA;
if ($count<150){
	$retainPCA=3;
}elsif(($count>=150)&&($count<250)){
	$retainPCA=5;
}else{
	$retainPCA=10;
}

foreach my $key1 (1..$retainPCA){
	print OUT "PC";
	print OUT "$key1";
	foreach my $index (0..$#sample){
		print OUT "\t$hash{$key1}{$sample[$index]}";
	}
	print OUT "\n";
}

foreach my $key1 (sort {$a<=>$b} keys %peer){
	print OUT "Factor";
	print OUT "$key1";
	foreach my $index (0..$#sample){
		print OUT "\t$peer{$key1}{$sample[$index]}";
	}
	print OUT "\n";
}

close IN2;
close OUT;
close IN1;
close IN3;
