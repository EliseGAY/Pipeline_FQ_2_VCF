## Variant Calling

## Author  
**Elise GAY**  
📅 *02/2022*  

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
   
### 🛠 Methods

*️⃣ haplotypecaller_gatk.sh

Runs variant calling for each sample provided in the list. The loop launches a job on the cluster for each sample.

`sh haplotypecaller_gatk.sh`

### 📤 Output of hapltypecaller : 


- A file `${name}_gatk.vcf.gz` is created for each sample

