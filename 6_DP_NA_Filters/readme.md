# Variant Calling Filtering Pipeline

## Author: Elise GAY  
## Date: 02/2022

This pipeline filters **gVCF** files based on **DP (depth) range** and **genotype frequencies**. It is designed to work with gVCF files generated using **GATK**. An example of its application on a rat dataset (Y haploid chromosome) is available in the corresponding HTML file.

---

## 🛠️ Prerequisites

This pipeline relies on **R** functions located in the "R_functions" folder.

You will need an R environment with the necessary packages installed to run the functions for filtering.

---

## 📂 Inputs

1. **gVCF**: The gVCF file generated from previous variant calling steps (e.g., using GATK).
2. **R functions**
3. **Metadata** : samples descriptor file

---

## 📝 Methods

### **DP Distribution & Genotype Frequencies**
   - The pipeline first describes the **DP (depth) distribution** **missing data**, and **genotype frequencies** in the provided gVCF file.
   - It then applies filters using the provided R functions.

### Script Workflow:
1. Review the results from the example dataset:
   - `.rmd` and `.html` files contain the results of running the pipeline on the rat Y chromosome dataset.
   
2. To run the pipeline on your own dataset, you should adapt the provided `.r` script to suit your needs.

---

## 📥 How to Run

1. **Prepare Input Files**:
   - Ensure that you have the gVCF files ready for processing.
   - Adjust the input files as required

2. **Run the R Script**:
   - Adapt the `.r` script for your dataset, setting the desired thresholds for DP and genotype frequencies.
   - Execute the R script to filter the gVCF file.

---

## 📁 Output

The output consists of the filtered gVCF file based on the specified DP, missing data and genotype frequency thresholds
