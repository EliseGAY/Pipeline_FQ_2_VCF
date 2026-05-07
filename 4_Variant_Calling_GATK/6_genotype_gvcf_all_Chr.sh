#!/bin/bash
#SBATCH --job-name=SCAFF_genotyping
#SBATCH --partition=bigm
#SBATCH --cpus-per-task=4
#SBATCH --mem=400GB
#SBATCH --nodes=1
#SBATCH --array=1-19%10
#SBATCH --time=96:00:00
#SBATCH -o Scaff_geno_%a.out
#SBATCH -e Scaff_geno_%a.err

# IMPORT MODULE
#################
# PATH to GATK (if not loadable in cluster)
gatk="/scratch/gaye/software/gatk-4.6.2.0/gatk-package-4.6.2.0-local.jar"
module load samtools/1.22.1/gcc
module load java/22.0.2
module load bwa

# SET YOUR VARIABLE
###################

# Path to reference assembly used in the mapping step
Genome="/scratch/gaye/RADSeq_JC/ReferenceGenome/GCF_011800845.1_UG_Zviv_1_genomic.II.fna"

# Interval list file contains all contig/chr/scaffold you want to do the calling on. Put all your contig name if you want to do the calling in all the genome
Intervall_list="/scratch/gaye/RADSeq_JC/ReferenceGenome/intervall.list"

# IF YOU XXANT TO PARALELLISE BY SCAFFOLD
# File with one scaffold or chromosome per lines
mapfile sc_list < <(cat $Intervall_list)

idx=$((SLURM_ARRAY_TASK_ID-1))

curren_sc="${sc_list[$idx]//[[:space:]]/}"

echo ${curren_sc}

# GET Vcf from previous 'combine' step. 
VCFs_PATH="/scratch/gaye/RADSeq_JC/VC/Combine_by_SC/"
VCF_name="${VCFs_PATH}${curren_sc}.vcf.gz"
echo ${VCF_name}

# output
VCF_output_path="/scratch/gaye/RADSeq_JC/VC/genotyping/"
VCf_output_name="${VCF_output_path}${curren_sc}.raw.vcf.gz"
echo ${VCf_output_name}

# set the temp dir
temp_dir="/scratch/gaye/RADSeq_JC/VC/genotyping/temp"

#==================#
# Run genotyping
#==================#
java "-Xmx400g" -jar $gatk GenotypeGVCFs \
-R ${Genome} \
-V ${VCF_name} \
-O ${VCf_output_name} \
--tmp-dir ${temp_dir} \
--include-non-variant-sites true \
--sample-ploidy 2
