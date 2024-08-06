#!/usr/bin/perl
use strict;
die "Usage: $0 <het list> <ase list> <replicate out>\n" unless @ARGV==4;
open (IN1,"$ARGV[0]") or die "het list file requirement!\n";
open (IN2,"$ARGV[1]") or die "ase list file requirement!\n";
open (OUT,">$ARGV[2]") or die "replicate out file\n";
open (OUT1,">$ARGV[3]") or die "exclusively tissue out file\n";
my %count;
while(<IN1>){
	chomp;
	open (IN11,"$_");
	my $tmp=$_;
	$tmp=~s/^(.*)\///;
	my $project=(split/\./,$tmp)[0];
	my $tissue=(split/\./,$tmp)[1];
	while(<IN11>){
		chomp;
		my @tmp=split/\t/,$_;
		$count{$project}{$tissue}{$tmp[0]}{$tmp[1]}=1;
	}
}
my %hash;
my @project;
my @tissue;
my %tissue;
while(<IN2>){
	chomp;
	open (IN22,"$_");
	my $tmp=$_;
	$tmp=~s/^(.*)\///;
	my $project=(split/\./,$tmp)[0];
	my $tissue=(split/\./,$tmp)[1];
	push @project,$project;
	push @tissue,$tissue;
	while(<IN22>){
		chomp;
		next if (/^Chr/);
		my @F=split/\t/,$_;
		$hash{$project}{$tissue}{$F[0]}{$F[1]}=1;
		$tissue{$F[0]}{$F[1]}{$tissue}=1;
	}
}
my %replicateSameProject;
my %replicateSameTissue;
foreach my $key1 (keys %hash){
	foreach my $key2 (keys %{$hash{$key1}}){
		my %totalSameTissue;
		my %replicateSameTissue;
		my %replicateSameProject;
		my %totalSameProject;
		foreach my $key3 (keys %{$hash{$key1}{$key2}}){
			foreach my $key4 (keys %{$hash{$key1}{$key2}{$key3}}){
				foreach my $index (0..$#project){
					my $project=$project[$index];
					if ($project ne "$key1"){
						if (exists $count{$project}{$key2}{$key3}{$key4}){
							$totalSameTissue{$project}++;
						}
						if (exists $hash{$project}{$key2}{$key3}{$key4}){
							$replicateSameTissue{$project}++;
						}
					}
				}
				foreach my $index (0..$#tissue){
					my $tissue=$tissue[$index];
					if ($tissue ne "$key2"){
						if (exists $count{$key1}{$tissue}{$key3}{$key4}){
							$totalSameProject{$tissue}++;
						}
						if (exists $hash{$key1}{$tissue}{$key3}{$key4}){
							$replicateSameProject{$tissue}++;
						}
					}
				}
			}
		}
		foreach my $key5 (keys %replicateSameProject){
			my $rate=$replicateSameProject{$key5}/$totalSameProject{$key5};
			print OUT "$key1\t$key1\t$key2\t$key5\t$rate\tSameProject\n";
		}
		foreach my $key6 (keys %replicateSameTissue){
			my $rate=$replicateSameTissue{$key6}/$totalSameTissue{$key6};
			print OUT "$key1\t$key6\t$key2\t$key2\t$rate\tSameTissue\n";
		}
	}
}
my %countTissue;
foreach my $key1 (keys %tissue){
	foreach my $key2 (keys %{$tissue{$key1}}){
		my $total;
		foreach my $key3 (keys %{$tissue{$key1}{$key2}}){
			$total++;
		}
		$countTissue{$total}++;
	}
}
foreach my $key (keys %countTissue){
	print OUT1 "$key\t$countTissue{$key}\n";
}
close IN1;
close IN11;
close IN2;
close IN22;
close OUT;
close OUT1;
