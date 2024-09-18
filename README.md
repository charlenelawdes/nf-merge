# nf-merge

[Nextflow] workflow for merging fastq reads of samples according to assigned barcode.

Requires either [Docker], [Singularity] or [Apptainer] installed.

Usage:

```sh
nextflow run charlenelawdes/wf-cDNA --csv /path/to/samplesheet.csv --in_dir /absolute/path/to/input
```

Overview:

You have to provide two inputs: a CSV file containing sample names and corresponding barcodes, and the absolute path to the directory containing fastq files.
The CSV file has to have two columns: one named sample for the sample ID, and the second one named barcode for barcode ID.

## 1. Concatenating reads

Reads are concatenated per barcode and renamed according to sample IDs in the samplesheet.

## 2. Basic stats on reads

[NanoPlot] and [multiqc] are used to generate QC plots

[Docker]: https://www.docker.com
[Nextflow]: https://www.nextflow.io/docs/latest/index.html
[Singularity]: https://docs.sylabs.io/guides/3.5/user-guide/introduction.html
[Apptainer]: https://apptainer.org
[NanoPlot]: https://github.com/wdecoster/NanoPlot
[multiqc]: https://multiqc.info
