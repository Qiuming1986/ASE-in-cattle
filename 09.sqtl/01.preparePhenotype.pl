#!/usr/bin/perl
use strict;
die "Usage:$0<cluster file><out fastqtl prepare>\n" unless @ARGV==2;
open (IN,"gzip -dc $ARGV[0] |") or die "cluster file requirement\n";
open (OUT,">$ARGV[1]") or die "out fastqtl file requirement\n";

open (TMP1,">tmp1.txt");
while(<IN>){
	chomp;
	s/^S/\tS/;
	s/ /\t/g;
	next if ((/^X/) || (/^Y/) || (/NK/) || (/^MT/));
	print TMP1 "$_\n"; 	
}
open (IN1,"-|","csvtk transpose -t -T tmp1.txt");
open (TMP2,">tmp2.txt");
while(<IN1>){
	chomp;
	if (/:/){
		print TMP2 " $_\n";
	}else{
		print TMP2 "$_\n";
	}
}	

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

print OUT2 "a<-read.table(\"tmp2.txt\",row.names=1,header=TRUE,sep=\"\\t\")\n";
print OUT2 "expr=quantile_normalisation(a)\n";
print OUT2 "write.table(expr,\"./tmp3.txt\",quote=F,row.names=T,sep=\"\\t\",col.names=T)\n";
system ("Rscript tmp.r");

open (IN2,"tmp3.txt");
open (TMP3,">tmp4.txt");
while(<IN2>){
	chomp;
	s/^X/\tX/;
	s/X//g;
	print TMP3 "$_\n";
}

open (IN3,"-|","csvtk transpose -t -T tmp4.txt");

open (HEAD,">head");

while(<IN3>){
	chomp;
	my @F=split/\s+/,$_;
	if (/^\tS/){
		print HEAD "#Chr\tstart\tend\tpid\tgid\tstrand";
		foreach my $index (1..$#F){
			print HEAD "\t$F[$index]";
		}
		print HEAD "\n";
	}elsif(/^\d/){
		my @info=split/\./,$F[0];
		print OUT "$info[0]\t$info[1]\t$info[2]";
		print OUT "\t$F[0]\t$info[3]\t+";
		foreach my $index (1..$#F){
			print OUT "\t$F[$index]";
		}
		print OUT "\n";
	}
}
my $file=$ARGV[1];
system("sort -n -k 1,1 -k 2,2 $file >> head");
system("mv head $file");
system("bgzip $file");
system("tabix -p bed $file.gz");
close IN1;
close OUT;
close HEAD;
