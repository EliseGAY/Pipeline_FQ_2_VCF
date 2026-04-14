# Run FastQC  
---

## 📌 Aim  
Run FastQC on a list of FASTQ files.  

## 📁 Input  
- FASTQ file (zipped or unzipped) from a directory.  

## 🛠 Methods  
- Uses **FASTQC** tool with default parameters.  
- Adapted for **MESU** cluster with **SLURM** command.  
- To run the script on the cluster:  
`sbatch fastqc.sh`

## 📤 Output
Standard FASTQC output files.
