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
#SBATCH --mem=32G

# Call any software you might need
module load STAR

# read command line arguments: 
read1=$1
read2=$2
prefix=$3
INDEX_DIRECTORY=$4 #~/projects/mapping/star/star_index/Mus_musculus.GRCm38.92.vM17.overhang74.index

# need to change LoadAndKeep option when use on cluster
memoryshare=LoadAndKeep
memoryshare=NoSharedMemory

# this parameter does not limit RAM use
# request 32G regardless
memorylimit=15000000000

cmd=\
"STAR \
    --genomeDir $INDEX_DIRECTORY \
    --readFilesIn $read1 $read2 \
	--outFileNamePrefix ${prefix}. \
	--readFilesCommand zcat \
	--outSAMattributes NH HI AS nM NM MD jM jI\
	--outFilterType BySJout \
	--runThreadN 8 \
	--outBAMsortingThreadN 8 \
	--outSAMtype BAM SortedByCoordinate \
	--outSAMunmapped Within \
	--quantMode TranscriptomeSAM\
	--genomeLoad ${memoryshare} \
	--limitBAMsortRAM ${memorylimit} \
	--limitGenomeGenerateRAM ${memorylimit} \
	--chimSegmentMin 20 \
	--outSAMattrRGline ID:${prefix} SM:${1}_${2} CN:kevin_smith LB:motrpac"
    
date
echo $cmd
$cmd
date

