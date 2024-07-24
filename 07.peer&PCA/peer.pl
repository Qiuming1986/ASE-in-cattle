#!/usr/bin/perl
use strict;
die "Usage:$0<TPM list><out matrix><peer script>\n" unless @ARGV==3;
open (IN,"$ARGV[0]") or die "TPM list file requirement\n";
open (OUT1,">$ARGV[1]") or die "out matrix file requirement\n";
open (OUT2,">$ARGV[2]") or die "out peer script requirement\n";


my $matrix=$ARGV[1];
my @sample;
my @gene;
my %gene;
my %hash;
while(<IN>){
	chomp;
	my @tmp=split/\//,$_;
	push @sample,$tmp[5];
	my $sample=$tmp[5];
	open (IN1,"$_") or die "$_ file requirement\n";
	while (<IN1>){
		chomp;
		if (/^gene/){
			my @F=split/\t/,$_;
			if ($F[2] =~ /^\d+$/){
				unless (exists $gene{$F[0]}){
					push @gene,$F[0];
				}
				$gene{$F[0]}=1;
				my $tpm;
				if (exists $hash{$F[0]}{$sample}){
			      		$tpm=($hash{$sample}{$F[0]}+$F[8])/2;
				}else{
					$tpm=$F[8];
				}
				$hash{$sample}{$F[0]}=$tpm;
			}
		}
	}
}
my $count=@sample;
###retain gene mean expression > 0.1
foreach my $index1 (0..$#gene){
	my $total;
	foreach my $index2 (0..$#sample){
		#print "$hash{$sample[$index2]}{$gene[$index1]}\n";
		$total+=$hash{$sample[$index2]}{$gene[$index1]};
	}
	my $mean=$total/$count;
	if ($mean <= 0.1){
		foreach my $index2 (0..$#sample){
			delete $hash{$sample[$index2]}{$gene[$index1]};
		}
		splice(@gene,$index1,1);
	}
}
###print header
foreach my $index (0..$#gene){
	print OUT1 " $gene[$index]";
}
print OUT1 "\n";

###print matrix
foreach my $index1 (0..$#sample){
	print OUT1 "$sample[$index1]";
	foreach my $index2 (0..$#gene){
		if (exists $hash{$sample[$index1]}{$gene[$index2]}){
			print OUT1 " $hash{$sample[$index1]}{$gene[$index2]}";
		}else{
			print OUT1 " 0";
		}			
	}
	print OUT1 "\n";
}

my $factor;
if ($count > 400){
	$factor=100;
}else{
	$factor=int($count/4);
}
###normalization Graph pangenome captures missing heritability and empowers tomato breeding
print OUT2 "quantile_normalisation <- function(df){\n";
print OUT2 "\tdf_rank <- apply(df,2,rank,ties.method=\"min\")\n";
print OUT2 "\tdf_sorted <- data.frame(apply(df, 2, sort))\n";
print OUT2 "\tdf_mean <- apply(df_sorted, 1, mean)\n";
print OUT2 "\tindex_to_mean <- function(my_index, my_mean){\n";
print OUT2 "\t\treturn(my_mean[my_index])\n";
print OUT2 "\t}\n";
print OUT2 "\tdf_final <- apply(df_rank, 2, index_to_mean, my_mean=df_mean)\n";
print OUT2 "\trownames(df_final) <- rownames(df)\n";
print OUT2 "\treturn(df_final)\n";
print OUT2 "}\n";

print OUT2 "a<-read.table(\"$matrix\",row.names=1,header=TRUE,sep=\" \")\n";
print OUT2 "expr=quantile_normalisation(a)\n";
print OUT2 "library(peer)\n";
print OUT2 "model = PEER()\n";
print OUT2 "PEER_setPhenoMean(model,as.matrix(expr))\n";
print OUT2 "PEER_setNk(model,$factor)\n";
print OUT2 "PEER_getNk(model)\n";
print OUT2 "PEER_update(model)\n";
print OUT2 "PEER_plotModel(model)\n";
#print OUT2 "factors = as.data.frame(t(PEER_getX(model)))\n";
print OUT2 "factors = PEER_getX(model)\n";
print OUT2 "weights = PEER_getW(model)\n";
print OUT2 "precision = PEER_getAlpha(model)\n";
print OUT2 "residuals = PEER_getResiduals(model)\n";
print OUT2 "write.table(residuals,\"./peer_residuals.tsv\",quote=F,row.names=F,sep=\"\\t\",col.names=F)\n";
print OUT2 "write.table(weights,\"./peer_weights.tsv\",quote=F,row.names=F,sep=\"\\t\",col.names=F)\n";
print OUT2 "write.table(precision,\"./peer_precision.tsv\",quote=F,row.names=F,sep=\"\\t\",col.names=F)\n";
print OUT2 "write.table(factors,\"./peer_covariates.tsv\",quote=F,row.names=F,sep=\"\\t\",col.names=F)\n";

close IN;
close IN1;
close OUT1;
close OUT2;
