
#!/bin/bash
set -o nounset -o pipefail
#SCG4
# 180620_NS500418_0881_AH5NYJAFXY
# MOTRPAC
# bash qsub_bcl2fastq2.sh 180620_NS500418_0881_AH5NYJAFXY MOTRPAC

runName=$1                # e.g. 180620_NS500418_0881_AH5NYJAFXY 
runLabel=$2               # e.g. label I want to name my job
runDirectory=/srv/gsfs0/projects/montgomery/kssmith/MOTRPAC/SEQ_RUN/  #path. change to link to my file name

user=kssmith@stanford.edu
user=xxli@stanford.edu
bcl2fastq=/srv/gs1/software/bcl2fastq2/2.15.0.4/bcl2fastq
bcl2fastq=/srv/gs1/software/bcl2fastq2/2.20.0/bin/bcl2fastq

seqDir=$runDirectory/$runName
outDir=/srv/gsfs0/projects/montgomery/kssmith/MOTRPAC/SEQ_RUN/FASTQ_RUN1/
outDir=/home/xli6/projects/motrpac/fastq/output/merged
JOB=${runLabel}_bcl2fastq
logOUT=$JOB.out
logError=$JOB.error
rm -f $logOUT $logError
#sampleSheet=/home/kssmith/gsfs0/MOTRPAC/SEQ_RUN/180620_NS500418_0881_AH5NYJAFXY/SampleSheet.csv

# 32G to 12G
qsubCMD=\
"qsub \
    -wd ./ -V -b y \
    -A smontgom \
    -m beas -M $user \
    -l h_vmem=12G \
	-l h_rt=96:00:00 \
	-q batch \
    -N $JOB -o $logOUT -e $logError \
    $bcl2fastq \
    --runfolder-dir $seqDir \
    --output-dir $outDir \
    --minimum-trimmed-read-length 50 \
    --stats-dir ./stats \
    --reports-dir ./reports"

echo $qsubCMD
$qsubCMD

