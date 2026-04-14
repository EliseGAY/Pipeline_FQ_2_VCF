#!/usr/bin/bash
#SBATCH -V
#SBATCH -o index.out
#SBATCH -e index.err
#SBATCH -J index
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G
#SBATCH --node=1

# IMPORT MODULE
module load bwa-0.7.17

#=========================#
# Load Path and file name
#=========================#

# Absolute path of the genome fasta file
fasta_file="/store/gaye/genome_ref/Genome/XXXXX.fasta"
# create prefix for the indexed files (same as the name of fasta file)
p="XXXXX.fasta"

#===================#
# Indexing with BWA
#===================#

bwa index -p ${p} ${fasta_file}
