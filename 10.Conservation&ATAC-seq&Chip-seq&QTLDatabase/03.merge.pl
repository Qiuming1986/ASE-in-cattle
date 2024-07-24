#!/usr/bin/perl
use strict;
die "Usage:$0 <maf pos dir> <phastCons dir> <phyloP dir> <out>\n" unless @ARGV==4;

open (OUT,">$ARGV[3]") or die "out bos taurus conservation file requirement!\n";
print OUT "bosChr\tbosPos\thumanChr\thumanPos\tbases\tphastCons\tphyloP\n";

my %phastCons;
my %phyloP;
my %hash;
foreach my $index (1..22){
	open (IN1,"gzip -dc $ARGV[1]/chr$index.phastCons.gz |") or die "$ARGV[1]/chr$index.phastCons.gz file requirement\n";
	while(<IN1>){
		chomp;
		my @phastCons=split/\t/,$_;
		$phastCons{$phastCons[0]}{$phastCons[1]}=$phastCons[2];
	}
	open (IN2,"gzip -dc $ARGV[2]/chr$index.phyloP.gz |") or die "$ARGV[2]/chr$index.phyloP.gz file requirement\n";
	while(<IN2>){
		chomp;
		my @phyloP=split/\t/,$_;
		$phyloP{$phyloP[0]}{$phyloP[1]}=$phyloP[2];
	}
	open (IN,"gzip -dc $ARGV[0]/chr$index.maf.Pos.gz |") or die "$ARGV[0]/chr$index.maf.Pos.gz file requirement\n";
	while(<IN>){
		chomp;
		my @maf=split/\t/,$_;
		my @base=split//,$maf[4];
		my $base=$base[1].$base[0];
		$hash{$maf[2]}{$maf[3]}=$maf[0]."\t".$maf[1]."\t".$base;
	}
}
foreach my $key1 (sort {$a <=> $b} keys %hash){
	foreach my $key2 (sort {$a <=> $b} keys %{$hash{$key1}}){
		my @human=split/\t/,$hash{$key1}{$key2};
		print OUT "$key1\t$key2\t$human[0]\t$human[1]\t$human[2]";
		if (exists $phastCons{$human[0]}{$human[1]}){
			print OUT "\t$phastCons{$human[0]}{$human[1]}";
		}else{
			print OUT "\tNA";
		}
		if (exists $phyloP{$human[0]}{$human[1]}){
			print OUT "\t$phyloP{$human[0]}{$human[1]}";
		}else{
			print OUT "\tNA";
		}
		print OUT "\n";
	}
}
close IN;
close OUT;
close IN1;
close IN2;
