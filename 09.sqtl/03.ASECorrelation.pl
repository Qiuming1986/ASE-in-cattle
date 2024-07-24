#!/usr/bin/perl
die "Usage:$0 <subset name vs ase vs vcf vs additive vs dominant aFC>\n" unless @ARGV==1;
open (IN,"$ARGV[0]") or "cannot open subset name vs ase vs vcf vs additive vs dominant aFC file\n";

my %refalleleASE;
my %aseaFC;
my %refalleleeQTL;
my %addaFC;
my %addtvalue;
my %domaFC;
my %domtvalue;
my %addestimate;#Is the additive (1/1) effect exists

while(<IN>){
	chomp;
	my @input=split/\t/,$_;
	open (IN1,"$input[1]") or "cannot open $input[1] file\n";
	while(<IN1>){
		chomp;
		my @F=split/\t/,$_;
		$refalleleASE{$input[0]}{$F[0]}{$F[1]}=$F[2];
		next if ($F[8] =~ /\+/);
		$aseaFC{$input[0]}{$F[0]}{$F[1]}=$F[8];
		#print "$input[0]\t$F[0]\t$F[1]\t$F[8]\n";
	}
	open (IN2,"gzip -dc $input[2] |") or die "cannot open $input[2] file\n";
	while(<IN2>){
		chomp;
		next if (/^#/);
		my @F=split/\t/,$_;
		$refalleleeQTL{$input[0]}{$F[0]}{$F[1]}=$F[3];
		if (/1\/1/){
			$addestimate{$input[0]}{$F[0]}{$F[1]} = "YES";
		}
	}
	open (IN3,"$input[3]") or die "cannot open $input[3] file\n";
	while(<IN3>){
		chomp;
		next if (/^gene/);
		my @F=split/\s+/,$_;
		$addaFC{$input[0]}{$F[8]}{$F[9]}{$F[0]} = $F[16];
		next if ($F[15] == 0);
		my $tvalue=$F[14]/$F[15];
		$addtvalue{$input[0]}{$F[8]}{$F[9]}{$F[0]} = $tvalue;
	}
	open (IN4,"$input[4]") or die "cannot open $input[4] file\n";
	while(<IN4>){
		chomp;
		next if (/^gene/);
		my @F=split/\s+/,$_;
		$domaFC{$input[0]}{$F[8]}{$F[9]}{$F[0]} = $F[16];
		next if ($F[15] == 0);
		my $tvalue=$F[14]/$F[15];
		$domtvalue{$input[0]}{$F[8]}{$F[9]}{$F[0]} = $tvalue;
	}
}
print "input file read complete!\n";
foreach my $key1 (keys %aseaFC){
	foreach my $key2 (keys %{$aseaFC{$key1}}){
		foreach my $key3 (keys %{$aseaFC{$key1}{$key2}}){
			next unless (exists $addestimate{$key1}{$key2}{$key3});
			foreach my $key4 (keys %{$addaFC{$key1}{$key2}{$key3}}){
				open (ADD,">>ase.add.cor");
				if ($refalleleASE{$key1}{$key2}{$key3} eq "$refalleleeQTL{$key1}{$key2}{$key3}"){
					if ((($aseaFC{$key1}{$key2}{$key3}>0)&&($addaFC{$key1}{$key2}{$key3}{$key4}>0))||(($aseaFC{$key1}{$key2}{$key3}<0)&&($addaFC{$key1}{$key2}{$key3}{$key4}<0))){
						print ADD "$key1\t$key2\t$key3\t$key4\t$aseaFC{$key1}{$key2}{$key3}\t$addaFC{$key1}{$key2}{$key3}{$key4}\n";
					}
				}else{
					my $add = -$addaFC{$key1}{$key2}{$key3}{$key4};
					if ((($aseaFC{$key1}{$key2}{$key3}>0)&&($add>0))||(($aseaFC{$key1}{$key2}{$key3}<0)&&($add<0))){
						print ADD "$key1\t$key2\t$key3\t$key4\t$aseaFC{$key1}{$key2}{$key3}\t$add\n";
					}
				}	
				if (exists $domaFC{$key1}{$key2}{$key3}{$key4}){
					open (CLASS,">>ase.domclass.cor");
					next unless ((exists $addtvalue{$key1}{$key2}{$key3}{$key4}) && (exists $domtvalue{$key1}{$key2}{$key3}{$key4}));
					my $add = $addtvalue{$key1}{$key2}{$key3}{$key4};
					my $dom = $domtvalue{$key1}{$key2}{$key3}{$key4};
					my $aFC = $aseaFC{$key1}{$key2}{$key3};
					if ((($aseaFC{$key1}{$key2}{$key3}>0)&&($addaFC{$key1}{$key2}{$key3}{$key4}>0)&&($domaFC{$key1}{$key2}{$key3}{$key4}>0))||(($aseaFC{$key1}{$key2}{$key3}<0)&&($addaFC{$key1}{$key2}{$key3}{$key4}<0)&&($domaFC{$key1}{$key2}{$key3}{$key4}<0))){
						if ($refalleleASE{$key1}{$key2}{$key3} eq "$refalleleeQTL{$key1}{$key2}{$key3}"){
							if ($aFC >0){
								$class = $dom/$add;
								print CLASS "$key1\t$key2\t$key3\t$key4\t$aFC\t$class\n";
							}else{
								my $class = -$dom/$add;
								print CLASS "$key1\t$key2\t$key3\t$key4\t$aFC\t$class\n";
							}
						}else{
							if ($aFC >0){
								$class = $dom/$add;
								print CLASS "$key1\t$key2\t$key3\t$key4\t$aFC\t$class\n";
							}else{
								my $class = -$dom/$add;
								print CLASS "$key1\t$key2\t$key3\t$key4\t$aFC\t$class\n";
							}
						}
					}
				}
			}
			foreach my $key4 (keys %{$domaFC{$key1}{$key2}{$key3}}){
				open (DOM,">>ase.dom.cor");
				if ($refalleleASE{$key1}{$key2}{$key3} eq "$refalleleeQTL{$key1}{$key2}{$key3}"){
					if ((($aseaFC{$key1}{$key2}{$key3}>0)&&($domaFC{$key1}{$key2}{$key3}{$key4}>0))||(($aseaFC{$key1}{$key2}{$key3}<0)&&($domaFC{$key1}{$key2}{$key3}{$key4}<0))){
						print DOM "$key1\t$key2\t$key3\t$key4\t$aseaFC{$key1}{$key2}{$key3}\t$domaFC{$key1}{$key2}{$key3}{$key4}\n";
					}
				}else{
					my $dom = -$domaFC{$key1}{$key2}{$key3}{$key4};
					if ((($aseaFC{$key1}{$key2}{$key3}>0)&&($dom>0))||(($aseaFC{$key1}{$key2}{$key3}<0)&&($dom<0))){
						print DOM "$key1\t$key2\t$key3\t$key4\t$aseaFC{$key1}{$key2}{$key3}\t$dom\n";
					}
				}
			}
		}
	}
}
close IN;
close IN1;
close IN2;
close IN3;
close IN4;
close ADD;
close DOM;
close CLASS;
