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
module load rsem

input_bam=$1 #.Aligned.toTranscriptome.out_mapq30_sorted_dedup.bam format
rsem_dir=~/tools/RSEM-1.3.0/
rsem_reference_prefix=$3
N_THREADS=4
sample_name=$2
log_file=${sample_name}_rsem.log


date>$log_file

cmd="rsem-calculate-expression \
	--num-threads $N_THREADS \
	--fragment-length-max 1000 \
	--paired-end \
	--no-bam-output \
	--estimate-rspd \
	--strand-specific \
	--seed 12345 \
	--alignments \
	$input_bam \
	$rsem_reference_prefix \
	$sample_name"

echo $cmd
echo $cmd >>$log_file
eval $cmd >>$log_file 2>&1

date>> $log_file


