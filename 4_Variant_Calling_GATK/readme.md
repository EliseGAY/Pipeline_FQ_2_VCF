## Variant Calling
---  

### 📌 Aim  
Run GATK on a list of samples.

### 📂 Input (see details format in the sh script)

`bam file` = absolute path to bam file

`Local_PATH` = Root of working dir

`Interval_list` = File with chromosome (or loci, or scaffold) names

`Temp_duplicates_folder` = Path to temp folder 

`Genome`  = Path to the fasta file

`Output` = Output name
   
###  STEP 1 : haplotypecaller_gatk.sh 
🛠 Methods

Runs variant calling for each sample provided in the list. 
`sh haplotypecaller_gatk.sh`

📤 Output of hapltypecaller : 

- A file `${name}_gatk.vcf.gz` is created for each sample

### STEP 2 option 1 : DBIMPORT 

Two options with GATK : `CombineGVCF` or `DBimport`

📂 Input (see details format in the sh script)

Fill the variables in the corresponding script : 

`samples_step1_variantcalling` : Folder created the step before

`sample map file` tab delimited column , no header :

```
sample1      /your_absolute_path/sample1.vcf.gz

sample2      /your_absolute_path/sample2.vcf.gz
  
sample3      /your_absolute_path/sample3.vcf.gz
   
```

`Interval list` : file with chr name

`DB` : Path to the DB database

```
SUPER_1

SUPER_2

SUPER_3
```

`Temp directory` = Path to temp directory

🛠 Methods

*️⃣ Run the GenomicDBImport function of GATK : create a database needed for the genotyping step

`sh GenomicsDBImport_gatk_all_Chr.sh`

📤 Outputs :

- A DB folder, no need to go get the insight of the folders

### STEP 2 option 2 : CombineGVCF

📂 Input :

list of chr in `chr.list` file
All vcf in one folder `vcf_input` using to search for vcf `vcf_input/*.vcf.gz`
Genome_path `Genome` 
current dir `PWD`

🛠 Methods

use the `Combinegvcf` function of GATK

📤 Outputs :
 All vcf

### STEP 3 : Generate the gvcf

`sh Genotype_gvcf_all_Chr.sh`

📤 Output :

- One gVCF with genotypes

### STEP 4 : Tag the position according to quality criteria

📂 Input :

Your gVCF path

`repeat` = path to repeat file in bed format

📓Note :  

To obtain the repeat coordinate with RepeatMasker run the script `Repeats_detection.sh` (check for corresponding repo)

Briefly, to get the repeat bed file from repeatmakser output :

`awk -F" " '{print $5,$6,$7}' genome.fasta.out | sed '1,2d' | sed '1d' >> genome.fasta.Repeats.bed`

`sed -i 's/ /\t/g' genome.fasta.Repeats.bed`

`bedtools sort -i genome.fasta.Repeats.bed > genome.fasta.Repeats.sorted.bed`

`bgzip genome.Repeat.sorted.bed`


🛠 Methods :

`sh VCF_tagging_all_chr.sh`

📤 Outputs :

- One gVCF with genotypes and quality tags 



