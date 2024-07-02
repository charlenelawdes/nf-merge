# nf-cDNA

Nexftlow workflow for processing Nanopore cDNA reads.

Requires either [Docker], [Singularity] or [Apptainer] installed.

Usage:

```sh
nextflow run charlenelawdes/wf-cDNA --csv /path/to/samplesheet.csv --in_dir /absolute/path/to/input
```

Overview:

## 1. Concatenating reads

Reads are concatenated per barcode and renamed according to sample IDs in the samplesheet.

## 2. Basic stats on reads

[NanoPlot] and [multiqc] are used to generate QC plots

[Docker]: https://www.docker.com
[Singularity]: https://docs.sylabs.io/guides/3.5/user-guide/introduction.html
[Apptainer]: https://apptainer.org
[NanoPlot] : <https://github.com/wdecoster/NanoPlot>
[multiqc] : <https://multiqc.info>
