RNA-Seq pipeline

RNA-Seq data processing pipeline scripts
Can be run as one submission to run default methods 'submit_pipeline.sh'
Can also be run step-by-step to check outputs at each stage or change run order 'submit_step.sh'

Run requires two files to be provided to the job submission as command line arguments:
- A sample table with 4 columns. First column of each sample ID, second column the full path to read 1
  fastq.gz files, third column the full path to the read 2 fastq.gz files if paired end sequencing used,
  fourth column can be set to all 0s or NAs, will be used for phenotype group data in the future
- A config file, with settings about how the run should go. Includes options for output folder location, 
  species reference to use, aligner to use, samples to drop etc.
For examples see 'example_sample_table.tab' and 'example_config.txt'

To run as one submission:
sbatch submit_pipeline.sh <sample_table> <config_file>

Normal run order:
rp_fastqc.sh
rp_multiqc_fastqc.sh
rp_alignment.sh 
rp_multiqc_star.sh
rp_index_bams.sh 
rp_multiqc_samtools.sh
rp_counts_matrix.sh
rp_multiqc_featurecounts.sh


To run as an individual step:
sbatch submit_step.sh <sample_table> <config_file> <step_name>

Step options:
- step_name ==== step_script

- fastqc_step ==================== rp_fastqc.sh
multiqc_fastqc_step ============== rp_multiqc_fastqc.sh
- alignment_step ================= rp_alignment.sh
multiqc_star_step ================ rp_multiqc_star.sh
kallisto_step ==================== rp_kallisto_quant.sh
- index_step ===================== rp_index_bams.sh
multiqc_samtools_step ============ rp_multiqc_samtools.sh
- counts_step ==================== rp_counts_matrix.sh
multiqc_featurecounts_step ======= rp_multiqc_featurecounts.sh
counts_qc_step =================== rp_counts_qc.sh



Work in progress:
Include read trimming option in rp_trim.sh, not currently available in pipeline
Snakemake format file and run


