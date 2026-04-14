### WGS Variant Calling Pipeline

### Authors
**Elise GAY** - MNHN - EPHE  
**Romuald Laso-Jadart** - MNHN - EPHE  

### Overview
This pipeline is designed to perform variant calling on Whole Genome Sequencing (WGS) data, from quality control of FASTQ files to VCF filtering. All scripts are optimized for execution on a supercomputer using the SLURM scheduler.

Each folder contains generic scripts and a `README.md` file with instructions for running the respective steps.

### Pipeline Steps
1. **Quality Control**: FASTQ quality check using `FastQC`
2. **Trimming Fastq**: Read trimming using `Trimmomatic`
3. **Mapping**: Mapping and BAM preprocessing using `BWA`, `Picard`, and `Samtools`
4. **Variant Calling**: Variant calling using `GATK`
7. **gVCF Filtering**: Filtering of gVCF files using `GATK`
8. **Depth & Genotype Filters**: Visualization and filtering of sequencing depth and genotype frequencies using `R`

### Requirements
Ensure the following dependencies are installed:
- `FastQC`
- `Trimmomatic`
- `Samtools`
- `BWA`
- `Picard`
- `GATK`
- `BCFTools`
- `R`

### Usage
Detailed instructions for running each step are available in the respective subdirectory `README.md` files. The pipeline is structured for high-performance computing environments using SLURM.
