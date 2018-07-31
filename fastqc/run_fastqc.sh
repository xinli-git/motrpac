
#!/bin/bash

module load fastqc/0.11.7
fastqc_cmd=~/tools/FastQC/fastqc
fastqc_cmd=fastqc
merged_fastq_dir=~/projects/motrpac/fastq/output/merged/
fastqc_output_dir=~/projects/motrpac/fastqc/output


for i in $(ls -1 ${merged_fastq_dir}/*_merge_*.fastq.gz)
do
echo $i
if [[ $i =~ ([^/]+)\.fastq\.gz ]]; then
	file_prefix=${BASH_REMATCH[1]};
	echo ${file_prefix};
	${fastqc_cmd} --outdir=${fastqc_output_dir} ${merged_fastq_dir}/${file_prefix}.fastq.gz & > ${fastqc_output_dir}/${file_prefix}.fastqc.log ;
fi
done


