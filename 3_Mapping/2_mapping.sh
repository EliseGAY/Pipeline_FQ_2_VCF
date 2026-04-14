#!/bin/sh
#SBATCH --job-name=mapping
#SBATCH --partition=std
#SBATCH --cpus-per-task=30
#SBATCH --mem=10GB
#SBATCH --nodes=1
#SBATCH --array=1-8
#SBATCH --time=10:00:00
#SBATCH -o mapp_%a.out
#SBATCH -e mapp_%a.err

# module
module load picard/3.4.0/java
module load bwa
module load samtools/1.22.1/gcc


# SET YOUR VARIABLES
####################

# Write your samples prefix in the list
Basename_samples=("samples_1 samples_2, samples_n")

# Absolute Path of your local directory (where the script is launch)
Local_PATH="/scratch/gaye/Jardin_Commun/Pipeline_FQ_2_VCF/3_Mapping/"

# Temp folder to stock temp file in markduplicates
Temp_duplicates_folder=${Local_PATH}"/TMP"

# Get the current sample idx
idx=$((SLURM_ARRAY_TASK_ID-1))
current_sample="${Basename_samples[$idx]}"

# INPUT FASTQ TRIMMED DIRECTORY
DIR_samples="/scratch/gaye/Jardin_Commun/Pipeline_FQ_2_VCF/2_Trimming_Fastq/"

# Absolute path of fastq_trimmed_R1/R2.fastq.gz files
fastq_R1=${DIR_samples}${current_sample}_R1.trim.paired.fastq.gz
fastq_R2=${DIR_samples}${current_sample}_R2.trim.paired.fastq.gz

# PATH to the reference genome fasta file
Genome="/store/gaye/genome_ref/Genome/XXXXX.fasta"

# create temp directory
temp_folder="/scratch/gaye/Jardin_Commun/Pipeline_FQ_2_VCF/3_Mapping/temp"
mkdir -p ${temp_folder}

# 1. MAPPING STEP
##################
# options :  -t (thread) -M (don't allow multiple mapping) -R (add tag "RGID" on reads : needed for GATK)
# samtools : transform SAM in BAM

bwa mem -t 30 -M -R "@RG\tID:${current_sample}_1\tSM:${current_sample}" ${Genome} ${fastq_R1} ${fastq_R2} | samtools view -bS -1 -h > ${current_sample}.bam.gz

# sort read by coordinate
samtools sort -l 6 -o ${current_sample}.sorted.bam.gz -O bam -@ 30 ${current_sample}.bam.gz

# 2. MARK DUPLICATES
#######################
java -Djava.io.tmpdir=${Temp_duplicates_folder} -jar picard MarkDuplicates \
I=${current_sample}.sorted.bam.gz \
M=metrics_duplicates.txt \
O=${current_sample}.sorted.duplicates.bam.gz \
COMPRESSION_LEVEL=5

# index final bam file
samtools index ${current_sample}.sorted.duplicates.bam.gz

# 3. Get statistics on BAM
###########################
samtools stats -@30 ${current_sample}.sorted.duplicates.bam.gz >> ${current_sample}.bam.stats
samtools coverage -o ${current_sample}_metrics_coverage.txt ${current_sample}.sorted.duplicates.bam.gz
