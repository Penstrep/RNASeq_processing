#!/bin/bash

#SBATCH --partition=cpu
#SBATCH --time=06:00:00
#SBATCH --mem=8G
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=4
#SBATCH --job-name=r_pipeline
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_fastqc.out

# script exits if return value of a command is not zero
set -e
# this forces all variables to be defined
set -u
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
set -o noclobber

# import config variables
. $config

echo $out_dir
echo $project

# create output dir if necessary, and redirect log and err files there
mkdir -p ${out_dir}/fastqc
exec >${out_dir}/fastqc/${project}_rp_fastqc.out 2>${out_dir}/fastqc/${project}_rp_fastqc.err

# path to tools
#module load openjdk
#fastqc=/scratch/users/k2142172/packages/FastQC/fastqc
module load fastqc

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
    fastqc ${fq1[i]} -o ${out_dir}/fastqc
    fastqc ${fq2[i]} -o ${out_dir}/fastqc
  done;
elif [[ ${paired_end} == no ]]; then
  for i in "${!name[@]}"; do
    fastqc ${fq1[i]} -o ${out_dir}/fastqc
  done;
fi
