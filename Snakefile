import pandas as pd

configfile: 'config.yaml'

samples = pd.read_table(config['samples']).set_index('sample')

rule all:
    input:
        expand("output/trimmed/{sample}.qc.txt",
               sample=samples.index)

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
        "logs/cutadapt/{sample}.log"
    wrapper:
        "0.17.4/bio/cutadapt/pe"
