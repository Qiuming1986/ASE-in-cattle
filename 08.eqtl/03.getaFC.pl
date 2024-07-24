#!/usr/bin/perl
use strict;
die "Usage: $0 <phenotype bed> <nominals.eqtl> <eqtl vcf> <Covariate> <out additive aFC>\n" unless @ARGV==5;
open (IN1,"gzip -dc $ARGV[0] |") or die "phenotype bed file";
open (IN2,"$ARGV[1]") or die "nominals.eqtl file";
open (IN3,"gzip -dc $ARGV[2] |") or die "eqtl vcf file";
open (IN4,"-|","csvtk transpose -t -T $ARGV[3]") or die "Covariate adjust file\n";
open (OUT,">$ARGV[4]") or die "out additive file";

$ARGV[4]=~/^(.*)\//;
my $dir=$1;
my %sample;
my %expression;
while(<IN1>){
	chomp;
	my @F=split/\t/,$_;
	if (/^#C/){
		foreach my $index (6..$#F){
			$sample{$index}=$F[$index];
		}
	}else{
		foreach my $index (6..$#F){
			my $sample=$sample{$index};
			$expression{$F[3]}{$sample}=$F[$index];
		}
	}
}

my %indv;
my %vcf;
while(<IN3>){
	chomp;
	next if (/^##/);
	my @F=split/\t/,$_;
	if (/^#C/){
		foreach my $index (9..$#F){
			$indv{$index}=$F[$index];
		}
	}else{
		foreach my $index (9..$#F){
			my $indv=$indv{$index};
			my $pos=$F[0].":".$F[1];
			my $value;
			if(($F[$index]=~/0\/1/) ||($F[$index]=~/1\/0/)){
				$value=1;
			}elsif($F[$index]=~/0\/0/){
				$value=0;
			}elsif($F[$index]=~/1\/1/){
				$value=2;
			}
			$vcf{$pos}{$indv}=$value;
		}
	}
}
my %adjust;
my $adjustNum;
while(<IN4>){
	chomp;
	my @F=split/\t/,$_,2;
	next if (/^id/);
	$adjust{$F[0]}=$F[1];
	my @tmp=split/\t/,$F[1];
	$adjustNum=@tmp;
}

print OUT "gene\tchr\tstart\tend\tstrand\tnumVariants\tdisGeneVariant\tvariantID\tchrVariant\tstartVariant\tendVariant\tPvalue\tslope\ttopJudge\t\tbeta\tse\taFC\n";
while(<IN2>){
	chomp;
	my @F=split/\s+/,$_;
	next if ($F[11] >= 0.000001);
	open (TMP,">$dir/tmp.txt");
	foreach my $key (keys %indv){
		my $sampleID=$indv{$key};
		print TMP "$expression{$F[0]}{$sampleID}\t$vcf{$F[7]}{$sampleID}\t$adjust{$sampleID}\n";
		#print "$F[0]\t$F[7]\t$key\n";
	}
	print "$dir\n";
	print "$_\n";
	open (OUTR,">$dir/tmp.r");
	print OUTR "a<-read.table(\"$dir/tmp.txt\",header=F,sep=\"\\t\")\n";
	#print OUTR "lm.fit <- lm(expression~geno,data=a)\n";
	print OUTR "lm.fit <- lm(a[,1]~a[,2]";
	foreach my $index (1..$adjustNum){
		my $order=$index+2;
		print OUTR "+a[,$order]";
	}
	print OUTR ",data=a)\n";
	print OUTR "summary_info <- summary(lm.fit)\n";
	print OUTR "intercept <- summary_info\$coefficients[1, 1]\n";
	print OUTR "coeff <- summary_info\$coefficients[2, 1]\n";
	print OUTR "log(abs((2*coeff)/intercept+1))\n";
	print OUTR "coeff\n";
	print OUTR "se <- summary_info\$coefficients[2, 2]\n";
	print OUTR "se\n";
	my $output = `Rscript $dir/tmp.r`;
	my $aFC=(split/\s+/,$output)[1];
	my $beta=(split/\s+/,$output)[3];
	my $se=(split/\s+/,$output)[5];
	my $out=join("\t",@F);
	print OUT "$out\t$beta\t$se\t$aFC\n";
}
close TMP;
close OUT;
close IN1;
close IN2;
close IN3;
close OUTR;
