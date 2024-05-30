00.step treat with SraRunTable.txt downloaded from NCBI SRA database. ###
perl 00.sampleInfo.pl SraRunTable.txt SraRunTable.txt originNameVsReName SraRunTableFilt.txt

01.qc perform quality control of raw reads using Trimmomatic software and calculate the maximum length of reads
