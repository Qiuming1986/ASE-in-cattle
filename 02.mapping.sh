##paired-end reads
STAR --runThreadN 8 --genomeDir /home/chenqiuming/cattle/genome --readFilesIn SRR18214059_1.clean.fq.gz SRR18214059_2.clean.fq.gz --readFilesCommand zcat --outFilterMultimapNmax 1 --outFilterIntronMotifs RemoveNoncanonical Unannotated --outFilterMismatchNmax 10 --outSAMstrandField intronMotif --outSJfilterReads Unique --outSAMtype BAM Unsorted --outReadsUnmapped Fastx --outFileNamePrefix SRR18214059
java -jar picard.jar CleanSam I=SRR18214059Aligned.out.bam O=SRR18214059.STAR.bam
hisat2 --dta-cufflinks --no-mixed --no-discordant -p 10 --known-splicesite-infile /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.transcript.gtf /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y -1 SRR18214059Unmapped.out.mate1 -2 SRR18214059Unmapped.out.mate2 -S SRR18214059.sam
java -jar picard.jar CleanSam I=SRR18214059.sam O=SRR18214059.hisat.bam
java -jar picard.jar MergeSamFiles I=SRR18214059.STAR.bam I=SRR18214059.hisat.bam SORT_ORDER=coordinate O=SRR18214059.bam
##single-end reads
STAR --runThreadN 8 --genomeDir /home/chenqiuming/cattle/genome --readFilesIn SRR18214059.clean.fq.gz --readFilesCommand zcat --outFilterMultimapNmax 1 --outFilterIntronMotifs RemoveNoncanonical Unannotated --outFilterMismatchNmax 10 --outSAMstrandField intronMotif --outSJfilterReads Unique --outSAMtype BAM Unsorted --outReadsUnmapped Fastx --outFileNamePrefix SRR18214059
java -jar picard.jar CleanSam I=SRR18214059Aligned.out.bam O=SRR18214059.STAR.bam
hisat2 --dta-cufflinks --no-mixed --no-discordant -p 10 --known-splicesite-infile /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.transcript.gtf /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y -U SRR18214059Unmapped.out.mate1 -S SRR18214059.sam
java -jar picard.jar CleanSam I=SRR18214059.sam O=SRR18214059.hisat.bam
java -jar picard.jar MergeSamFiles I=SRR18214059.STAR.bam I=SRR18214059.hisat.bam SORT_ORDER=coordinate O=SRR18214059.bam