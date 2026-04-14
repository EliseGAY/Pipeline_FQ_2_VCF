#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH --partition=fast
#SBATCH --cpus-per-task=20
#SBATCH --mem=100GB
#SBATCH --nodes=1
#SBATCH --array=1-8
#SBATCH --time=08:00:00
#SBATCH -o trim_%a.out
#SBATCH -e trim_%a.err

# IMPORT MODULE
#################
module load bioinfo/Trimmomatic-0.38
module load java/22.0.2

# SET YOUR VARIABLES
####################
# Path to Trimmomatic JAR file : sometimes the jar file have to be downloaded in your local account
# Trimmomatic="/softs/apps/trimmomatic/0.39/java/bin/trimmomatic"

# Chose the adapter.fasta file corresponding to your data.
# To check for possibilities run : "ll /softs/apps/trimmomatic/0.39/java/adapters/"
Adapter="/softs/apps/trimmomatic/0.39/java/adapters/XXX.fasta"

# Input FASTQ directory
fastq_path="/PATH_TO_FASTQ/"

# Output directory
output_path="/scratch/gaye/Jardin_Commun/Pipeline_FQ_2_VCF/2_Trimming_Fastq"

# Create array of sample basenames
sample_list=("samples_1" "samples_2" "samples_n")
# Get job number index (minus one: lists are 0-based index in bash)
idx=$((SLURM_ARRAY_TASK_ID-1))
# Index with job number to iterate over samples
sample="${sample_list[$idx]}"

# Construct FASTQ file names
fastq_R1="${fastq_path}${sample}_R1_001.fastq.gz"
fastq_R2="${fastq_path}${sample}_R2_001.fastq.gz"

# Output file names
output_R1_paired="${output_path}${sample}_R1.trim.paired.fastq.gz"
output_R1_unpaired="${output_path}${sample}_R1.trim.unpaired.fastq.gz"
output_R2_paired="${output_path}${sample}_R2.trim.paired.fastq.gz"
output_R2_unpaired="${output_path}${sample}_R2.trim.unpaired.fastq.gz"

# Check for sample name in the '.out' log
echo "Processing sample: ${sample}"
echo "Input R1: ${fastq_path}${fastq_R1}"
echo "Input R2: ${fastq_path}${fastq_R2}"

# Run Trimmomatic
#################
java -Xmx100g -jar PE \
    -threads 20 \
    -phred33 \
    ${fastq_path}${fastq_R1} \
    ${fastq_path}${fastq_R2} \
    ${output_R1_paired} \
    ${output_R1_unpaired} \
    ${output_R2_paired} \
    ${output_R2_unpaired} \
    ILLUMINACLIP:${Adapter}:2:30:10 \
    SLIDINGWINDOW:4:15 \
    MINLEN:100 \
    LEADING:3 \
    TRAILING:3

echo "Trimmomatic completed for sample: ${sample}"
