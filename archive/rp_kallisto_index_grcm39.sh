#!/bin/bash

#SBATCH --partition=brc
#SBATCH --job-name=kallisto_index
#SBATCH --time=04:00:00
#SBATCH --mem=8G
#SBATCH --output=/scratch/users/k2142172/tests/kallisto_index.out
#SBATCH --verbose

kallisto=/scratch/users/k2142172/packages/kallisto/kallisto
fasta=/scratch/users/k2142172/resources/GRCm39/Mus_musculus.GRCm39.dna.primary_assembly.fa

mkdir -p /scratch/users/k2142172/resources/GRCm39/kallisto

output=/scratch/users/k2142172/resources/GRCm39/kallisto

$kallisto version
$kallisto index -i ${output}/kallisto.idx $fasta
