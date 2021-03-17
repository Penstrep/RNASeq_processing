#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=4:00:00
#SBATCH --mem=8G
#SBATCH --job-name=rp_index_bam
#SBATCH --output=/scratch/users/k2142172/tests/rp_index_bam.out
#SBATCH --verbose

# script exits if return value of a command is not zero
set -e
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
set -o noclobber

. ./$config

mkdir -p ${out_dir}/processed_bams/samtools_stats

exec >${out_dir}/processed_bams/samtools_stats/${project}_rp_index_bam.out 2>${out_dir}/processed_bams/samtools_stats/${project}_rp_index_bam.err

# path to tools
samtools=/scratch/users/k2142172/packages/samtools-1.11/bin/samtools

# import sample table as arrays for each column
while read col1 col2 col3 col4; do
  name+=($col1)
  fq1+=($col2)
  fq2+=($col3)
  cond+=($col4)
done < $sample_table

for i in ${!name[@]}; do
  bam=${out_dir}/processed_bams/${name[i]}_Aligned.sortedByCoord.out.bam
#  $samtools quickcheck -v -u $bam > ${out_dir}/processed_bams/samtools_stats/${name[i]}_samtools_quickcheck.txt
  $samtools index -b $bam
  $samtools idxstats $bam > ${out_dir}/processed_bams/samtools_stats/${name[i]}_idxstats.txt
  $samtools stats $bam > ${out_dir}/processed_bams/samtools_stats/${name[i]}_stats.txt
done

# if possible mark duplicates, but requires space for creating new versions of bams
#$samtools fixmate -m sorted.bam new.bam
#$samtools markdup new.bam markdup.bam
# plot-bamstats for future plots from samtools stats
