##conservation
perl 01.human2cattleFromMaf.pl chr1.maf.gz chr1.maf.Pos
gzip chr1.maf.Pos
perl 02.wigFix2pos.pl chr1.phastCons470way.wigFix.gz chr1.phastCons
gzip chr1.phastCons
perl 02.wigFix2pos.pl chr1.phyloP470way.wigFix.gz chr1.phyloP
gzip chr1.phyloP
perl 03.merge.pl /home/chenqiuming/ljq/10.cons/00.maf /home/chenqiuming/ljq/10.cons/01.phastCons /home/chenqiuming/ljq/10.cons/02.phyloP bosTau.cons ###/home/chenqiuming/ljq/10.cons/00.maf is the directory for all 22 chrXX.maf.Pos.gz file, /home/chenqiuming/ljq/10.cons/01.phastCons is the directory for all 22 chrXX.phastCons.gz, /home/chenqiuming/ljq/10.cons/02.phyloP is the directory for all 22 chrXX.phyloP.gz, bosTau.cons is the outfile
##derived allele
perl 04.extractSameDirection.pl ase.list  ase.aFC ase.pos
java -jar trimmomatic-0.39.jar PE -threads 12 SRR9003421_1.fastq.gz SRR9003421_2.fastq.gz SRR9003421_1.clean.fq.gz SRR9003421_1.unpaired.clean.fq.gz SRR9003421_2.clean.fq.gz SRR9003421_2.unpaired.clean.fq.gz LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
bwa mem -t 4 -M -R '@RG\tID:SRR9003421\tLB:SRR9003421\tPL:ILLUMINA\tSM:SRR9003421' ARS-UCD1.2_Btau5.0.1Y.fa SRR9003421_1.clean.fq.gz SRR9003421_2.clean.fq.gz | samtools view -bS - > SRR9003421.bam
java -jar picard.jar SortSam I=SRR9003421.bam O=SRR9003421.sort.bam SORT_ORDER=coordinate
java -jar picard.jar MarkDuplicates I=SRR9003421.sort.bam O=SRR9003421.sort.dedup.bam M=SRR9003421.marked_dup_metrics.txt REMOVE_DUPLICATES=true CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT
bcftools mpileup -q 30 -C 50 -Q 20 -B -R ase.pos -f ARS-UCD1.2_Btau5.0.1Y.fa SRR9003421.sort.dedup.bam |bcftools call -Oz -m -o SRR9003421.vcf.gz
bcftools sort SRR9003421.vcf.gz -Oz -o SRR9003421.sort.vcf.gz
bcftools index -t SRR9003421.sort.vcf.gz
bcftools merge --threads 20 AmericanBison.sort.vcf.gz Banteng.sort.vcf.gz EuropeanBison.sort.vcf.gz Gaur.sort.vcf.gz SRR9003421.sort.vcf.gz -R ase.pos -Oz -o merge.vcf.gz
bcftools index -t merge.vcf.gz
perl 05.derived.pl merge.vcf.gz ase.aFC 2 ase.derived.aFC ##2 is minimum number of outgroup species in which the SNP could be detected.


