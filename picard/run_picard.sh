#!/bin/bash


star_bam_output=~/projects/motrpac/star/output_bam
picard_script=~/projects/motrpac/picard/picard_motrpac.sh
picard_script=~/projects/motrpac/picard/picard_metrics_motrpac.sh

rat_refgenome=~/data_scratch/reference/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa
human_refgenome=~/data_scratch/reference/GRCh38.primary_assembly.genome.fa
rat_refflat=~/data_scratch/reference/Rattus_norvegicus.Rnor_6.0.93.gtf.refFlat.txt
human_refflat=~/data_scratch/reference/GRCh38.refFlat.txt

# RD014.Aligned.sortedByCoord.out.bam
# RD014.Aligned.toTranscriptome.out.bam


ls -1 $star_bam_output/*.sortedByCoord.out.bam | awk '/PAX/{match($1, /[/]*([^/]*)\.out\.bam/, arr); print arr[1]}' | sort | uniq | \
awk -v bam_output=$star_bam_output 'BEGIN{OFS="\t"}{print bam_output"/"$1".out.bam"}' | \
awk -v pspt=${picard_script} -v ref=${human_refgenome} -v reff=${human_refflat} '{print "sbatch",pspt,$1,ref,reff}'
# parallel --jobs 10 --col-sep "\t" "${picard_script} {1}"


ls -1 $star_bam_output/*.sortedByCoord.out.bam | awk '/Rat/{match($1, /[/]*([^/]*)\.out\.bam/, arr); print arr[1]}' | sort | uniq | \
awk -v bam_output=$star_bam_output 'BEGIN{OFS="\t"}{print bam_output"/"$1".out.bam"}' | \
awk -v pspt=${picard_script} -v ref=${rat_refgenome} -v reff=${rat_refflat} '{print "sbatch",pspt,$1,ref,reff}'

exit

wait

awk 'BEGIN{OFS="\t"}$1 ~ /(LIBRARY)|(motrpac)/{match(FILENAME, /([^/]+)\./, arr); print arr[1], $0}' picard_output/*.Aligned.sortedByCoord_markdup_metrix.txt | awk '{if(NR==1){sub(/[^/]+/, "sample_id", $1); print $0}if(NR > 1 && $2 !~ /LIBRARY/){print $0}}' > kp1_metrix.txt

