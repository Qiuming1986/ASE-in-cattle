#!/usr/bin/perl
use strict;
die "Usage: $0 <ase list> <out>\n" unless @ARGV==2;
open (IN,"$ARGV[0]") or die "ase list file requirement!\n";
open (OUT,">$ARGV[1]") or die "out file\n";
my %hash;
my @ununiqProject;
my @ununiqTissue;
while(<IN>){
	chomp;
	open (IN1,"$_");
	my $tmp=$_;
	$tmp=~s/^(.*)\///;
	my $project=(split/\./,$tmp)[0];
	my $tissue=(split/\./,$tmp)[1];
	push @ununiqProject,$project;
	push @ununiqTissue,$tissue;
	while(<IN1>){
		chomp;
		next if (/^Chr/);
		my @F=split/\t/,$_;
		next if ($F[8] =~ /\+-/);
		$hash{$F[0]}{$F[1]}{$project}{$tissue}=$F[8];
	}
}
my %count;
my @project = grep { ++$count{ $_ } < 2; } @ununiqProject;
my %count;
my @tissue = grep { ++$count{ $_ } < 2; } @ununiqTissue;
my %hashout;
foreach my $key1 (keys %hash){
	foreach my $key2 (keys %{$hash{$key1}}){
		foreach my $index1 (0..$#project){
			my $project = $project[$index1];
			foreach my $index2 (0..$#tissue){
				my $tissue1 = $tissue[$index2];
				foreach my $index4 (($index1+1)..$#project){
					my $project2 = $project[$index4];
					if ((exists $hash{$key1}{$key2}{$project}{$tissue1})&&(exists $hash{$key1}{$key2}{$project2}{$tissue1})){
						$hashout{$project}{$project2}{$tissue1}=1;
						open (OUT1,">>$project.$project2.$tissue1.aFC");
						print OUT1 ">$key1\t$key2\t$hash{$key1}{$key2}{$project}{$tissue1}\t$hash{$key1}{$key2}{$project2}{$tissue1}\n";
					}
				}
			}
		}
		delete $hash{$key1}{$key2};
	}
}
foreach my $key1 (keys %hashout){
	foreach my $key2 (keys %{$hashout{$key1}}){
		foreach my $key3 (keys %{$hashout{$key1}{$key2}}){
			my $count=`wc -l $key1.$key2.$key3.aFC`;
			next if ($count < 12);
			open (OUTR,">tmp.r");
			print OUTR "a<-read.table(\"$key1.$key2.$key3.aFC\",header=F,sep=\"\\t\")\n";
			print OUTR "results <- cor.test(a[,3],a[,4])\n";
			print OUTR "results\$p.value\n";
			print OUTR "results\$estimate\n";
			my $output = `Rscript tmp.r`;
			my @F=split/\s+/,$output;
			my $pvalue=$F[1];
			my $coeff=$F[3];
			print OUT "$key1\t$key2\t$key3\t$coeff\t$pvalue\n";
		}
	}
}

close IN;
close IN1;
close OUT;
close OUT1;
