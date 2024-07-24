#!/usr/bin/perl
use strict;
use Math::Stat;
die "Usage:$0 <binom.test in> <annotation file> <output aseEnd file> \n" unless @ARGV==3;
open (IN,"$ARGV[0]") or die "binom.test list file requirement!\n";
open (ANNO,"gzip -dc $ARGV[1] |") or die "annotation file requirement!\n";
open (OUT,">$ARGV[2]") or die "output aseEnd file requirement!\n";

my %refAllele;
my %altAllele;
my %refCount;
my %altCount;
my %sig;
my $total;
my %hash;
while(<IN>){
	chomp;
	$total++;
	open (IN1,"$_") or die "$_ file requirement\n";
	my $sample=$_;
	$sample=~s/.aseBinom//;
	$sample=~s/\/(.*)\///;
	while(<IN1>){
		chomp;
		next if (/^V1/);
		my @F=split/\t/,$_;
		my $pos=$F[0]."\t".$F[1];
		$refAllele{$pos}=$F[2];
		$altAllele{$pos}=$F[3];
		$hash{$F[0]}{$F[1]}=1;
		$refCount{$pos}{$sample}=$F[4];
		$altCount{$pos}{$sample}=$F[5]-$F[4];
		$sig{$pos}{$sample}=$F[7];
	}
}

my %anno;
while(<ANNO>){
	chomp;
	my @gene=split/\t/,$_,6;
	$anno{$gene[0]}{$gene[1]} = $gene[5];
}

print OUT "Chr\tposition\trefAllele\taltAllele\tsampleCount\thetCount\tsigCount\tsigSameDirectionCount\taFC\tFunc.refGene\tGene.refGene\tGeneDetail.refGene\tExonicFunc.refGene\tAAChange.refGene\n";


foreach my $key1 (sort {$a <=> $b} keys %hash){
	foreach my $key2 (sort {$a <=> $b} keys %{$hash{$key1}}){
		my $key3 = $key1."\t".$key2;
		my @pos=split/\t/,$key3;
		my $hetCount;
		my $sigCount;
		my $sigSameDirectionCount=0;
		my @aFC;
		foreach my $key4 (sort {$a <=> $b} keys %{$refCount{$key3}}){
			$hetCount++;
			if ($sig{$key3}{$key4} < 0.05){
				$sigCount++;
				my $aFC=$altCount{$key3}{$key4}/$refCount{$key3}{$key4};
				push @aFC,$aFC;
				if ($refCount{$key3}{$key4} < $altCount{$key3}{$key4}){
					$sigSameDirectionCount++;
				}
			}
		}
		my $aFC = join "|",@aFC;
		my $sigRatio = $sigCount/$hetCount;
		if (($hetCount > 5) && ($sigRatio > 0.9)){
			print OUT "$pos[0]\t$pos[1]\t$refAllele{$key3}\t$altAllele{$key3}\t$total\t$hetCount\t$sigCount\t$sigSameDirectionCount\t$aFC\t$anno{$pos[0]}{$pos[1]}\n";
		}
	}
}


close IN;
close IN1;
close OUT;
