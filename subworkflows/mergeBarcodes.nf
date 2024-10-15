include { merge_barcode } from "../modules/ingress"
include { nanoplot } from "../modules/nanoplot"
include { multiqc } from "../modules/multiqc"

workflow MERGE_BARCODES {
    take:
    csv_ch

    main :
    merge_barcode(csv_ch)

    nanoplot(merge_barcode.out)
    
    multi_ch = Channel.empty()
        .mix(nanoplot.out)
        .collect()
    multiqc(multi_ch)
}