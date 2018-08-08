#!/bin/bash



star_bam_output=~/projects/motrpac/star/output_bam

rsem_script=~/projects/motrpac/rsem/rsem_motrpac.sh
rsem_output=~/projects/motrpac/rsem/rsem_output
rsem_reference_human=~/data_scratch/rsem_reference/Homo_sapiens.GRCh38.gencode_v28/Homo_sapiens.GRCh38.gencode_v28
rsem_reference_rat=~/data_scratch/rsem_reference/Rattus_norvegicus.Rnor_6.93/Rattus_norvegicus.Rnor_6.93


ls -1 $star_bam_output/*.toTranscriptome.out.bam | awk '/PAX/{match($1, /[/]*([^/]*)\.out\.bam/, arr); print arr[1]}' | sort | uniq | \
awk -v star_bam_output=$star_bam_output -v rsem_output=$rsem_output 'BEGIN{OFS="\t"}{print star_bam_output"/"$1".out.bam", rsem_output"/"$1}' | \
awk -v rscrpt=${rsem_script} -v rref=${rsem_reference_human} '{print "sbatch",rscrpt,$1,$2,rref}'
# parallel --jobs 24 --col-sep "\t" "${rsem_script} {1} {2}"

ls -1 $star_bam_output/*.toTranscriptome.out.bam | awk '/Rat/{match($1, /[/]*([^/]*)\.out\.bam/, arr); print arr[1]}' | sort | uniq | \
awk -v star_bam_output=$star_bam_output -v rsem_output=$rsem_output 'BEGIN{OFS="\t"}{print star_bam_output"/"$1".out.bam", rsem_output"/"$1}' | \
awk -v rscrpt=${rsem_script} -v rref=${rsem_reference_rat} '{print "sbatch",rscrpt,$1,$2,rref}'





