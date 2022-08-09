#!/bin/bash

#SBATCH --partition=cpu
#SBATCH --mem=8G
#SBATCH --time=08:00:00
#SBATCH --ntasks=2
#SBATCH --nodes=1
#SBATCH --job-name=r_pipeline
#SBATCH --output=/scratch/users/k2142172/tests/rp_kallisto_quant.out
#SBATCH --verbose

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

# create output dir if necessary, and redirect log and err files there
mkdir -p ${out_dir}/kallisto
exec >/${out_dir}/kallisto/${project}_rp_kallisto_quant.out 2>${out_dir}/kallisto/${project}_rp_kallisto_quant.err

# path to tools
kallisto=/scratch/users/k2142172/packages/kallisto/kallisto
kallisto_index=${resources_dir}/${build}/kallisto/kallisto.idx
gtf=$(ls ${resources_dir}/${build}/*.gtf)

# import sample table as arrays for each column
while read col1 col2 col3 col4; do
  name+=($col1)
  fq1+=($col2)
  fq2+=($col3)
  cond+=($col4)
done < $sample_table

# combine fq1 and fq2 array items into one array for paired ends
if [[ ${paired_end} == yes ]]; then
  for i in "${!name[@]}"; do
    mates[i]=$(echo ${fq1[i]} ${fq2[i]})
  done;
elif [[ ${paired_end} == no ]]; then
  mates=(${fq1[@]})
fi

# currently only use if single and reverse stranded

for i in ${!mates[@]}; do
  $kallisto quant \
    --index=$kallisto_index \
    --output-dir=${out_dir}/kallisto/${name[i]} \
    --threads=2 \
    --genomebam \
    --gtf=$gtf \
    --single \
    --fragment-length=200 \
    --sd=20 \
    ${mates[i]}
done

# reorganise dir structure
for nm in ${name[@]}; do
  dir=${out_dir}/kallisto/${nm}
  if [[ -d $dir ]]; then
    files=($(ls $dir))
    for f in ${files[@]}; do
      mv ${dir}/${f} ${dir}_${f}
    done;
    rmdir ${dir};
  fi;
done
