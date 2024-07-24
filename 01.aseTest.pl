#!/usr/bin/perl
use strict;
die "Usage:$0<gatk ase in> <out dir>\n" unless @ARGV==2;
open(IN,"$ARGV[0]") or die "gatk ase in file requirement!\n";

my $sample=$ARGV[0];
$sample=~s/.ase.tsv//;
$sample=~s/\/(.*)\///;
my $dir=$ARGV[1];
open (OUTsa,">$dir/$sample.aseSNP");

while(<IN>){
	chomp;
	next if (/^contig/);
	my @F=split/\t/,$_;
	my $pos=$F[0]."\t".$F[1];
	next if ($F[5] < 3);
	my $ratio=$F[5]/$F[7];
	if ((($F[5] > 3) &&  ($F[6] > 3)) && (($ratio < 0.99) && ($ratio > 0.01))){
		print OUTsa "$F[0]\t$F[1]\t$F[3]\t$F[4]\t$F[5]\t$F[7]\n";
	}
}

open (OUTR,">$dir/$sample.R");
print OUTR "dat <- read.table(\"$dir/$sample.aseSNP\", header=F,sep=\"\\t\",check.names=F,quote = \"\")\n";
print OUTR "pValue<-numeric(0)\n";
print OUTR "for (i in 1:length(dat[,1])){\n";
print OUTR "a=binom.test(dat[i,5],dat[i,6],p=0.5)\n";
print OUTR "pValue=c(pValue,a\$p.value)}\n";
print OUTR "qValue<-p.adjust(pValue,method=\"fdr\")\n";
print OUTR "dat2=cbind(dat,pValue,qValue)\n";
print OUTR "dat2=dat2[order(dat2\$pValue),]\n";
print OUTR "write.table(dat2,file=\"$dir/$sample.aseBinom\",sep=\"\\t\",quote=F,row.names = F)\n";
system ("Rscript $dir/$sample.R");
system ("rm -f $dir/$sample.R");
system ("rm -f $dir/$sample.aseSNP");

close IN;
close OUTsa;
close OUTR;