##ATAC-seq
trim_galore -q 25 --phred33 --stringency 3 --length 35 -e 0.1 --paired ERR3281594_1.fastq.gz ERR3281594_2.fastq.gz -o /home/chenqiuming/lxy/ATACseq/02.ATAC
bowtie2 -p 10 --very-sensitive -X 2000 -x /home/chenqiuming/lxy/ATACseq/gene/ARS-UCD -1 ERR3281594_1_val_1.fq.gz -2 ERR3281594_2_val_2.fq.gz -S ERR3281594.raw.sam
samtools view -bS ERR3281594.raw.sam -o ERR3281594.raw.bam
samtools view -h ERR3281594.raw.bam | awk '$3 != "X" && $3 != "Y"' | samtools view -bS -o ERR3281594.chr_filtered.bam
sambamba markdup -r -t 4 ERR3281594.chr_filtered.bam ERR3281594.rmdup.bam
samtools sort ERR3281594.rmdup.bam -o ERR3281594.rmdup.sorted.bam
samtools sort -n -@ 4 -O bam -o ERR3281594.rmdup.sorted.Gen.bam -T /home/chenqiuming/lxy/ATACseq/05.bam/ERR3281594.temp ERR3281594.rmdup.bam
macs3 callpeak -t ERR3281594.rmdup.sorted.bam -B --shift 75 --extsize 150 --nomodel --call-summits --nolambda --keep-dup all -q 0.01 -g 2754545636 -n ERR3281594 --outdir /home/chenqiuming/lxy/ATACseq/12.peak3
gzip /home/chenqiuming/lxy/ATACseq/12.peak3/ERR3281594_peaks.narrowPeak
perl 06.merge.pl sampleVStissue #sampleVStissue is a file which contains two columns, the first is the sample name, the second is the tissue name

##Chip-seq
#treat input
trim_galore -q 25 --phred33 --length 25 -e 0.1 --stringency 4 --paired SAMEA14435836.Pancreas.input_1.fastq.gz SAMEA14435836.Pancreas.input_2.fastq.gz -o /home/chenqiuming/lxy/ChipSeq/02.Chip
bowtie2 -p 5 -x ~/lxy/ChipSeq/03.gene/ARS-UCD -1 SAMEA14435836.Pancreas.input_1_val_1.fq.gz -2 SAMEA14435836.Pancreas.input_2_val_2.fq.gz -S SAMEA14435836.Pancreas.input.raw.sam
samtools view -bS SAMEA14435836.Pancreas.input.raw.sam -o SAMEA14435836.Pancreas.input.raw.bam
sambamba markdup -r -t 4 SAMEA14435836.Pancreas.input.raw.bam SAMEA14435836.Pancreas.input.rmdup.bam
samtools sort SAMEA14435836.Pancreas.input.rmdup.bam -o SAMEA14435836.Pancreas.input.rmup.sorted.bam
#treat antibody
trim_galore -q 25 --phred33 --length 25 -e 0.1 --stringency 4 --paired SAMEA14435836.Pancreas.H3K4Me1_1.fastq.gz SAMEA14435836.Pancreas.H3K4Me1_2.fastq.gz -o /home/chenqiuming/lxy/ChipSeq/02.Chip
bowtie2 -p 5 -x /home/chenqiuming/lxy/ChipSeq/03.gene/ARS-UCD -1 SAMEA14435836.Pancreas.H3K4Me1_1_val_1.fq.gz -2 SAMEA14435836.Pancreas.H3K4Me1_2_val_2.fq.gz -S SAMEA14435836.Pancreas.H3K4Me1.raw.sam
samtools view -bS SAMEA14435836.Pancreas.H3K4Me1.raw.sam -o SAMEA14435836.Pancreas.H3K4Me1.raw.bam
sambamba markdup -r -t 4 SAMEA14435836.Pancreas.H3K4Me1.raw.bam SAMEA14435836.Pancreas.H3K4Me1.rmdup.bam
samtools sort SAMEA14435836.Pancreas.H3K4Me1.rmdup.bam -o SAMEA14435836.Pancreas.H3K4Me1.rmdup.sorted.bam
#call peak
macs3 callpeak -t SAMEA14435836.Pancreas.H3K4Me1.rmdup.sorted.bam -c SAMEA14435836.Pancreas.input.rmup.sorted.bam -f BAMPE -B -q  0.01 -g 2754545636 -n SAMEA14435836.Pancreas.H3K4Me1 --outdir /home/chenqiuming/lxy/ChipSeq/05.peak
gzip /home/chenqiuming/lxy/ChipSeq/05.peak/SAMEA14435836.Pancreas.H3K4Me1_peaks.narrowPeak
perl 07.merge.pl list #the absolute direcory of narrowPeak file in list