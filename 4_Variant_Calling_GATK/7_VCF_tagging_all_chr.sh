#!/bin/bash
#SBATCH --clusters=mesopsl1
#SBATCH --account=gay
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --job-name=Filter_BCFtools
#SBATCH --time=10:00:00
#SBATCH -o Filters_TAG.o
#SBATCH -e Filters_TAG.e

# IMPORT MODULE
module load gcc/9.2.0
module load samtools/1.10
module load gatk/4.2.0.0


#==================#
# Load Directories
#==================#

# PATH to the reference genome fasta file (masked or not masked)
#----------------------------------------------------------------

Genome="/travail/egay/Genome_Reference/CarCar2.pri.cur.20210205.fasta"
	
# INPUT VCF Files
#----------------

VCF_Input="/travail/egay/capture_analysis_GWS/Variant_Calling/subset_best_samples/BCFTools/57st_bcftools.vcf.gz"

# Output VCF Files
#------------------

VCF_Output="/travail/egay/capture_analysis_GWS/Variant_Calling/subset_best_samples/BCFTools/57st_bcftools_TAGED.vcf.gz"

#==================#
# INFOS
#==================#
# Example of VCF file after tagging each position with filters
# passing variants are annotated as PASS and failing variants are annotated with the name(s) of the filter(s) they failed in the 7th column
# Sample which not pass the DP filters at one position are genotyped "./." as missing data and tagged as "DPFILTER"
'''
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  GN1430  GN1434  GN1436  GN17525 GN17582 GN17597 GN17608 GN17768 GN17774 GN17775 GN18404 GN18411
SUPER_9 7205    .       T       .       .       Repeat  DP=2    GT:AD:DP:RGQ    ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:1:0       ./.:0:0:0       ./.:0:0:0       ./.:0:1:0
SUPER_9 7206    .       A       .       .       Repeat  DP=2    GT:AD:DP:FT:RGQ ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:1:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:1:1:DPFILTER:3
SUPER_9 7207    .       A       .       .       Repeat  DP=2    GT:AD:DP:RGQ    ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:1:0       ./.:0:0:0       ./.:0:0:0       ./.:0:1:0
SUPER_9 7208    .       C       .       .       Repeat  DP=2    GT:AD:DP:FT:RGQ ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:1:1:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:1:1:DPFILTER:3
SUPER_9 7209    .       C       .       .       Repeat  DP=2    GT:AD:DP:FT:RGQ ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:1:1:PASS:0  ./.:0:0:PASS:0  ./.:0:0:PASS:0  ./.:1:1:DPFILTER:3
SUPER_9 7210    .       C       .       .       Repeat  DP=2    GT:AD:DP:RGQ    ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:0:0:0       ./.:1:1:0       ./.:0:0:0       ./.:0:0:0       ./.:0:1:0
SUPER_2 10669   .       ATG     A       125.87  MQFILTER        DP=16;ExcessHet=0.2482;FS=0;InbreedingCoeff=0.3763;MLEAC=3;MLEAF=0.3;MQ=24;QD=27.24;SOR=2.833   GT:AD:DP:FT:GQ:PL       ./.:1,0:1:PASS:.:0,0,0  ./.:1,0:1:PASS:.:0,0,0  ./.:1,0:1:PASS:.:0,0,0  ./.:0,3:3:DPFILTER:9:135,9,0    ./.:1,0:1:PASS:.:0,0,0  ./.:2,0:2:DPFILTER:3:0,3,45     ./.:0,0:0:PASS:.:0,0,0  ./.:0,0:0:PASS:.:0,0,0  ./.:2,0:2:DPFILTER:6:0,6,84     ./.:2,0:2:DPFILTER:3:0,3,45     ./.:2,0:2:PASS:.:0,0,0  ./.:1,0:1:DPFILTER:3:0,3,42
SUPER_2 29615   .       A       .       15.64   LowQual;MQFILTER        BaseQRankSum=-1.282;DP=65;ExcessHet=3.01;MLEAC=.;MLEAF=.;MQ=27;MQRankSum=0;ReadPosRankSum=0.431 GT:DP:FT:RGQ    ./.:1:DPFILTER:3        ./.:4:DPFILTER:12       ./.:1:DPFILTER:3        ./.:5:DPFILTER:12       ./.:8:DPFILTER:21       ./.:3:DPFILTER:0        ./.:5:DPFILTER:0        ./.:9:DPFILTER:0        ./.:6:DPFILTER:0        ./.:8:DPFILTER:0        ./.:7:DPFILTER:1        ./.:5:DPFILTER:15
SUPER_25        1919    .       A       .       .       Repeat  AN=6;DP=90      GT:AD:DP:FT:RGQ 0/0:14:14:PASS:42       0/0:11:12:PASS:6        ./.:4:4:DPFILTER:12     ./.:9:9:DPFILTER:27     ./.:10:11:PASS:0        ./.:4:4:DPFILTER:12     0/0:10:10:PASS:30       ./.:7:7:DPFILTER:21     ./.:1
SUPER_25        1920    .       A       .       .       Repeat  AN=8;DP=94      GT:AD:DP:FT:RGQ 0/0:14:14:PASS:36       0/0:12:12:PASS:33       ./.:6:6:DPFILTER:18     ./.:9:9:DPFILTER:27     0/0:10:11:PASS:3        ./.:6:6:DPFILTER:12     0/0:10:10:PASS:30       ./.:7:7:DPFILTER:21     ./.:1
SUPER_25        1921    .       C       .       .       Repeat  AN=6;DP=89      GT:AD:DP:FT:RGQ 0/0:14:14:PASS:42       0/0:12:12:PASS:33       ./.:5:5:DPFILTER:15     ./.:9:9:DPFILTER:24     ./.:8:9:PASS:0  ./.:4:4:DPFILTER:12     0/0:10:10:PASS:30       ./.:7:7:DPFILTER:21     ./.:0:1:PASS:
SUPER_25        1922    .       C       .       .       Repeat  AN=6;DP=88      GT:AD:DP:FT:RGQ 0/0:14:14:PASS:42       0/0:12:12:PASS:33       ./.:4:4:DPFILTER:12     ./.:9:9:DPFILTER:24     ./.:8:8:DPFILTER:24     ./.:4:5:PASS:0  0/0:10:10:PASS:30       ./.:7:7:DPFILTER:21     ./.:1:1:DPFIL
SUPER_25        11343   .       C       T       3933.04 PASS    AC=12;AF=0.545;AN=22;BaseQRankSum=-1.304;DP=214;ExcessHet=4.5806;FS=3.163;InbreedingCoeff=-0.1748;MLEAC=13;MLEAF=0.542;MQ=60;MQRankSum=0;QD=24.58;ReadPosRankSum=0.411;SOR=0.809        GT:AD:DP:FT:GQ:PL       0/1:8,9:17:PASS:99:293,0,2831/1:0,23:23:PASS:69:794,69,0     ./.:7,2:9:DPFILTER:56:56,0,220  0/1:7,6:13:PASS:99:177,0,253    0/1:5,13:18:PASS:99:386,0,155   0/0:19,0:19:PASS:57:0,57,657    0/1:7,12:19:PASS:99:376,0,235   1/1:0,20:20:PASS:60:767,60,0    1/1:0,18:18:PASS:54:684,54,0    0/1:6,4:10:PASS:99:137,0,221    0/0:32,0:32:PASS:90:0,90,1350        0/1:4,9:13:PASS:99:269,0,128
SUPER_25        14199   .       G       T       165.87  PASS    AC=1;AF=0.045;AN=22;BaseQRankSum=0.707;DP=242;ExcessHet=3.0103;FS=0;InbreedingCoeff=-0.0438;MLEAC=1;MLEAF=0.042;MQ=60;MQRankSum=0;QD=8.29;ReadPosRankSum=0.454;SOR=0.473        GT:AD:DP:FT:GQ:PL       0/0:27,0:27:PASS:78:0,78,1170   0/0:19,0:19:PASS:51:0,51,765 ./.:9,0:9:DPFILTER:21:0,21,315  0/1:14,6:20:PASS:99:178,0,462   0/0:16,0:16:PASS:48:0,48,572    0/0:21,0:21:PASS:63:0,63,805    0/0:23,0:23:PASS:69:0,69,927    0/0:20,0:20:PASS:54:0,54,810    0/0:16,0:16:PASS:48:0,48,564    0/0:21,0:21:PASS:60:0,60,900    0/0:25,0:25:PASS:72:0,72,1080        0/0:24,0:24:PASS:63:0,63,945
SUPER_25        11196   .       G       .       .       PASS    DP=252  GT:AD:DP:RGQ    0/0:20:20:57    0/0:23:23:66    0/0:22:22:66    0/0:19:19:57    0/0:19:19:51    0/0:23:23:60    0/0:29:29:84    0/0:10:10:27    0/0:24:24:66    0/0:13:13:33    0/0:29:29:84    0/0:21:21:51
SUPER_25        11197   .       C       .       .       PASS    DP=255  GT:AD:DP:RGQ    0/0:20:20:54    0/0:23:23:66    0/0:22:22:63    0/0:20:20:60    0/0:19:19:48    0/0:23:23:60    0/0:29:29:84    0/0:11:11:27    0/0:24:24:60    0/0:14:14:36    0/0:29:29:81    0/0:21:21:51
'''

