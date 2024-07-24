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
		#print "$project\t$tissue\n";
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
				foreach my $index3 (($index2+1)..$#tissue){
					my $tissue2 = $tissue[$index3];
					#print "$key1\t$key2\t$project\t$tissue1\t$tissue2\n";
					if ((exists $hash{$key1}{$key2}{$project}{$tissue1})&&(exists $hash{$key1}{$key2}{$project}{$tissue2})){
						$hashout{$project}{$project}{$tissue1}{$tissue2}=1;
						open (OUT1,">>$project.$project.$tissue1.$tissue2.aFC");
						print OUT1 "$key1\t$key2\t$hash{$key1}{$key2}{$project}{$tissue1}\t$hash{$key1}{$key2}{$project}{$tissue2}\n";
					}
				}
				foreach my $index4 (($index1+1)..$#project){
					my $project2 = $project[$index4];
					foreach my $index5 (0..$#tissue){
						next if ($index5 eq "$index2");
						my $tissue2 = $tissue[$index5];
						if ((exists $hash{$key1}{$key2}{$project}{$tissue1})&&(exists $hash{$key1}{$key2}{$project2}{$tissue2})){
							$hashout{$project}{$project2}{$tissue1}{$tissue2}=1;
							open (OUT1,">>$project.$project2.$tissue1.$tissue2.aFC");
							print OUT1 ">$key1\t$key2\t$hash{$key1}{$key2}{$project}{$tissue1}\t$hash{$key1}{$key2}{$project2}{$tissue2}\n";
						}
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
			foreach my $key4 (keys %{$hashout{$key1}{$key2}{$key3}}){
				my $count=`wc -l $key1.$key2.$key3.$key4.aFC`;
				next if ($count < 12);
				open (OUTR,">tmp.r");
				print OUTR "a<-read.table(\"$key1.$key2.$key3.$key4.aFC\",header=F,sep=\"\\t\")\n";
				print OUTR "results <- cor.test(a[,3],a[,4])\n";
				print OUTR "results\$p.value\n";
				print OUTR "results\$estimate\n";
				my $output = `Rscript tmp.r`;
				my @F=split/\s+/,$output;
				my $pvalue=$F[1];
				my $coeff=$F[3];
				print OUT "$key1\t$key2\t$key3\t$key4\t$coeff\t$pvalue\n";
			}
		}
	}
}

close IN;
close IN1;
close OUT;
close OUT1;
