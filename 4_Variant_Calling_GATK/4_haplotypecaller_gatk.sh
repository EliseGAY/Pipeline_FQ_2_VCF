#!/bin/bash
#SBATCH --job-name=haplocall
#SBATCH --partition=std
#SBATCH --cpus-per-task=8
#SBATCH --mem=10GB
#SBATCH --nodes=1
#SBATCH --array=1-172%10
#SBATCH --time=04:00:00
#SBATCH -o recover_sample/haplo_%a.out
#SBATCH -e recover_sample/haplo_%a.err

# example of job requierment for one sample (RADSEQ):
# Job ID: 1111566
# Array Job ID: 1111566_266
# Cluster: mcmesu
# User/Group: gaye/users
# State: COMPLETED (exit code 0)
# Nodes: 1
# Cores per node: 16
# CPU Utilized: 04:21:19
# CPU Efficiency: 29.98% of 14:31:44 core-walltime
# Job Wall-clock time: 00:54:29
# Memory Utilized: 2.34 GB
# Memory Efficiency: 2.39% of 97.66 GB


# IMPORT MODULE
#################
picard="/scratch/gaye/RADSeq_JC/ReferenceGenome/picard.jar"
# PATH to GATK (if not loadable in cluster)
gatk="/scratch/gaye/software/gatk-4.6.2.0/gatk-package-4.6.2.0-local.jar"
module load samtools/1.22.1/gcc
module load java/22.0.2
module load bwa

# SET YOUR VARIABLE
###################

# Path to reference assembly used in the mapping step
Genome="/PATH_TO/assembly.fna"

bam_path="/PATH_TO/BAM_FOLDER/"

# Get job number index (minus one : list are 0-based index in bash)
idx=$((SLURM_ARRAY_TASK_ID-1))

# Interval list file contains all contig/chr/scaffold you want to do the calling on. Put all your contig name if you want to do the calling in all the genome
Intervall_list="/PATH_TO/intervall.list"

#'- Interval.list input example:

#SUPER_1
#SUPER_2
#SUPER_3
#'

# BAM AND SAMPLE NAME EXTRACTION
####################################

# Create a list of bam file in the "bam_file_list"
mapfile -t bam_file_list < <(find ${bam_path} -maxdepth 1 -name "*.bam" | sort -V)

# index with job number the list to iterate over bam file
current_bam_file="${bam_file_list[$idx]}"
# get only the bam name (not the wole path) and extract the sample prefix
bam_name=$(basename "${current_bam_file}")
sample="${bam_name%.YOUR_SUFFIX.bam}"

# Output path and name (folder name= same as the mkdir command line below)
Output="${sample}_gatk.vcf.gz"

# check for the bam name and the sample name in the '.out'
echo ${current_bam_file}
echo ${sample}

# Run HaplotypeCaller / BP_RESOLUTION = option which print all the bases, not only variant bases
###########################################

# Add : --ploidy 1 \ option when haploide

java "-Xmx100g" -jar $gatk HaplotypeCaller -ERC BP_RESOLUTION \
--native-pair-hmm-threads 8 \
-R ${Genome} \
-I ${current_bam_file} \
-O ${Output} \
--intervals ${Intervall_list} \
--do-not-run-physical-phasing true

