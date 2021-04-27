#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=72:00:00
#SBATCH --mem=8G
#SBATCH --job-name=rp_fastqc
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_fastqc.out

# script exits if return value of a command is not zero
#set -e
# this forces all variables to be defined
#set -u
# for debugging prints out every line before executing it
#set -x

# import config variables
. ./$config

# create output dir if necessary, and redirect log and err files there
mkdir -p ${out_dir}/fastqc
exec >${out_dir}/fastqc/${project}_rp_fastqc.out 2>${out_dir}/fastqc/${project}_rp_fastqc.err

# path to tools
module load apps/openjdk
fastqc=/scratch/users/k2142172/packages/FastQC/fastqc

# import sample table as arrays for each column
while read col1 col2 col3 col4; do
  name+=($col1)
  fq1+=($col2)
  fq2+=($col3)
  cond+=($col4)
done < $sample_table

# run fastqc over each iteration of fq1 and fq2 arrays
for i in "${!name[@]}"; do
  $fastqc ${fq1[i]} -o ${out_dir}/fastqc
  $fastqc ${fq2[i]} -o ${out_dir}/fastqc
done
