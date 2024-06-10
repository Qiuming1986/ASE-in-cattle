gatk MergeVcfs -I 1.clean.SNP.vcf.gz -I 2.clean.SNP.vcf.gz -I 3.clean.SNP.vcf.gz -I 4.clean.SNP.vcf.gz -I 5.clean.SNP.vcf.gz -I 6.clean.SNP.vcf.gz -I 7.clean.SNP.vcf.gz -I 8.clean.SNP.vcf.gz -I 9.clean.SNP.vcf.gz -I 10.clean.SNP.vcf.gz -I 11.clean.SNP.vcf.gz -I 12.clean.SNP.vcf.gz -I 13.clean.SNP.vcf.gz -I 14.clean.SNP.vcf.gz -I 15.clean.SNP.vcf.gz -I 16.clean.SNP.vcf.gz -I 17.clean.SNP.vcf.gz -I 18.clean.SNP.vcf.gz -I 19.clean.SNP.vcf.gz -I 20.clean.SNP.vcf.gz -I 21.clean.SNP.vcf.gz -I 22.clean.SNP.vcf.gz -I 23.clean.SNP.vcf.gz -I 24.clean.SNP.vcf.gz -I 25.clean.SNP.vcf.gz -I 26.clean.SNP.vcf.gz -I 27.clean.SNP.vcf.gz -I 28.clean.SNP.vcf.gz -I 29.clean.SNP.vcf.gz -O All.clean.SNP.vcf.gz

perl /home/chenqiuming/software/annovar/table_annovar.pl All.clean.SNP.vcf.gz /home/data/python3/software/annovar/UCDdb/ -out All -buildver UCD1.2UseName -protocol refGene -operation g -nastring . -vcfinput

perl -ne '{chomp;@F=split/\t/,$_;print "$F[0]\t$F[1]\t$F[2]\t$F[3]\t$F[4]\t$F[5]\t$F[6]\t$F[7]\t$F[8]\t$F[9]\n"}' All.UCD1.2UseName_multianno.txt > All.anno

rm -f All.UCD1.2UseName_multianno.txt All.UCD1.2UseName_multianno.vcf All.avinput All.refGene.exonic_variant_function All.refGene.log All.refGene.variant_function

gzip All.anno
