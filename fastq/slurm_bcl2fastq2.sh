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
#SBATCH --mem=10G

# Call any software you might need
module load bcftools
module load bedtools

# Command here...

runName=""                # e.g. 180620_NS500418_0881_AH5NYJAFXY 
runLabel=""               # e.g. label I want to name my job
runDirectory=/srv/gsfs0/projects/montgomery/kssmith/MOTRPAC/SEQ_RUN/  #path. change to link to my file name

user=kssmith@stanford.edu
user=xxli@stanford.edu
bcl2fastq=/srv/gs1/software/bcl2fastq2/2.15.0.4/bcl2fastq
#bcl2fastq=/srv/gs1/software/bcl2fastq2/2.20.0/bin/bcl2fastq

seqDir=$runDirectory/$runName
seqDir=/home/xli6/projects/motrpac/bcl2
outDir=/srv/gsfs0/projects/montgomery/kssmith/MOTRPAC/SEQ_RUN/FASTQ_RUN1/
outDir=/home/xli6/projects/motrpac/fastq/output
JOB=${runLabel}_bcl2fastq
logOUT=$JOB.out
logError=$JOB.error
#rm -f $logOUT $logError
#sampleSheet=/home/kssmith/gsfs0/MOTRPAC/SEQ_RUN/180620_NS500418_0881_AH5NYJAFXY/SampleSheet.csv

# 32G to 12G
qsubCMD=\
"$bcl2fastq \
    --runfolder-dir $seqDir \
    --output-dir $outDir \
    --minimum-trimmed-read-length 50 \
    --stats-dir ./stats \
    --reports-dir ./reports"

echo $qsubCMD
$qsubCMD




