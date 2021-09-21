#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=00:10:00
#SBATCH --mem=50M
#SBATCH --job-name=rp_submit
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_submit_%A.out

# script exits if return value of a command is not zero
set -e
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
set -o noclobber

args=("$@")

sample_table=${args[0]}
config=${args[1]}

fastqc_step=/scratch/users/k2142172/scripts/pipeline/rp_fastqc.sh
multiqc_fastqc_step=/scratch/users/k2142172/scripts/pipeline/rp_multiqc_fastqc.sh
alignment_step=/scratch/users/k2142172/scripts/pipeline/rp_alignment.sh
multiqc_star_step=/scratch/users/k2142172/scripts/pipeline/rp_multiqc_star.sh
index_step=/scratch/users/k2142172/scripts/pipeline/rp_index_bams.sh
multiqc_samtools_step=/scratch/users/k2142172/scripts/pipeline/rp_multiqc_samtools.sh
counts_step=/scratch/users/k2142172/scripts/pipeline/rp_counts_matrix.sh
multiqc_featurecounts_step=/scratch/users/k2142172/scripts/pipeline/rp_multiqc_featurecounts.sh

export config=$config
export sample_table=$sample_table

sbatch --dependency=singleton $fastqc_step
sbatch --dependency=singleton $multiqc_fastqc_step
sbatch --dependency=singleton $alignment_step
sbatch --dependency=singleton $multiqc_star_step
sbatch --dependency=singleton $index_step
sbatch --dependency=singleton $multiqc_samtools_step
sbatch --dependency=singleton $counts_step
sbatch --dependency=singleton $multiqc_featurecounts_step

