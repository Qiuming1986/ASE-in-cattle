bam2junc.sh SRR490027.bam SRR490027.junc         ##SRR490027.bam is the alignment file for individual   SRR490027.junc is the output
python2 leafcutter_cluster.py -j juncfiles.txt -m 50 -o PRJNA305942.White_cell -l 500000  ##juncfiles.txt is a list file which contains the absolute directory of the outfile of bam2junc.sh for population       PRJNA305942.White_cell is prefix of output
python2 prepare_phenotype_table.py PRJNA305942.White_cell_perind.counts.gz -p 10 ##PRJNA305942.White_cell_perind.counts.gz is the output of leafcutter_cluster.py
perl 01.preparePhenotype.pl PRJNA305942.White_cell_perind_numers.counts.gz phenotype.bed ##PRJNA305942.White_cell_perind_numers.counts.gz is the output of prepare_phenotype_table.py                 phenotype.bed is the output file, and finally the step will generate a file of "phenotype.bed.gz"

##additive effect
QTLtools cis --vcf All.vcf.gz --bed phenotype.bed.gz --cov Covariate --nominal 0.01 --out All.nominals.txt ##All.vcf.gz is the imputed genotype file that merged from 7,532 file and the subset file               phenotype.bed.gz is the outfile of preparePhenotype.pl           Covariate is the same file as the cis-eQTL                      All.nominals.txt is the outfile
awk '$12<0.000001' All.nominals.txt > All.nominals.E-6.txt
perl 02.getaFC.pl phenotype.bed.gz All.nominals.E-6.txt All.vcf.gz Covariate All.nominals.E-6.addaFC.txt       ##phenotype.bed.gz is the outfile of preparePhenotype.pl All.nominals.E-6.txt is the out file of previous step   All.vcf.gz is the imputed genotype file that merged from 7,532 file and the subset file  Covariate is the same file as the cis-eQTL    All.nominals.E-6.addaFC.txt is the outfile

##dominant effect
the dominant cis-sqtl mapping is the same as additive, only the file "All.vcf.gz" have transformed by domGenotype.pl.

##calculate the pearson corelation coeffecient
perl 03.ASECorrelation.pl list ###the list file contains 5 column, the first is the name of the subset, the second is the ase information file supplied by 03.aFC.pl in ase identification, the third is the imputed genotype file that merged from 7,532 file and the subset file, the fourth and the fifth files were the final file of additive and dominant effect supplied by getaFC.pl, respectively. All file need absolute directory                      the outfile include "ase.add.cor" for calculating the correlation coeffecient of effect size between shared ASE variants and additive cis-sqtl, "ase.dom.cor" for calculating the correlation coeffecient of effect size between shared ASE variants and dominant cis-sqtl, "ase.domclass.cor" for calculating the correlation coeffecient  between the effect size of shared ASE variants and the dominant degree (tdom/tadd) of cis-sqtl
