#!/usr/bin/bash
#SBATCH --clusters=mesopsl1
#SBATCH --account=gay
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=DBImport
#SBATCH --time=56:00:00
#SBATCH -o GWSD_capture_BImport.o
#SBATCH -e GWSD_cpature_BImport.e

# IMPORT MODULE
module load gcc/9.2.0
module load samtools/1.10
module load gatk/4.2.0.0

#==================#
# INFOS :
#==================#
#'''
#GenomicsDBImport create a database from all the ouputs given by haplotypeCaller and with specified scafold/chr

#INPUTS examples :
#------------------------------------------------------------
#
#- sample map file input (tab delimited column , no header) :
#
#       sample1      /your_absolute_path/sample1.vcf.gz
#       sample2      /your_absolute_path/sample2.vcf.gz
#       sample3      /your_absolute_path/sample3.vcf.gz
#
#- Interval.list input :
#
#       SUPER_1
#       SUPER_2
#       SUPER_3
#       ...
#
#- Create a directory "BD" during the run
#- "Temp directory" has to be prealably created
#
#Ouput :
#-------
#A GenomicsDB workspace
#'''


#==================#
# Load Directories
#==================#
# Interval list
Intervall_list="/travail/egay/capture_analysis_GWS/Variant_Calling/GATK/DB_Import/interval.list"

# INPUT SAMPLES MAP FILE
SAMPLES_MAP="/travail/egay/capture_analysis_GWS/Variant_Calling/GATK/samples_map"

# Temporary path
Temp_path="/travail/egay/capture_analysis_GWS/Variant_Calling/GATK/DB_Import/Temp_DB"

# please adapt your path in the option : --genomicsdb-workspace-path

#==============================================#
# Run DBImport
#==============================================#

# create temporary folder
mkdir ${Temp_path}

# Run GenomicsDBImport
gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport \
--sample-name-map ${SAMPLES_MAP} \
--reader-threads 10 \
--genomicsdb-workspace-path /travail/egay/capture_analysis_GWS/Variant_Calling/GATK/DB_Import/DB \
--tmp-dir ${Temp_path} \
-L ${Intervall_list}
