perl 01.prepareCovariate.pl All.eigenvec PRJNA626458.muscle.matrix peer_covariates.tsv Covariate
perl 02.preparePhenotype.pl PRJNA626458.muscle.matrix phenotype.bed  ##phenotype.bed is the output file, and finally the step will generate a file of "phenotype.bed.gz"

##additive effect
QTLtools cis --vcf All.vcf.gz --bed phenotype.bed.gz --cov Covariate --nominal 0.01 --out All.nominals.txt ##All.vcf.gz is the imputed genotype file that merged from 7,532 file and the subset file               phenotype.bed.gz is the outfile of preparePhenotype.pl           Covariate is the same file as the cis-eQTL                      All.nominals.txt is the outfile
awk '$12<0.000001' All.nominals.txt > All.nominals.E-6.txt
perl 03.getaFC.pl phenotype.bed.gz All.nominals.E-6.txt All.vcf.gz Covariate All.nominals.E-6.addaFC.txt       ##phenotype.bed.gz is the outfile of preparePhenotype.pl All.nominals.E-6.txt is the out file of previous step   All.vcf.gz is the imputed genotype file that merged from 7,532 file and the subset file  Covariate is the same file as the cis-eQTL    All.nominals.E-6.addaFC.txt is the outfile

##dominant effect
perl 04.domGenotype.pl All.vcf.gz All.dom.vcf.gz
QTLtools cis --vcf All.dom.vcf.gz --bed phenotype.bed.gz --cov Covariate --nominal 0.01 --out All.nominals.txt ##All.vcf.gz is the imputed genotype file that merged from 7,532 file and the subset file               phenotype.bed.gz is the outfile of preparePhenotype.pl           Covariate is the same file as the cis-eQTL                      All.nominals.txt is the outfile
awk '$12<0.000001' All.nominals.txt > All.nominals.E-6.txt
perl 03.getaFC.pl phenotype.bed.gz All.nominals.E-6.txt All.dom.vcf.gz Covariate All.nominals.E-6.addaFC.txt       ##phenotype.bed.gz is the outfile of preparePhenotype.pl All.nominals.E-6.txt is the out file of previous step   All.vcf.gz is the imputed genotype file that merged from 7,532 file and the subset file  Covariate is the same file as the cis-eQTL    All.nominals.E-6.addaFC.txt is the outfile

##calculate the pearson corelation coeffecient
perl 05.ASECorrelation.pl list ###the list file contains 5 column, the first is the name of the subset, the second is the ase information file supplied by 03.aFC.pl in ase identification, the third is the imputed genotype file that merged from 7,532 file and the subset file, the fourth and the fifth files were the final file of additive and dominant effect supplied by getaFC.pl, respectively. All file need absolute directory                      the outfile include "ase.add.cor" for calculating the correlation coeffecient of effect size between shared ASE variants and additive cis-sqtl, "ase.dom.cor" for calculating the correlation coeffecient of effect size between shared ASE variants and dominant cis-sqtl, "ase.domclass.cor" for calculating the correlation coeffecient  between the effect size of shared ASE variants and the dominant degree (tdom/tadd) of cis-sqtl
