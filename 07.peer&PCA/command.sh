perl peer.pl list PRJNA626458.muscle.matrix PRJNA626458.muscle.r ##list is contain the absolute directory of the file containing the expression level calculted from stringtie.  PRJNA626458.muscle.matrix is the matrix of the TPM for peer. PRJNA626458.muscle.r is the script for peer.
Rscript PRJNA626458.muscle.r
plink --noweb --bfile All --pca 10 --chr-set 29 --allow-no-sex --out All ## principal component analysis
