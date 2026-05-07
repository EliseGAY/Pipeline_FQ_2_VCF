#!/bin/bash
#SBATCH --clusters=mesopsl1
#SBATCH --account=gay
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --job-name=Filter_BCFtools
#SBATCH --time=96:00:00
#SBATCH -o Index_GATK.o
#SBATCH -e Index_GATK.e

# IMPORT MODULE
module load gcc/9.2.0
module load samtools/1.10
module load gatk/4.2.0.0

#==================#
# Load Directories
#==================#
VCF_Input="/travail/egay/capture_analysis_GWS/Variant_Calling/subset_best_samples/BCFTools/57st_bcftools.vcf.gz"


#==================#
# Index VCF
#==================#
gatk --java-options "-Xmx10g" IndexFeatureFile \
 -I ${VCF_Input}
