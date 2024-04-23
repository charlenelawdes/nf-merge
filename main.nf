// Usage help

def helpMessage() {
  log.info """
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run main.nf --fastq SAMPLE_ID.fastq --ref REF.fasta

        Mandatory arguments:
         --reads                        Path to the input compressed fastq file 

         Optional arguments:
         --out_dir                      Output directory to place filtered fastq files
         --sample_id                    String to prefix output files with [default: reads]
         --headcrop                     Trim N nucleotides from the start of a read [default: 0]
         --maxlength                    Sets a maximum read length [default: 2147483647]
         --minlength                    Sets a minimum read length [default: 1]
         --quality                      Sets a minimum Phred average quality score [default: 0]
         --trailcrop                    Trim N nucleotides from the end of a read [default: 0]
         --contam                       Path to fasta file with reference to check potential contaminants against [default None]
         --threads                      Number of CPUs to use (default: 4)
         -profiles                      Use Docker, Singularity or Apptainer to run the workflow [default: Docker]
         --help                         This usage statement
        """
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

// Preprocessing transcripts

process chopper {
    cpus params.threads
    label "process_chop"
    publishDir "${params.out_dir}"

    input:
    path fq

    output:
    path "${fq.baseName}_filt.fq.gz"

    script:
    def contam = params.contam ? "--contam ${params.contam}" : ""
    """
    gunzip -c $fq | chopper --headcrop ${params.headcrop} --maxlength ${params.maxlength} --minlength ${params.minlength} --quality ${params.quality} --tailcrop ${params.tailcrop} --threads $task.cpus ${params.contam} | gzip > ${fq.baseName}_filt.fq.gz
    """
}

workflow {
    chopper(Channel.fromPath(params.reads))
}