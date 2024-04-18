// Preprocessing transcripts

process chopper_contam {
    cpus params.threads
    label "process_chop"

    input:
    path fq
    path cont_fasta

    output:
    path filt_fastq

    script:
    """
    gunzip -c $fq | chopper --headcrop ${params.headcrop} --maxlength ${params.maxlength} --minlength ${params.minlength} --quality ${params.quality} --tailcrop ${params.tailcrop} --threads ${params.threads} --contam $cont_fasta > filt_fastq
    """
}

process chopper_nocontam {
    publishDir = "$projectDir/output"
    cpus params.threads
    label "process_chop"

    input:
    path fq

    output:
    path filt_fastq

    script:
    """
    mkdir output
    gunzip -c $fq | chopper --headcrop ${params.headcrop} --maxlength ${params.maxlength} --minlength ${params.minlength} --quality ${params.quality} --tailcrop ${params.tailcrop} --threads ${params.threads} > filt_fastq
    """
}

workflow {
    if( params.contam.isEmpty() )
        chopper_nocontam(Channel.fromPath(params.fastq))
    else 
        chopper_contam(Channel.fromPath(params.fastq), Channel.fromPath(params.contam))
}