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


## ⏭️ Next steps are divided in two ways  : 

- VC_allgenome : recommanded to run the VC in the whole genome at once (<1Go)

- VC_loop_chromosome : recommanded if genome is too large (>1Go) to run VC in one raw

