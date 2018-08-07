#!/bin/bash

merged_fastq_dir=~/projects/motrpac/fastq/output/merged/
star_index_human=~/data_scratch/star_index/Homo_sapiens.GRCh38.gencode_v28.overhang74.index/
star_index_rat=~/data_scratch/star_index/Rattus_norvegicus.Rnor_6.93.overhang74.index
star_script=~/projects/motrpac/star/star_alignment_motrpac.sh
star_bam_output=~/projects/motrpac/star/output_bam

ls -1 ${merged_fastq_dir} | awk '/PAX/{match($1, /[/]*(PAX.+)_merge_R[12]/, arr); print arr[1]}' | sort | uniq | \
awk -v fastq_dir=${merged_fastq_dir} -v bam_output=${star_bam_output} 'BEGIN{OFS="\t"}{print fastq_dir"/"$1"_merge_R1.fastq.gz", fastq_dir"/"$1"_merge_R2.fastq.gz", bam_output"/"$1}' | \
awk -v scpt=${star_script}  -v sidx=${star_index_human}  '{print "sbatch",scpt,$1,$2,$3,sidx}'
# parallel --jobs 5 --col-sep "\t" "echo ${star_script} {1} {2} {3} ${star_index_human}"

ls -1 ${merged_fastq_dir} | awk '/Rat/{match($1, /[/]*(Rat.+)_merge_R[12]/, arr); print arr[1]}' | sort | uniq | \
awk -v fastq_dir=${merged_fastq_dir} -v bam_output=${star_bam_output} 'BEGIN{OFS="\t"}{print fastq_dir"/"$1"_merge_R1.fastq.gz", fastq_dir"/"$1"_merge_R2.fastq.gz", bam_output"/"$1}' | \
awk -v scpt=${star_script}  -v sidx=${star_index_rat}  '{print "sbatch",scpt,$1,$2,$3,sidx}'



