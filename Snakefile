import pandas as pd

configfile: 'config.yaml'

samples = pd.read_table(config['samples']).set_index('sample')

rule all:
    input:
        expand("output/trimmed/{sample}.qc.txt",
               sample=samples.index),
        "output/qc/multiqc.html"

rule pre_fastqc_fwd:
    input:
        lambda wildcards: samples.loc[wildcards.sample,
                                      'fq1']
    output:
        html="output/qc/fastqc/{sample}.R1.html",
        zip="output/qc/fastqc/{sample}.R1_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: ""
    log:
        "output/logs/fastqc/{sample}.R1.log"
    threads: 1
    wrapper:
        "0.70.0/bio/fastqc"

rule pre_fastqc_rev:
    input:
        lambda wildcards: samples.loc[wildcards.sample,
                                      'fq2']
    output:
        html="output/qc/fastqc/{sample}.R2.html",
        zip="output/qc/fastqc/{sample}.R2_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params: ""
    log:
        "output/logs/fastqc/{sample}.R2.log"
    threads: 1
    wrapper:
        "0.70.0/bio/fastqc"

rule cutadapt_pe:
    input:
        lambda wildcards: samples.loc[wildcards.sample,
                  'fq1'],
        lambda wildcards: samples.loc[wildcards.sample,
                  'fq2']
    output:
        fastq1="output/trimmed/{sample}.1.fastq.gz",
        fastq2="output/trimmed/{sample}.2.fastq.gz",
        qc="output/trimmed/{sample}.qc.txt"
    params:
        "-a {} {}".format(
            config["trimming"]["adapter"], config["params"]["cutadapt-pe"]
        )
    log:
        "output/logs/cutadapt/{sample}.log"
    wrapper:
        "0.17.4/bio/cutadapt/pe"

rule multiqc:
    input:
        lambda wildcards: expand(rules.pre_fastqc_rev.output,
                                 sample=samples.index),
        lambda wildcards: expand(rules.pre_fastqc_fwd.output,
                                 sample=samples.index),
        lambda wildcards: expand(rules.cutadapt_pe.output,
                                 sample=samples.index)
        
    output:
        "output/qc/multiqc.html"
    params:
        ""  # Optional: extra parameters for multiqc.
    log:
        "output/logs/multiqc.log"
    wrapper:
        "0.70.0/bio/multiqc"