java -Xmx250G -XX:+UseParallelGC -XX:ParallelGCThreads=4 -jar gatk-package-4.4.0.0-local.jar ASEReadCounter -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -O SRR13051360.ase.tsv -I SRR13051360.split.bam -V All.clean.SNP.vcf.gz
perl 01.aseTest.pl SRR13051360.ase.tsv /home/chenqiuming/ljq/07.ase/01.binom  ##/home/chenqiuming/ljq/07.ase/01.binom is absolute directory for output
perl 02.populationLevel.pl PRJNA626458.muscle.list All.anno.gz PRJNA626458.muscle.pop ##PRJNA626458.muscle.list is a list file containing the absolute directory of the out file of the 01.aseTest.pl script for each sample in a subset, All.anno.gz is the annoation file supplied by ANNOVAR, PRJNA626458.muscle.pop is the output in population level
perl 03.aFC.pl PRJNA626458.muscle.pop PRJNA626458.muscle.aseInfo
perl 04.getTSSdist.pl ARS-UCD1.2_Btau5.0.1Y.gff PRJNA626458.muscle.aseInfo PRJNA626458.muscle.TSSdist.aseInfo
perl 05.differentTissueCorrelation.pl list cor ####calculate the Pearson correlation coefficient of effect size between different tissue                     ###  list file include the absolute directory of all XXX.aseIno file supplied by 03.aFC.pl 
perl 06.sameTissueCorrelation.pl list cor ###calculate the the Pearson correlation coefficient of effect size in the same tissue between different BioProject
vcftools --gzvcf All.vcf.gz --plink --out All ##All.vcf.gz was the file of imputed genotype that was merged from the 7,532 samples and each subset
plink --noweb --file All --make-bed --out All --chr-set 29 --allow-no-sex
plink --noweb --bfile All --r2 --ld-window-r2 0.1 --out All --chr-set 29 --allow-no-sex
perl 07.getIndependentSNPs.pl PRJNA626458.muscle.TSSdist.aseInfo All.bim All.ld PRJNA626458.muscle.indep ##PRJNA626458.muscle.TSSdist.aseInfo is obtained from 04.getTSSdist.pl. All.bim is plink format. All.ld is calculated using plink with "--r2 --ld-window-r2 0.1". PRJNA626458.muscle.indep is the outfile
perl 08.getShareHet.pl PRJNA626458.muscle.list PRJNA626458.muscle.hetPos
perl 09.replicate.pl het.list ase.list replicate.stat exclusive.stat ## het.list is a list file containing the absolute directory of the out file of the 08.getShareHet.pl script for each subset, ase.list is a list file containing the absolute directory of the out file of the 03.aFC.pl script for each subset, replicate.stat is a out file that reported the replicate rate between different tissue in the same BioProject and different BioProject in the same tissue, exclusive.stat reported the distribution of the count of tissue for each ASE variants