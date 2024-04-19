// Mapping of FASTQ files

process mapping {
    cpus params.t
    publishDir "${params.out_dir}"
    label "minimap"

    input:
    path ref
    path fastq

    output:
    path "${params.id}.sam"

    script:
    """
    minimap2 -ax map-ont -t $task.cpus $ref $fastq > ${params.id}.sam
    """
}

process sam_to_bam {
    cpus params.t
    publishDir "${params.out_dir}"
    label "samtools"

    input:
    path sam

    output:
    path "${params.id}.bam"

    script:
    """
    samtools view -@ $task.cpus -Sb $sam > ${params.id}.bam
    """
}

process sam_sort {
    cpus params.t
    publishDir "${params.out_dir}"
    label "samtools"

    input:
    path aligned

    output:
    path "${params.id}_sorted.bam"

    script:
    """
    samtools sort -@ $task.cpus $aligned > "${params.id}_sorted.bam"
    """
}

process sam_index {
    cpus params.t
    publishDir "${params.out_dir}"
    label "samtools"

    input:
    path sorted

    output:
    stdout

    script:
    """
    samtools index -@ $task.cpus $sorted
    """
}

process sam_depth {
    cpus params.t
    publishDir "${params.out_dir}"
    label "samtools"

    input:
    path sorted

    output:
    path "${params.id}_sorted.bam.depth"

    script:
    """
    samtools depth -@ $task.cpus $sorted > ${params.id}_sorted.bam.depth
    """
}


workflow {
    reads_ch = Channel.fromPath(params.reads)
    ref_ch = Channel.fromPath(params.ref)
    mapping(ref_ch,reads_ch)
    sam_to_bam(mapping.out)
    sam_sort(sam_to_bam.out)
    sam_index(sam_sort.out)
    sam_depth(sam_sort.out)
}