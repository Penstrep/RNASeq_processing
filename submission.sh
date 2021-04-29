#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=00:10:00
#SBATCH --mem=50M
#SBATCH --job-name=rp_submit
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests//rp_submit_%A.out

# script exits if return value of a command is not zero
set -e
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
set -o noclobber

args=("$@")

sample_table=${args[0]}
config=${args[1]}

fastqc_step=/scratch/users/k2142172/scripts/rp_fastqc.sh
multiqc_step=/scratch/users/k2142172/scripts/rp_multiqc.sh
alignment_step=/scratch/users/k2142172/scripts/rp_alignment.sh
index_step=/scratch/users/k2142172/scripts/rp_index_bams.sh
counts_step=/scratch/users/k2142172/scripts/rp_counts_matrix.sh

export config=$config
export sample_table=$sample_table

sbatch $fastqc_step
#sbatch $multiqc_step
#sbatch $alignment_step
#sbatch $index_step
#sbatch $counts_step
