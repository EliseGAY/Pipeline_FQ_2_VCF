#!/usr/bin/bash
#SBATCH -p std
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --job-name=gatk
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=200G
#SBATCH -V
# IF YOU WANT PARALLELISE BY SCAFFOLD :
#SBATCH --array=1-20%10

# IMPORT MODULE
# module load singularity/4.2.2 / if gatk not installed

# INPUTS :
# IF YOU WANT PARALLELISE BY SCAFFOLD :
# Interval list file contains all contig/chr/scaffold you want to do the calling on. Put all your contig name if you want to do the calling in all the genome
Intervall_list="/scratch/gaye/RADSeq_JC/ReferenceGenome/intervall.list"
# File with one scaffold or chromosome per lines
mapfile sc_list < <(cat $Intervall_list)
idx=$((SLURM_ARRAY_TASK_ID-1))
curren_sc="${sc_list[$idx]//[[:space:]]/}"
echo ${curren_sc}

# List of vcf file in the following format : --variant /PATH_TO_SAMPLE1/SAMPLE1_gatk.vcf.gz --variant  /PATH_TO_SAMPLE1/SAMPLE1_gatk.vcf.gz
VCFs_File="/path_to/VCF_list.txt"
Genome="PATH_TO/Genome.fasta" # index .fai and .dict have to be present in the same directory (see samtools faidx and gatk CreateSequenceDictionary functions)

# Run GATK ON WHOLE GENOME (OPTION 1)
Gatk --java --java-options "-Xmx200g" -jar CombineGVCFs \
-R ${Genome} \
--variant ${VCFs_File} \
-O All.vcf.gz

# RUN GATK BY SCAFFOLD (option 2) :
output="${curren_sc}.vcf.gz"
echo $output

# Run GATK
java "-Xmx200g" -jar $gatk CombineGVCFs \
-R ${Genome} \
-L ${curren_sc} \
--variant ${VCFs_File} \
-O ${output}


