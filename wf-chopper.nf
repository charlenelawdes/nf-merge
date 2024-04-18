// Preprocessing transcripts

process chopper {
    cpus params.threads
    label "process_chop"
    publishDir "${projectDir}/${params.out_dir}"

    input:
    path fq

    output:
    path filt_fastq

    script:
    def contam = params.contam ? "--contam ${params.contam}" : ""
    """
    gunzip -c $fq | chopper --headcrop ${params.headcrop} --maxlength ${params.maxlength} --minlength ${params.minlength} --quality ${params.quality} --tailcrop ${params.tailcrop} --threads $task.cpus > filt_fastq
    """
}

workflow {
    chopper(Channel.fromPath(params.fastq))
}