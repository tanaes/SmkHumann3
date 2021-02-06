# Quinn_metagenomics_pipeline
Stub workflow for a Snakemake metagenomics pipeline

We will be using this repository to develop a basic pipeline for metagenomic analysis using Snakemake. 

The pipeline is meant to automate the processing and analysis of metagenomic data using [HUMAnN3](https://huttenhower.sph.harvard.edu/humann). 

The workflow will execute the following steps:
- preliminary QC of reads using FastQC
- read trimming using Cutadapt
- human read removal using Bowtie2
- trimmed read QC using FastQC
- QC summary using MultiQC
- Taxonomic profiling using MetaPhlAn3
- Functional profiling using HUMAnN3

