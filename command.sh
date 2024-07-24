perl prePare.pl Chr11_phased_snp.vcf.gz 11.ref.vcf
vcftools --gzvcf All.clean.SNP.vcf.gz --chr 11 --maf 0.05 --max-missing 0.7 --minDP 10 --minGQ 20 --recode --stdout | gzip -c > 11.recode.vcf.gz
perl prePare.pl 11.recode.vcf.gz 11.vcf
java -Xmx1000g -Djava.io.tmpdir=/home/chenqiuming/tmp -XX:ParallelGCThreads=20 -jar /home/chenqiuming/ljq/08.beagle/software/beagle.27Jan18.7e1.jar gt=/home/chenqiuming/ljq/08.beagle/01.phase/25.vcf.gz ref=/home/chenqiuming/ljq/08.beagle/11.ref.vcf.gz out=/home/chenqiuming/ljq/08.beagle/01.phase/chr11-beagle impute=true seed=9823 nthreads=90 window=200000 overlap=12000
bcftools view -q 0.05:minor -v snps -i "DR2>=0.8" /home/chenqiuming/ljq/08.beagle/01.phase/chr25-beagle.vcf.gz -Oz > /home/chenqiuming/ljq/08.beagle/01.phase/chr11-beagle.filter.maf.vcf.gz
