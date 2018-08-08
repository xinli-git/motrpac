#!/bin/bash

# The PI account to be charged
#SBATCH --account=smontgom

# Set estimated job time (day-hour:minute:seconds)
#SBATCH --time=0-96:00:00

# Set a name for the job, visible in `squeue`
#SBATCH --job-name="exampe_job"

# One node (you never usually will need to change this)
#SBATCH --nodes=1

# Specify partition
#SBATCH --partition=batch

# One task
#SBATCH --ntasks=1

# One CPU/core per task
#SBATCH --cpus-per-task=1

# Redirect output
#SBATCH --output=example_job-out-%j.txt
#SBATCH --error=example_job-err-%j.txt

# RAM (how much memory do you need)
#SBATCH --mem=12G

# Call any software you might need
module load picard-tools/2.8.0

bam_file=$1
mapq_sorted=$bam_file
# mapq_suf=$(basename $bam_file .bam)_mapq30.bam
# mapq_sorted=$(basename $mapq_suf .bam)_sorted
dedup_suf=~/projects/motrpac/picard/picard_output/$(basename $mapq_sorted .out.bam)_markdup.bam
dedup_metrix=~/projects/motrpac/picard/picard_output/$(basename $mapq_sorted .out.bam)_markdup_metrix.txt
# sortedbam=$(basename $dedup_suf .bam)_byread
log_file=~/projects/motrpac/picard/picard_output/$(basename $bam_file .out.bam)_filter_bam.log

date > $log_file

# 1/ MAPQ30
# echo 'Filter for mapping quality over 30' >>$log_file

# samtools view -h $bam_file | awk '($5>=30)||($1=="@SQ")'| samtools view -Sbh - > $mapq_suf
# wait
# samtools sort -m 10G $mapq_suf $mapq_sorted
# wait
# rm $mapq_suf

# wait
# 2/ Remove PCR duplicates
# samtools rmdup $mapq_suf $dedup_suf
# rm $mapq_suf

echo 'Mark PCR duplicates' >>$log_file
echo $cmd >> $log_file

cmd="java -Xmx8g -jar $PICARD/picard.jar MarkDuplicates\
	INPUT=$mapq_sorted \
	OUTPUT=$dedup_suf\
	CREATE_INDEX=true \
	VALIDATION_STRINGENCY=SILENT \
	METRICS_FILE=$dedup_metrix \
	REMOVE_DUPLICATES=false \
	TAGGING_POLICY=All"

echo $cmd

# eval not necessary here, will create one more level of expansion e.g. cmd=ls;tmp=cmd;eval \$${tmp} 
eval $cmd >>$log_file 2>&1

# wait

# rm $mapq_sorted.bam
# echo 'sort bam files by read names'>>$log_file
# 3 Sort bam files by read name
# samtools sort -n -m 8G $dedup_suf $sortedbam

# wait
# rm $dedup_suf
# echo 'All done'>>$log_file

date>>$log_file

