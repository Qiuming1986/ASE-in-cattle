#!/usr/bin/perl
use strict;
die "Usage:$0<peer input file><out fastqtl prepare>\n" unless @ARGV==2;
open (OUT,">$ARGV[1]") or die "out fastqtl file requirement\n";

open (OUT2,">tmp.r");
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

print OUT2 "a<-read.table(\"$ARGV[0]\",row.names=1,header=TRUE,sep=\" \")\n";
print OUT2 "expr=quantile_normalisation(a)\n";
print OUT2 "write.table(expr,\"./tmp.txt\",quote=F,row.names=T,sep=\"\\t\",col.names=T)\n";
system ("Rscript tmp.r");

my %pos;
my %info;
open (IN2,"/home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.gff");
while(<IN2>){
	chomp;
	next if (/^#/);
	my @F=split/\t/,$_;
	next if ($F[0] eq "Y");
	if ($F[2] =~ /gene/){
		my $geneInfo=$F[8];
		$geneInfo=~s/^ID=//;
		$geneInfo=~s/;(.*?)Name=/\t/;
		$geneInfo=~s/;(.*?)$//;
		my $gene=(split/\t/,$geneInfo)[0];
		my $name=(split/\t/,$geneInfo)[1];
		$pos{$gene}=$F[0]."\t".$F[3]."\t".$F[4]."\t".$F[6];
		$info{$gene}=$name;
	}
}
open (IN,"tmp.txt");
open (TMP,">tmp1.txt");
while(<IN>){
	chomp;
	s/^gene/\tgene/;
	print TMP "$_\n";
} 

open (HEAD,">head");
open (IN1,"-|","csvtk transpose -t -T tmp1.txt") or die "tmp file requirement!\n";
while(<IN1>){
	chomp;
	if (/^\s+/){
		print HEAD "#Chr\tstart\tend\tpid\tgid\tstrand\t";
		print HEAD "$_\n";
	}else{
		my @F=split/\t/,$_,2;
		my @info=split/\t/,$pos{$F[0]};
		print OUT "$info[0]\t$info[1]\t$info[2]\t$info{$F[0]}\t$info{$F[0]}\t$info[3]\t$F[1]\n";
	}
}
system("rm -f tmp.txt tmp1.txt");
my $file=$ARGV[1];
system("sort -n -k 1,1 -k 2,2 $file >> head");
system("mv head $file");
system("bgzip $file");
system("tabix -p bed $file.gz");
close IN1;
close IN2;
close OUT;
close TMP;
