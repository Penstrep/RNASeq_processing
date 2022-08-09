#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=1:00:00
#SBATCH --mem=1G
#SBATCH --job-name=r_pipeline
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_multiqc.out

# script exits if return value of a command is not zero
set -e
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
set -o noclobber

# import config variables
. $config

# redirect log and err files 
exec >${out_dir}/processed_bams/${project}_rp_multiqc_star.out 2>${out_dir}/processed_bams/${project}_rp_multiqc_star.err

# multiqc
module load apps/multiqc

multiqc ${out_dir}/processed_bams/*Log* --ignore ${out_dir}/processed_bams/*bam* -n ${out_dir}/processed_bams/${project}_rp_multiqc_star.html




