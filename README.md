# wf-chopper

Nexftlow workflow for processing Nanopore cDNA reads.

Requires either [Docker], [Singularity] or [Apptainer] installed.

Usage:

```sh
nextflow run charlenelawdes/wf-cDNA --reads /path/to/fq.gz
```
Overview:

## 1. Preprocessing cDNA reads
Low quality reads are dropped according to Phred average quality score and read length using [Chopper]. Reads can also be trimmed at both ends using `--headcrop` and `--trailcrop`. 






[Docker]: https://www.docker.com
[Singularity]: https://docs.sylabs.io/guides/3.5/user-guide/introduction.html
[Apptainer]: https://apptainer.org
[Chopper]: https://github.com/wdecoster/chopper