#!/usr/bin/perl
use strict;
use Math::Stat;
use Math::Complex;
open (IN,"$ARGV[0]");
open (OUT,">$ARGV[1]");
while(<IN>){
	chomp;
	if (/^Chr/){
		print OUT "$_\n";
	}else{
		my @F=split/\t/,$_,10;
		my @aFC=split/\|/,$F[8];
		if (($F[7] == 0)||($F[7] == $F[6])){
			my $stat = Math::Stat->new(\@aFC, { Autoclean => 1 });
			my $median = $stat->median();
			my $aFC = log($median)/log(2);
			print OUT "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[4]\t$F[5]\t$F[6]\t$F[7]\t$aFC\t$F[9]\n";
		}else{
			my @aFCabs;
			foreach my $index (0..$#aFC){
				my $aFC = log($aFC[$index])/log(2);
				my $aFCabs = abs($aFC);
				push @aFCabs,$aFCabs;
			}
			my $stat = Math::Stat->new(\@aFCabs, { Autoclean => 1 });
			my $median = $stat->median();
			print OUT "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[4]\t$F[5]\t$F[6]\t$F[7]\t+-$median\t$F[9]\n";
		}
	}
}
close IN;
close OUT;
#sub log2  { 
#	my $n = shift; 
#	return log($n)/log(2); 
#}
