// Usage help

def helpMessage() {
  log.info """
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run main.nf --fastq SAMPLE_ID.fastq --ref REF.fasta

        Mandatory arguments:
         --csv                          Path to csv file with two columns: first column with sample IDs named sample, second column for the barcode
         --in_dir                       Abslotue path to directory containing input files
        
         Optional arguments:
         --out_dir                      Output directory
         -profiles                      Use Docker, Singularity or Apptainer to run the workflow [default: Docker]
         --help                         This usage statement
        """
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

include { merge_cDNA } from "./subworkflows/ingress"
include { nanoplot } from "./subworkflows/nanoplot"
include { multiqc } from "./subworkflows/multiqc"

workflow {
    samples=Channel.fromPath(params.csv)
        .splitCsv(header: true)
        .map { row -> 
            tuple(row.sample, row.barcode)
        }

    merge_cDNA(samples)

    nanoplot(merge_cDNA.out)
    
    multi_ch = Channel.empty()
        .mix(nanoplot.out)
        .collect()
    multiqc(multi_ch)
}