#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=24:00:00
#SBATCH --mem=16G
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --job-name=r_pipeline
#SBATCH --output=/scratch/users/k2142172/tests/rp_counts_matrix.out
#SBATCH --verbose

# script exits if return value of a command is not zero
set -e
# prints lines of script as they are run
set -v
# prevents overwriting of existing files through redirection
set -o noclobber

# import config variables
. ./$config

# create output dir if necessary, and redirect log and err files there
mkdir -p ${out_dir}/gene_expression/${aligner}

exec >${out_dir}/gene_expression/${aligner}/rp_counts_matrix.out 2>${out_dir}/gene_expression/${aligner}/rp_counts_matrix.err

# path to tools
featurecounts=/scratch/users/k2142172/packages/subread-2.0.1-Linux-x86_64/bin/featureCounts

# variable with list of bams
if [[ $aligner == STAR ]]; then
  bams=$(ls ${out_dir}/processed_bams/*.bam);
elif [[ $aligner == kallisto ]]; then
  bams=$(ls ${out_dir}/kallisto/*.bam);
fi

# set strandedness status
if [[ $strand == 'Unstranded' ]]; then
  strand_code=0;
elif [[ $strand == 'Forward' ]]; then
  strand_code=1;
elif [[ $strand == 'Reverse' ]]; then
  strand_code=2;
fi

# set paired end status
if [[ $paired_end == 'yes' ]]; then
  paired_code="-p";
else
  paired_code=""
fi

gtf=$(ls ${resources_dir}/${build}/*.gtf)

# run featurecounts over all bams to give one gene counts matrix
$featurecounts \
  -a $gtf \
  -F GTF \
  -g gene_id \
  $paired_code \
  -s $strand_code \
  -T 8 \
  --verbose \
  -o ${out_dir}/gene_expression/${aligner}/${project}_gene_counts.tab \
  $bams
