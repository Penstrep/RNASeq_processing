#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=72:00:00
#SBATCH --mem=42G
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --job-name=rp_alignment
#SBATCH --output=/scratch/users/k2142172/tests/rp_alignment.out
#SBATCH --verbose

# script exits if return value of a command is not zero
set -e
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
#set -o noclobber

# import config variables
. ./$config

# create output dir if necessary, and redirect log and err files there
mkdir -p ${out_dir}/processed_bams
#exec >/${out_dir}/processed_bams/${project}_rp_alignment.out 2>${out_dir}/processed_bams/${project}_rp_alignment.err

# path to tools
star=/scratch/users/k2142172/packages/STAR-2.7.8a/bin/Linux_x86_64_static/STAR
#samtools=/scratch/users/k2142172/packages/samtools-1.11/bin/samtools

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
elif [[ $paired_end} == no ]]; then
  mates=(${fq1[@]})
fi

# load star genome
$star --genomeDir ${resources_dir}/${build}/STAR --genomeLoad LoadAndExit
# use loaded genome to run star, iterating over each paired end array item
# include samtools indexing of bams in iteration
for i in ${!mates[@]}; do
  $star \
    --runThreadN 8 \
    --readFilesIn ${mates[i]} \
    --readFilesCommand zcat \
    --genomeLoad LoadAndKeep \
    --genomeDir ${resources_dir}/${build}/STAR \
    --outFileNamePrefix ${out_dir}/processed_bams/${name[i]}_ \
    --outSAMtype BAM SortedByCoordinate \
    --limitBAMsortRAM 30000000000 \
    --outSAMunmapped Within
done
# remove loaded genome
$star --genomeDir ${resources_dir}/${build}/STAR --genomeLoad Remove
