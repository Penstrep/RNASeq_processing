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
step=${args[2]}

export sample_table=$sample_table
export config=$config

if [[ $step == fastqc_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_fastqc.sh
elif [[ $step == multiqc_fastqc_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_multiqc_fastqc.sh
elif [[ $step == trim_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_trim.sh
elif [[ $step == alignment_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_alignment.sh
elif [[ $step == multiqc_star_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_multiqc_star.sh
elif [[ $step == kallisto_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_kallisto_quant.sh
elif [[ $step == index_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_index_bams.sh
elif [[ $step == multiqc_samtools_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_multiqc_samtools.sh
elif [[ $step == counts_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_counts_matrix.sh
elif [[ $step == multiqc_featurecounts_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_multiqc_featurecounts.sh
elif [[ $step == counts_qc_step ]]; then
    sbatch /scratch/users/k2142172/scripts/pipeline/rp_counts_qc.sh
fi

