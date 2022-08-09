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
step=${args[2]}

scripts_dir=/scratch/users/k2142172/scripts/RNASeq_processing

export sample_table=$sample_table
export config=$config

if [[ $step == fastqc_step ]]; then
    sbatch ${scripts_dir}/rp_fastqc.sh
elif [[ $step == multiqc_fastqc_step ]]; then
    sbatch ${scripts_dir}/rp_multiqc_fastqc.sh
elif [[ $step == trim_step ]]; then
    sbatch ${scripts_dir}/rp_trim.sh
elif [[ $step == alignment_step ]]; then
    sbatch ${scripts_dir}/rp_alignment.sh
elif [[ $step == multiqc_star_step ]]; then
    sbatch ${scripts_dir}/rp_multiqc_star.sh
elif [[ $step == kallisto_step ]]; then
    sbatch ${scripts_dir}/rp_kallisto_quant.sh
elif [[ $step == index_step ]]; then
    sbatch ${scripts_dir}/rp_index_bams.sh
elif [[ $step == multiqc_samtools_step ]]; then
    sbatch ${scripts_dir}/rp_multiqc_samtools.sh
elif [[ $step == counts_step ]]; then
    sbatch ${scripts_dir}/rp_counts_matrix.sh
elif [[ $step == multiqc_featurecounts_step ]]; then
    sbatch ${scripts_dir}/rp_multiqc_featurecounts.sh
elif [[ $step == counts_qc_step ]]; then
    sbatch ${scripts_dir}/rp_counts_qc.sh
fi

