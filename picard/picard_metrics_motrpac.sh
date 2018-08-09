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
multiple_metrics=~/projects/motrpac/picard/picard_output/$(basename $mapq_sorted .out.bam)_multiple_metrics
ref_genome=$2
refFlat=$3

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

echo 'Mulitple Metrics' >>$log_file

cmd="java -Xmx8g -jar $PICARD/picard.jar CollectRnaSeqMetrics\
        INPUT=$mapq_sorted \
        OUTPUT=${multiple_metrics}.RnaSeqMetrics \
        R=${ref_genome} \
        REF_FLAT=${refFlat} \
        STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND"

echo $cmd

# eval not necessary here, will create one more level of expansion e.g. cmd=ls;tmp=cmd;eval \$${tmp} 
eval $cmd >>$log_file 2>&1


cmd="java -Xmx8g -jar $PICARD/picard.jar CollectMultipleMetrics\
        INPUT=$mapq_sorted \
        OUTPUT=${multiple_metrics} \
        R=${ref_genome} \
        PROGRAM=CollectAlignmentSummaryMetrics \
        PROGRAM=CollectInsertSizeMetrics \
        PROGRAM=QualityScoreDistribution \
        PROGRAM=MeanQualityByCycle \
        PROGRAM=CollectBaseDistributionByCycle \
        PROGRAM=CollectGcBiasMetrics \
        PROGRAM=CollectSequencingArtifactMetrics \
        PROGRAM=CollectQualityYieldMetrics"

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

