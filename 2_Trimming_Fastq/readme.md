# Run TRIMMOMATIC  
---  

## 📌 Aim  
Trim Illumina sequences.  

## 📂 Input  
- **R1 and R2 FASTQ.gz files**  
- **Adapter file**: A FASTA file containing adapter sequences.  
  - `Adapter.fasta` should contain the adapter sequences.  
  - These sequences depend on the sequencing technology.  
  - For **Illumina-PE**, you can use the FASTA file provided by Trimmomatic or create your own.  
  - **Tip:** Look at the FASTQC results to detect the type of adapters in your FASTQ files.  

## 🛠 Methods  
- Uses **Trimmomatic** with standard parameters for paired-end Illumina sequences:  
  ```plaintext
  ILLUMINACLIP:${Adapter}:2:30:10 SLIDINGWINDOW:4:15 MINLEN:100 LEADING:3 TRAILING:3```
Adapted for MeSU cluster with SLURM command.
To run the script on the cluster:

Note: The command
```sbatch trim.sh```

## 📤 Output
Four FASTQ.gz files:

- paired_R1.fastq.gz
- paired_R2.fastq.gz
- unpaired_R1.fastq.gz
- unpaired_R2.fastq.gz

One trimming report per sample

