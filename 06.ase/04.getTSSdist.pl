#!/usr/bin/perl
use strict;
die "Usage:$0 <gff> <aseInfo> <out dist>\n" unless @ARGV==3;
open (IN1,"$ARGV[0]") or die "gff file requirement!\n";
open (IN2,"$ARGV[1]") or die "aseInfo file requirement!\n";
open (OUT,">$ARGV[2]") or die "out distance from TSS file requirement!\n";
my %hash;
while(<IN1>){
	chomp;
	if (/^\d+/){
		my @F=split/\t/,$_;
		if ($F[2] =~ /gene/){
			my $gene=$F[8];
			$gene=~s/^(.*?)Name=//;
			$gene=~s/;(.*)$//;
			if ($F[8]=~/;gene_biotype=protein_coding/){
				$hash{$gene}{$F[0]}{$F[3]}=$F[0]."\t".$F[3]."\t".$F[4]."\t".$F[6]."\t"."protein_coding";
			}else{
				$hash{$gene}{$F[0]}{$F[3]}=$F[0]."\t".$F[3]."\t".$F[4]."\t".$F[6]."\t"."other";
			}
		}
	}
}
while(<IN2>){
	chomp;
	my @F=split/\t/,$_;
	if (/^Chr/){
		print OUT "Chr\tposition\trefAllele\taltAllele\tsampleCount\thetCount\tsigCount\tsigSameDirectionCount\taFC\tcloseGene\tdistFromTSS\tFunc.refGene\tGene.refGene\tGeneDetail.refGene\tExonicFunc.refGene\tAAChange.refGene\n";
	}else{
		my $gene;
		if ($F[10] =~ /,/){
			my @gene=split/,/,$F[10];
			if ($gene[0] eq "NONE"){
				$gene = $gene[1];
			}elsif($gene[1] eq "NONE"){
				$gene = $gene[0];
			}else{
				my $distGene=$F[11];
				$distGene=~s/dist=//g;
				my @distGene=split/;/,$distGene;
				if ($distGene[0]<=$distGene[1]){
					$gene=$gene[0];
				}else{
					$gene=$gene[1];
				}
			}
		}elsif($F[10] =~ /;/){
			$gene=(split/;/,$F[10])[0];
		}else{
			$gene=$F[10];
		}
		my $dist=999999999999999;
		my $tssDist;
		my $ctrl=0;
		foreach my $key (keys %{$hash{$gene}{$F[0]}}){
			my @pos=split/\t/,$hash{$gene}{$F[0]}{$key};
			next if ($pos[4] ne "protein_coding");
			my $currentDist;
			if (($F[1]>=$pos[1]) && ($F[1]<=$pos[2])){
				$currentDist=0;
			}elsif($F[1]<$pos[1]){
				$currentDist=abs($pos[1]-$F[1]);
			}else{
				$currentDist=abs($pos[2]-$F[1]);
			}
			if($currentDist<$dist){
				$ctrl++;
				$dist = $currentDist;
				if ($pos[3] eq "+"){
					$tssDist=$F[1]-$pos[1];
				}else{
					$tssDist=$pos[2]-$F[1];
				}
			}
		}
		if ($ctrl > 0){
			print OUT "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[4]\t$F[5]\t$F[6]\t$F[7]\t$F[8]\t$gene\t$tssDist\t$F[9]\t$F[10]\t$F[11]\t$F[12]\t$F[13]\n";
		}
	}
}

close IN1;
close IN2;
close OUT;
