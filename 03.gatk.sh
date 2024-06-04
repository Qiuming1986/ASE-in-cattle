samtools view -b -F 4 -q 1 SRR13051360.bam > SRR13051360.accept.bam
java -jar picard.jar ReorderSam I=SRR13051360.accept.bam O=SRR13051360.reorder.bam SD=/home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.dict VALIDATION_STRINGENCY=LENIENT
java -jar picard.jar SortSam INPUT=SRR13051360.reorder.bam OUTPUT=SRR13051360.sort.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT
java -jar picard.jar AddOrReplaceReadGroups I=SRR13051360.sort.bam O=SRR13051360.added_sorted.bam SO=coordinate RGID=SRR13051360 RGLB=SRR13051360 RGPL=ILLUMINA RGPU=SRR13051360 RGSM=SRR13051360 CREATE_INDEX=true
java -jar picard.jar MarkDuplicates I=SRR13051360.added_sorted.bam O=SRR13051360.sort.dedup.bam M=SRR13051360.marked_dup_metrics.txt REMOVE_DUPLICATES=true CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT
gatk SplitNCigarReads -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.sort.dedup.bam -O SRR13051360.split.bam
gatk BaseRecalibrator -I SRR13051360.split.bam -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa --known-sites /home/chenqiuming/cattle/genome/ARS1.2PlusY_BQSR.vcf.gz -O SRR13051360.recal_data.table
gatk ApplyBQSR --bqsr-recal-file SRR13051360.recal_data.table -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.split.bam -O SRR13051360.recal.bam
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 1 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.1.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 2 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.2.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 3 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.3.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 4 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.4.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 5 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.5.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 6 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.6.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 7 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.7.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 8 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.8.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 9 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.9.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 10 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.10.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 11 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.11.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 12 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.12.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 13 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.13.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 14 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.14.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 15 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.15.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 16 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.16.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 17 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.17.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 18 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.18.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 19 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.19.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 20 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.20.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 21 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.21.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 22 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.22.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 23 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.23.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 24 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.24.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 25 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.25.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 26 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.26.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 27 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.27.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 28 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.28.g.vcf.gz
gatk HaplotypeCaller --native-pair-hmm-threads 10 -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -I SRR13051360.recal.bam --minimum-mapping-quality 30 -ERC GVCF -L 29 -O /home/chenqiuming/ljq/05.gvcf/SRR13051360/SRR13051360.29.g.vcf.gz

##build a GenomicsDB datastore
java -Xmx200g -jar gatk-package-4.4.0.0-local.jar GenomicsDBImport -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa -V ......... -V /home/chenqiuming/ljq/05.gvcf/SRR19850341/SRR19850341.8.g.vcf.gz -V /home/chenqiuming/ljq/05.gvcf/SRR11802098/SRR11802098.8.g.vcf.gz -V /home/chenqiuming/ljq/05.gvcf/SRR18090422/SRR18090422.8.g.vcf.gz -V /home/chenqiuming/ljq/05.gvcf/SAMN14641682/SAMN14641682.8.g.vcf.gz -V /home/chenqiuming/ljq/05.gvcf/SRR13293402/SRR13293402.8.g.vcf.gz -V /home/chenqiuming/ljq/05.gvcf/SRR15654766/SRR15654766.8.g.vcf.gz --intervals 8 --reader-threads 20 --batch-size 100 --genomicsdb-workspace-path /home/chenqiuming/ljq/06.snp/database/8db --tmp-dir /home/chenqiuming/ljq/06.snp/database/tmp


java -Xmx250G -XX:+UseParallelGC -XX:ParallelGCThreads=2 -jar gatk-package-4.4.0.0-local.jar GenotypeGVCFs -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa --use-new-qual-calculator --max-alternate-alleles 1 -V gendb:///home/chenqiuming/ljq/06.snp/database/8db -O /home/chenqiuming/ljq/06.snp/8.vcf.gz -L 8
java -Xmx250G -XX:+UseParallelGC -XX:ParallelGCThreads=2 -jar gatk-package-4.4.0.0-local.jar SelectVariants -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa --select-type-to-include SNP --exclude-non-variants true -V /home/chenqiuming/ljq/06.snp/8.vcf.gz -O /home/chenqiuming/ljq/06.snp/8.raw.SNP.vcf.gz
java -Xmx250G -XX:+UseParallelGC -XX:ParallelGCThreads=2 -jar gatk-package-4.4.0.0-local.jar VariantFiltration -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa --filter-expression "QD < 2.0 || FS > 30.0" --filter-name "filtered" --cluster-size 3 --cluster-window-size 35 -V /home/chenqiuming/ljq/06.snp/8.raw.SNP.vcf.gz -O /home/chenqiuming/ljq/06.snp/8.filter.SNP.vcf.gz
java -Xmx250G -XX:+UseParallelGC -XX:ParallelGCThreads=2 -jar gatk-package-4.4.0.0-local.jar SelectVariants -R /home/chenqiuming/cattle/genome/ARS-UCD1.2_Btau5.0.1Y.fa --select-type-to-include SNP --exclude-non-variants true --restrict-alleles-to BIALLELIC --select "AC > 0" --select "AF > 0.01" --select "AF < 0.99" -V /home/chenqiuming/ljq/06.snp/8.filter.SNP.vcf.gz -O /home/chenqiuming/ljq/06.snp/8.clean.SNP.vcf.gz
