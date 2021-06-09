#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=3:00:00
#SBATCH --mem=80G
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --job-name=gen_star_index
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_star_genome_grch38.out

# script exits if return value of a command is not zero
set -e
# print shell input lines as they are read for debugging
set -v
# prevents output redirection from overwriting existing files
set -o noclobber

star=/scratch/users/k2142172/packages/STAR-2.7.8a/bin/Linux_x86_64_static/STAR
build=GRCm39
resources_dir=/scratch/users/k2142172/resources/${build}

mkdir -p ${resources_dir}/STAR

#using ensembl references
$star \
  --runThreadN 8 \
  --runMode genomeGenerate \
  --genomeDir ${resources_dir}/STAR \
  --genomeFastaFiles ${resources_dir}/Mus_musculus.GRCm39.dna.primary_assembly.fa \
  --sjdbGTFfile ${resources_dir}/Mus_musculus.GRCm39.104.gtf

# no haplotype or patch info, but all chromosomes and scaffolds to be used
