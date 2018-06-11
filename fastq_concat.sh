#!/bin/bash

#$ -l h_vmem=500M,tmem=500M
#$ -l h_rt=1:00:00
#$ -wd /cluster/project2/ALS_TDP43_fibroblasts/practice
#$ -o /cluster/project2/ALS_TDP43_fibroblasts/practice/out_files
#$ -e /cluster/project2/ALS_TDP43_fibroblasts/practice/error_files

set -x
set -u

samples=$(ls *fastq.gz | cut -d"_" -f3,4 | sort -u)
arr=($samples)
length=$(echo $samples | wc -w)

echo $samples

for i in `seq 0 $(expr ${length} - 1)`
do
	fastqs=$(ls *${arr["$i"]})
	zcat ${fastqs} | gzip > ${arr["$i"]}
		
done
