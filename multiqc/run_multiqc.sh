#!/bin/bash

module load multiqc/1.5

multiqc ../fastqc/output ../star/output_bam ../rsem/rsem_output ../picard/picard_output


