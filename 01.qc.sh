##paired-end reads
java -jar trimmomatic-0.39.jar PE -threads 12 SRR14752746_1.fastq.gz SRR14752746_2.fastq.gz SRR14752746_1.clean.fq.gz SRR14752746_1.unpaired.fq.gz SRR14752746_2.clean.fq.gz SRR14752746_2.unpaired.fq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
seqkit stat SRR14752746_1.clean.fq.gz
seqkit stat SRR14752746_2.clean.fq.gz
##single-end reads
java -jar trimmomatic-0.39.jar SE -threads 12 SRR14752746.fastq.gz SRR14752746.clean.fq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
seqkit stat SRR14752746.clean.fq.gz
