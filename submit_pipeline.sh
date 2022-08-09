#!/bin/bash

#SBATCH --partition=cpu
#SBATCH --time=00:10:00
#SBATCH --mem=50M
#SBATCH --job-name=rp_submit
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_submit_%A.out

# script exits if return value of a command is not zero
set -e
# this forces all variables to be defined
set -u
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
set -o noclobber

args=("$@")

sample_table=${args[0]}
config=${args[1]}

scripts_dir=/scratch/users/k2142172/scripts/RNASeq_processing

fastqc_step=${scripts_dir}/rp_fastqc.sh
multiqc_fastqc_step=${scripts_dir}/rp_multiqc_fastqc.sh
alignment_step=${scripts_dir}/rp_alignment.sh
multiqc_star_step=${scripts_dir}/rp_multiqc_star.sh
index_step=${scripts_dir}/rp_index_bams.sh
multiqc_samtools_step=${scripts_dir}/rp_multiqc_samtools.sh
counts_step=${scripts_dir}/rp_counts_matrix.sh
multiqc_featurecounts_step=${scripts_dir}/rp_multiqc_featurecounts.sh

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

