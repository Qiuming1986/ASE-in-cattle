#!/usr/bin/perl
use strict;
die "Usage:$0 <05.dist geneASE> <plink bim> <plink ld> <out>\n" unless @ARGV==4;
open (IN1,"$ARGV[0]") or die "cannot open 05.dist file\n";
open (IN2,"$ARGV[1]") or die "cannot open plink bim file\n";
open (IN3,"$ARGV[2]") or die "cannot open plink ld file\n";
open (OUT,">$ARGV[3]") or die "cannot open out file\n";
my %hashGene;
while(<IN1>){
	chomp;
	my @F=split/\t/,$_;
	next if (/^Chr/);
	my $snp=$F[0].":".$F[1];
	if (exists $hashGene{$F[9]}){
		$hashGene{$F[9]}.="\t".$snp;
		#print "$hashGene{$F[9]}\n";
	}else{
		$hashGene{$F[9]}=$snp;
	}
}
close IN1;

my %hashBim;
while(<IN2>){
	chomp;
	my @F=split/\t/,$_;
	$hashBim{$F[1]}=1;
}
close IN2;

my %hashLd;
while(<IN3>){
	chomp;
	s/^\s+//;
	next if (/CHR/);
	my @ld=split/\s+/,$_;
	if ($ld[6] > 0.6){
		$hashLd{$ld[2]}{$ld[5]}=1;
		#print "$ld[2]\t$ld[5]\n";
	}
}
close IN3;
print "ld file read finished!\n";
#foreach my $key1 (keys %hashLd){
#	foreach my $key2 (keys %{$hashLd{$key1}}){
#		print "$key1\t$key2\n";
#	}
#}
my $total++;
foreach my $key (keys %hashGene) {
	my $changed = 1;
	my @tmp=split/\t/,$hashGene{$key};
	###exclude gene not with complete ASE variants in imputation file
	my $totalSNP=@tmp;
	my $countBim=0;
	foreach my $index (0..$#tmp){
		if (exists $hashBim{$tmp[$index]}){
			$countBim++;
		}
	}
	if ($countBim<$totalSNP){
		next;
	}
	my @tmp1=@tmp;
	my @tmp2;
	#########store ld snp
	foreach my $index1 (0..$#tmp) {
		foreach my $index2 (0..$#tmp) {
			if (exists $hashLd{$tmp[$index1]}{$tmp[$index2]}){
				my $tmp=$tmp[$index1]."-".$tmp[$index2];
				push @tmp2,$tmp;
				#print "$tmp\n";
			}
		}
	}
	##########ld snp merge
	my $changed = 1; # 设置一个变量，用于标记是否进行了变化
	while ($changed) { # 在 while 循环中进行迭代，直到不再有变化发生
        	$changed = 0; # 默认假设没有变化
		#my $i=0;
        	foreach my $index (0..$#tmp2) {
			#print "$tmp2[$index]\n";
                	my @tmp3 = split/-/, $tmp2[$index];
                	foreach my $index1 (0..$#tmp3) {
                        	foreach my $index2 (($index+1)..$#tmp2) {
                                	my @tmp4 = split /-/, $tmp2[$index2];
					foreach my $index3 (0..$#tmp4) {
                                        	if ($tmp3[$index1] eq $tmp4[$index3]) {
							foreach my $index6 ($index..$#tmp2) {
								my @tmp7 = split /-/, $tmp2[$index2];
								foreach my $index7 (0..$#tmp7) {
                                                			foreach my $index4 ($index2..$#tmp2){
										my @tmp6=split/-/,$tmp2[$index4];
										foreach my $index5 (0..$#tmp6){
											if ($tmp7[$index7] eq $tmp6[$index5]){
												@tmp3=(@tmp3,@tmp6);
											}
										}
									}
								}
							}
							my @tmp5=(@tmp3,@tmp4);
							my %seen;
							my @unique = grep { !$seen{$_}++ } @tmp5;
							my $tmp5=join "-",@unique;
							$tmp2[$index]=$tmp5;
                                                	@tmp2 = grep { $_ ne $tmp2[$index2] } @tmp2; # 移除 $Ld[$index2]
                                                	$changed = 1; # 设置标记为真，表示发生了变化
						}
                                        }
                                }
                        }
                }
	}
	my $countSNP;
	foreach my $index8 (0..$#tmp2){
		my @tmp7=split/-/,$tmp2[$index8];
		foreach my $index9 (0..$#tmp7){
			$countSNP++;
			@tmp1 = grep { $_ ne $tmp7[$index9] } @tmp1;
		}
	}
	my @tmp6=(@tmp2,@tmp1);
	my $tmp6=join "|",@tmp6;
	my $countIndep=@tmp6;
	$countSNP+=@tmp1;
	$total+=$countSNP;
	print OUT "$key\t$countIndep\t$countSNP\t$tmp6\n";
}
print "The number of SNPs is $total\n";
close OUT;
