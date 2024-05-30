#!/usr/bin/perl
#download sra database, condition 1: search "cattle"; 2: the source is RNA
use strict;
open (IN1,"$ARGV[0]") or die "download sra table requirement!\n";
open (IN2,"$ARGV[1]") or die "download sra table requirement!\n";
open (IN3,"$ARGV[2]") or die "BigVSSmallTissue class file requirement!\n";
open (OUT,">$ARGV[3]") or die "Out file requirement!\n";

my %sample;
my %hash;
while(<IN1>){
	chomp;
	next unless (/fastq/);#retain fastq format
	s/"(.*?)"/unuseful/g;
	s/ /_/g;
	s/,,/,NA,/g;
	s/,,/,NA,/g;
	s/,$/,NA/;
	my @F=split/,/,$_;
	next unless ($F[1] eq "RNA-Seq");#retain RNA-seq
	next unless (($F[10] =~ /Bos_indicus/)||($F[10] =~ /Bos_taurus/));#retain Bos indicus / Bos taurus
	next unless (($F[11] =~ /ILLUMINA/)||($F[11] =~ /BGISEQ/));#retain platform
	next if (($F[25] eq "NA") && ($F[28] eq "NA")); #exclude no tissue info
	next if (($F[25] eq "NA") && ($F[28] eq "unuseful"));
	next if (($F[25] eq "NA") && ($F[28] eq "not_applicable"));
	next if (($F[25] eq "not_applicable") && ($F[28] eq "NA"));
	if (($F[25] eq "not_applicable") && ($F[28] eq "not_applicable")){
		print "$_\n";
	}
	if (/PRJNA723165/){
		print "$_\n";
	}
	next if (exists $sample{$F[2]}); #avoid re-count in the time of one sample vs multuple run
	$sample{$F[2]}=1;
	if ($F[25] ne "NA"){
		$hash{$F[15]}{$F[25]}++;
	}elsif($F[28] ne "NA"){
		$hash{$F[15]}{$F[28]}++;
	}
}
my %hash_tissue;
while(<IN3>){
	chomp;
	my @tissue=split/\s+/,$_;
	$hash_tissue{$tissue[0]}=$tissue[1];
}
print OUT "Run\tBioSample\tOrganism\tBioProject\tsmallTissue\tbigTissue\tBreed\tSex\tAge\n";
open (TMP,">tmp.txt");
while(<IN2>){
	chomp;
	next unless (/fastq/);#retain fastq format
	s/"(.*?)"/unuseful/g;
	s/ /_/g;
	s/,,/,NA,/g;
	s/,,/,NA,/g;
	s/,$/,NA/;
	my @tmp=split/,/,$_;
	next unless ($tmp[1] eq "RNA-Seq");#retain RNA-seq
	next unless (($tmp[10] =~ /Bos_indicus/)||($tmp[10] =~ /Bos_taurus/));#retain Bos indicus / Bos taurus
	next unless (($tmp[11] =~ /ILLUMINA/)||($tmp[11] =~ /BGISEQ/));#retain platform
	next if (($tmp[15] eq "NA") && ($tmp[25] eq "NA")); #exclude no tissue info
	next if (($tmp[25] eq "NA") && ($tmp[28] eq "not_applicable"));
	next if (($tmp[25] eq "not_applicable") && ($tmp[28] eq "not_applicable"));
	next if (($tmp[25] eq "NA") && ($tmp[28] eq "unuseful"));
	next if (($tmp[25] eq "not_applicable") && ($tmp[28] eq "NA"));
	if (($hash{$tmp[15]}{$tmp[25]} >= 20) || ($hash{$tmp[15]}{$tmp[28]} >= 20)){
		print TMP "$tmp[0]\t$tmp[2]\t$tmp[10]\t$tmp[15]\t$tmp[25]\t$tmp[26]\t$tmp[27]\t$tmp[28]\t$tmp[30]\n";
	}
}
open (IN4,"tmp.txt");
while(<IN4>){
	chomp;
	s/Holstein_\d+/Holstein/;
	s/Heifer_cow/Holstein/;
	s/Holstein-Freisan/Holstein/;
	s/Holstein-Friesan/Holstein/;
	s/Holstein-Friesian/Holstein/;
	s/Holstein_cattle/Holstein/;
	s/Holstein_Friesian/Holstein/;
	s/unuseful/NA/;
	s/not_collected/NA/;
	s/not_applicable/NA/;
	s/Missing/NA/;
	s/Chinese_Holstein/Holstein/;
	s/cattle/NA/;
	s/Bovine_//;
	s/Hypothalmus/Hypothalamus/;
	s/\tadipose\t/\tAdipose\t/;
	s/\tblastocyst\t/\tBlastocyst\t/;
	s/\tblood\t/\tBlood\t/;
	s/\tblood_Neutrophils\t/\tBlood_Neutrophils\t/;
	s/\tbovine_blastocysts\t/\tBlastocysts\t/;
	s/\tbovine_embryo\t/\tEmbryo\t/;
	s/\tbovine_monocyte-derived_macrophage\t/\tMonocyte-derived_macrophage\t/;
	s/\tbronchial_lymph_node\t/\tBronchial_lymph_node\t/;
	s/\tcolon\t/\tColon\t/;
	s/\tcumulus_cells\t/\tCumulus_cells\t/;
	s/\tearly_blastocyst\t/\tEarly_blastocyst\t/;
	s/\tembryo-_blastocyst\t/\tEmbryo-_blastocyst\t/;
	s/\tembryonic_disc\t/\tEmbryonic_disc\t/;
	s/\tendometrial_biopsy\t/\tEndometrial_biopsy\t/;
	s/\tendometrium\t/\tEndometrium\t/;
	s/\textraembryonic_tissue\t/\tExtraembryonic\t/;
	s/\tgranulosa_cells\t/\tGranulosa_cells\t/;
	s/\tiPSC_nuclear_transfer_embryo\t/\tiPSC_nuclear_transfer_embryo\t/;
	s/\tin_vitro_fertilization_embryo\t/\tIn_vitro_fertilization_embryo\t/;
	s/\tjejunal_epithelium\t/\tJejunal_epithelium\t/;
	s/\tleukocytes\t/\tLeukocytes\t/;
	s/\tliver\t/\tLiver\t/;
	s/\tlongissimus_dorsi\t/\tLongissimus_dorsi\t/;
	s/\tlung_lesion\t/\tLung_lesion\t/;
	s/\tlung_nonlesiononal\t/\tLung_nonlesiononal\t/;
	s/\tmammary_gland\t/\tMammary_gland\t/;
	s/\tmaternal_blood_leucocytes\t/\tMaternal_blood_leucocytes\t/;
	s/\tmediastinal_lymph_node\t/\tMediastinal_lymph_node\t/;
	s/\tmesenteric_fat\t/\tMesenteric_fat\t/;
	s/\tmilk_cells\t/\tMilk_somatic_cells\t/;
	s/\tmuscle\t/\tMuscle\t/;
	s/\toocyte\t/\tOocyte\t/;
	s/\toocytes\t/\tOocytes\t/;
	s/\tovary\t/\tOvary\t/;
	s/\toviduct_luminal_fluid\t/\tOviduct_luminal_fluid\t/;
	s/\tplacental_caruncle\t/\tPlacental_caruncle\t/;
	s/\tplacental_cotyledon\t/\tPlacental_cotyledon\t/;
	s/\trumen_content\t/\tRumen_content\t/;
	s/\trumen_epithelial_tissue\t/\tRumen_epithelial_tissue\t/;
	s/\trumen_epithelium\t/\tRumen_epithelium\t/;
	s/\trumen_papillae\t/\tRumen_papillae\t/;
	s/\tskin\t/\tSkin\t/;
	s/\tsomatic_cell_nuclear_transfer_embryo\t/\tSomatic_cell_nuclear_transfer_embryo\t/;
	s/\tsomatic_cells_in_the_milk\t/\tMilk_somatic_cells\t/;
	s/\tsubcutaneous_backfat_tissue\t/\tSubcutaneous_backfat_tissue\t/;
	s/\tsubcutaneous_fat\t/\tSubcutaneous_fat\t/;
	s/\tuterine_endometrial_tissue\t/\tUterine_endometrial_tissue\t/;
	s/\twhite_blood_cells\t/\tWhite_blood_cells\t/;
	s/\twhole_blood\t/\tWhole_blood\t/;
	s/\tSubcutaneous_Adipose_tissue\t/\tSubcutaneous_adipose\t/;
	s/\tSubcutaneous_fat\t/\tSubcutaneous_adipose\t/;
	s/\tBlood\t/\tWhole_blood\t/;
	s/\tSubcutaneous_Adipose\t/\tSubcutaneous_adipose\t/;
	s/\tOocytes\t/\tOocyte\t/;
	s/\tWhite_blood_cells\t/\tWhite_blood_cell\t/;
	s/\tWhite_Blood_Cells\t/\tWhite_blood_cell\t/;
	s/\tWhite_Blood_cells\t/\tWhite_blood_cell\t/;
	s/macrophages/macrophage/;
	s/cells/cell/;
	s/Granulosa_Cell/Granulosa/;
	s/Granulosa_cell/Granulosa/;
	s/\tWhole_Blood\t/\tWhole_blood\t/;
	s/Longissimus_dorsi_muscle/Longissimus_dorsi/;
	s/\tBlastocysts\t/\tBlastocyst\t/;
	s/Cell/cell/;
	s/\tAdipose_tissue\t/\tAdipose\t/;
	s/\tBos_taurus_embryo/\tEmbryo/;
	s/\tfetal_fibroblast/\tFetal_fibroblast/;
	s/Milk_cells/Milk_somatic_cell/;
	s/Embryo-_blastocyst/Blastocyst/;
	s/Early_blastocyst/Blastocyst/;
	s/Lung_Lessions/Lung_Lession/;
	s/Lung_lesion/Lung_Lession/;
	s/Day_14_embryonic_cell/Embryo/;
	s/Lung_Healthy/Lung/;
	s/Arcuate_Nucleus_of_the_Hypothalamus/Arcuate_Nucleus/;
	s/Mammary_gland/Mammary/;
	s/Arcuate_Nucleus/Arcuate_nucleus/;
	s/Peripheral_white_blood_cell/White_blood_cell/;
	my @F=split/\t/,$_;
	if ($F[4] eq "NA"){
		print OUT "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[7]\t$hash_tissue{$F[7]}\t$F[5]\t$F[6]\t$F[8]\n";
	}else{
		print OUT "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[4]\t$hash_tissue{$F[4]}\t$F[5]\t$F[6]\t$F[8]\n";
	}
}
system("rm -f tmp.txt");

close IN1;
close IN2;
close IN3;
close OUT;
