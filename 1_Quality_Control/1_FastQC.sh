#!/bin/bash
#SBATCH --job-name=FQC
#SBATCH --partition=std
#SBATCH --cpus-per-task=4
#SBATCH --mem=10GB
#SBATCH --nodes=1
#SBATCH --array=1-8
#SBATCH --time=04:00:00
#SBATCH -o QC_%a.out
#SBATCH -e QC_%a.err

# IMPORT MODULE
#################
module load fastqc

# SET YOUR VARIABLE
###################

# Path to Fastq Folder
Fq_Path="/PATH_TO_FQ/"

# Get job number index (minus one : list are 0-based index in bash)
idx=$((SLURM_ARRAY_TASK_ID-1))

# BAM AND SAMPLE NAME EXTRACTION
####################################

# Create a list of Fq file in the "Fq_file_list"
mapfile -t Fq_file_list < <(find ${Fq_Path} -maxdepth 1 -name "*.fastq.gz" | sort -V)

# get the current index of the job list (iterate over 1 to 8)
current_Fq_file="${Fq_file_list[$idx]}"

#=============#
# fastqc
#=============#

# PRINT FASTQ FILE LIST TO CHECK
echo $current_Fq_file

# load FAstqc module
module load bioinfo/FastQC_v0.11.7

# run fastqc
mkdir -p fastqc
fastqc -o fastqc -t 4 $current_Fq_file
