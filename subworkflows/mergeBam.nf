include { mergeChunks } from '../modules/samtools'
include { mergeFinal } from '../modules/samtools'
include { mosdepth } from '../modules/mosdepth'

workflow MERGE_BAM {

    take:
    bam_chunks

    main:

    mergeChunks(bam_chunks)
    
    merged_bam_ch = mergeChunks.out.collect()
    mergeFinal(merged_bam_ch)

    mosdepth(mergeFinal.out)

}