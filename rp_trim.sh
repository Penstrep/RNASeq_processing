#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=24:00:00
#SBATCH --mem=8G
#SBATCH --job-name=r_pipeline
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_trim.out

# script exits if return value of a command is not zero
#set -e
# this forces all variables to be defined
#set -u
# for debugging prints out every line before executing it
#set -x

# import config variables
. ./$config

# create output dir if necessary, and redirect log and err files there
mkdir -p ${out_dir}/trim
exec >${out_dir}/fastqc/${project}_rp_trim.out 2>${out_dir}/fastqc/${project}_rp_trim.err

# path to tools
fastp=/scratch/users/k2142172/packages/anaconda3/bin/fastp

# import sample table as arrays for each column
while read col1 col2 col3 col4; do
  name+=($col1)
  fq1+=($col2)
  fq2+=($col3)
  cond+=($col4)
done < $sample_table

# run fastqc over each iteration of fq1 and fq2 arrays
if [[ ${paired_end} == yes ]]; then
  for i in "${!name[@]}"; do
    $fastp -i ${fq1[i]} -I ${fq2[i]} -o ${out_dir}/trim/${fq1[i]} -O ${out_dir}/trim/${fq2[i]} \
    -h ${out_dir}/trim/${name[i]}_trim.html -j ${out_dir}/trim/${name[i]_trim.json}
  done;
elif [[ ${paired_end} == no ]]; then
  for i in "${!name[@]}"; do
    $fastp -i ${fq1[i]} -o ${out_dir}/trim/${fq1[i]} \
    -h ${out_dir}/trim/${name[i]}_trim.html -j ${out_dir}/trim/${name[i]_trim.json}
  done;
fi