# BED File of repeat regions
#-----------------------------
# To obtain RepeatMasker output run the script 'Repeats_detection.sh'
# To get repeat.bed file from RepeatMasker output : run prealably in a separated script:
# cut -f5,6,7 'genome.fasta.out' >> Repeats.bed
# bedtools sort -i Repeats.bed >> Repeats_sorted.bed
# index bed file with GATK IndexFeatureFile -I repeats.bed

# Repeats_BED=/work/rlaso/Sharks/Repeats_sorted.bed.gz

#==================#
# Run filters
#==================#

gatk --java-options "-Xmx10g" VariantFiltration \
   -R ${Genome} \
   -V ${VCF_Input} \
   -O ${VCF_Output} \
   --genotype-filter-name "DPFILTER" \ # Create filter name 'DPFILTER' 
   --genotype-filter-expression "DP<10 ||  DP>260" \ # Tag each position with 10>depth<50 with "pass" and other with "DPFILTER" . Divide by 2 when ploidy = 1
   --filter-name "MQFILTER" \ # ' Create filter name MQFILTER'
   --filter-expression "MQ < 30.0" \ # Tag each position with Mapping quality > 30 with "pass" and other with "MQFILTER" 
   --mask-name "Repeat" \ # Create "Repeat" tag 
   --mask ${Repeats_BED} \ # Add tag "Repeat" for position in the BED intervall file 
   --set-filtered-genotype-to-no-call true \
   --verbosity INFO
