#!/usr/bin/perl
use strict;
die "Usage:$0<maf> <out pos>\n" unless @ARGV==2;
open (IN,"gzip -dc $ARGV[0] |") or die "maf file requirement!\n";
open (OUT,"> $ARGV[1]") or die "out pos file requirement!\n";

open (TMP1,">tmp1.txt");
while(<IN>){
	chomp;
	if (/s hg38/){
		print TMP1 "\n$_";
	}elsif(/s bosTau9/){
		print TMP1 "\t$_";
	}
}
open (IN1,"tmp1.txt");
while(<IN1>){
        chomp;
	s/s //g;
	my @F=split/\t/,$_;
	my $n=@F;
	if ($n==2){
		my @human=split/\s+/,$F[0];
		my @bos=split/\s+/,$F[1];
		my $chr_h=$human[0];
		$chr_h=~s/hg38.chr//;
		my $chr_b=$bos[0];
		$chr_b=~s/bosTau9.chr//;
		my $start_h=$human[1];
		my $start_b=$bos[1];
		my @seq_h=split//,$human[5];
		my @seq_b=split//,$bos[5];
		#print "$human[5]\t$bos[5]\n";
		foreach my $index (0..$#seq_h){
			if ($seq_h[$index] =~ /A|T|C|G|N/i){
                        	if ($human[3] eq "+"){
                                	$start_h++;
                                }elsif($human[3] eq "-"){
                                        $start_h--;
                                }
                        }
                        if ($seq_b[$index] =~ /a|t|c|g|n/i){
                                if ($bos[3] eq "+"){
                                	$start_b++;
                                }elsif($bos[3] eq "-"){
                                       	$start_b--;
				}
			}
			#print "$seq_h[$index]\t$seq_b[$index]\n";
			if (($seq_h[$index] =~ /a|t|c|g|n/i) && ($seq_b[$index] =~ /a|t|c|g|n/i)){
				print OUT $chr_h."\t".$start_h."\t".$chr_b."\t".$start_b."\t".$seq_h[$index].$seq_b[$index]."\n";
			}
		}
	}
}
close IN;
close OUT;
close TMP1;
close IN1;
