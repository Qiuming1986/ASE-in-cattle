00.step treat with SraRunTable.txt downloaded from NCBI SRA database. ###
perl 00.sampleInfo.pl SraRunTable.txt SraRunTable.txt originNameVsReName SraRunTableFilt.txt  ###originNameVsReName is the file of NCBI tissue name VS the defined name in our study

01.qc perform quality control of raw reads using Trimmomatic software and calculate the maximum length of reads

02.mapping the clean reads were mapped to the reference assembly using STAR and hisat2, and the mapping status were calculated using samtools 

03.detecting SNP using gatk 

04.merge SNP using gatk, annotate using ANNOVAR

05.imputation using beagle

06.ase detecting base on the reads count for each allele of each individual at heterozygous sites supplied by gatk
