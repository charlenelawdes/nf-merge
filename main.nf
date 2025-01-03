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

include { MERGE_BAM } from "./subworkflows/mergeBam"
include { MERGE_BARCODES } from "./subworkflows/mergeBarcodes"

workflow {

    if (params.bam == null) {
        in_ch = Channel.fromPath("${params.in_dir}/**")
            .map { file -> [file.parent.name, file] } // Group by subdirectory name
            .groupTuple()// Group by subdirectory name

        samples=Channel.fromPath(params.csv)
            .splitCsv(header: true)
            .map { row -> 
                tuple(row.barcode.toString().trim(), row.sample)
            }
        samples_dir = samples
            .join(in_ch)

        MERGE_BARCODES(samples_dir)
        
    } else {
        def counter = 0

        bams = Channel.fromPath(params.bam)
            .collate(20)
            .map { files -> 
                counter++
                return ["chunk${counter}", files]
            }
        MERGE_BAM(bams)
    }
}