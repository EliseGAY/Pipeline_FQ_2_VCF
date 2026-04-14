#!/usr/bin/bash
#SBATCH -A nuclear_genic_sequences_reconstruction
#SBATCH -o Filter.o
#SBATCH -e Filter.e
#SBATCH --job-name=Filter
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=01-00:00:00
#SBATCH --partition=long
#SBATCH --mem-per-cpu=100G

Input="/your/path/XXX.TAG.vcf.gz"
VCF_OUT="/your/path/XXX.OUT.vcf.gz"
#------------------------------------------------------------#
# Filtering: Remove low-quality positions and unwanted variants
# - Remove LowQual, MQFILTER, Repeat, and Indels
#------------------------------------------------------------#
# index vcf and fasta file 
gatk IndexFeatureFile -I VCF.TAG.vcf.gz
bcftools index VCF.TAG.vcf.gz

# removed indel with AWK command
bcftools view ${Input} -e 'FILTER~"MQFILTER|LowQual|Repeat" || TYPE="indel"' --threads 8 -Oz -o VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz
bcftools index VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz

# Remove samples :
bcftools view VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz  -s ^MysamplesName -Oz -o VCF.TAG.Flowqual_Noindels_Norepeat.Sampled.vcf.gz 
bcftools index VCF.TAG.Flowqual_Noindels_Norepeat.Sampled.vcf.gz 

# extract region 
bcftools view VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz --threads 8 -r MyChr:start-end -Oz -o VCF.TAG.Flowqual_Noindels_Norepeat.subset.vcf.gz
# or with a bed file
bcftools view VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz --threads 8 -R Myfile.bed -Oz -o VCF.TAG.Flowqual_Noindels_Norepeat.subset.vcf.gz

# Example of filters on SNP (to keep snp only), missing data, and MAF and. 
# To filter the DP and missing data along with custom vizualisation see the DP_Na_Filter R script in VCF2PopStructure pipeline.

# Keep only biallelic site :
        # -m, --min-alleles INT
        # print sites with at least INT alleles listed in REF and ALT columns
        # -M, --max-alleles INT
        # print sites with at most INT alleles listed in REF and ALT columns. Use -m2 -M2 -v snps to only view biallelic SNPs.

bcftools view VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz  --threads 8 -m2 -M2 -v snps -Oz -o VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz.SNP.vcf.gz
bcftools index VCF.TAG.Flowqual_Noindels_Norepeat.vcf.gz.SNP.vcf.g

# keep the monomorpohic sites, the Bi-allelic sites and no NA
bcftools view -M2 -g  ^miss -Oz -o ${VCF_OUT}

# filter only for NA :
bcftools view -i 'F_MISSING<0.2' -o ${VCF_OUT} -Oz
bvcftools index ${VCF_OUT}

# filter only for MAF :
bcftools view -i 'MAF>=0.5' -Oz -o ${VCF_OUT}
bcftools index ${VCF_OUT}

# use plink to generate ped or other various extension
vcftools --gzvcf ${Input} --out Prefix_Name --plink
