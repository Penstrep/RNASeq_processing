import pandas as pd

configfile: 'config.yml'

table = pd.read_table(config['sample_table'], header=None)
sample = table[0][0:2]
fq1 = table[1][0:2]
#fq2 = table[2][0:2]'

rule all:
	input:
                expand('{base_dir}/outputs/snake/fastqc/{sample}_fastqc.zip', sample=config['sample'], base_dir=config['base_dir']),
		'{base_dir}/outputs/snake/fastqc/{sample}_fastqc.zip',
		expand('{base_dir}/outputs/snake/fastqc/{sample}_multiqc.html', sample=sample, base_dir=config['base_dir']),
		'{base_dir}/outputs/snake/multiqc/multiqc_fastqc.html',
		expand('{base_dir}/outputs/snake/processed_bams/{sample}_Aligned.sortedByCoord.out.bam.bai', base_dir=config['base_dir'], sample=sample),
		'{base_dir}/outputs/snake/multiqc/multiqc_star.html',
		expand('{base_dir}/outputs/snake/samtools_stats/{sample}_idxstats.txt', base_dir=config['base_dir'], sample=sample),
		'{base_dir}/outputs/snake/multiqc/multiqc_index.html',
		'{base_dir}/outputs/snake/counts/gene_counts.tab'

rule fastqc:
	input: 
		fq1=expand(fq1)
	output:
		zip=expand('{base_dir}/outputs/{project}/fastqc/{sample}_fastqc.zip', base_dir=config['base_dir'], project=config['project'], sample=sample),
		html=expand('{base_dir}/outputs/{project}/fastqc/{sample}_fastqc.html', base_dir=config['base_dir'], project=config['project'], sample=sample)
        log:
                expand('{base_dir}/outputs/{project}/logs/{sample}_fastqc.out', base_dir=config['base_dir'], project=config['project'], sample=sample)
	params:
		fastqc=config['fastqc'],
		outdir=f'{config['base_dir']}/outputs/{config['project']}/fastqc'
	shell: 
		'''
		echo {params.outdir}
		{params.fastqc} {input.fq1} --outdir={params.outdir}
		'''

rule multiqc_fastqc:
	input: 
		zip=rules.fastqc.output.zip,
		html=rules.fastqc.output.html
	output: 
		'{base_dir}/outputs/snake/multiqc/{project}_multiqc_fastqc.html'
        log:
                '{base_dir}/outputs/snake/logs/{project}_multiqc_fastqc.out'
	params:
		multiqc=config['multiqc']
	shell: '''
		{params.multiqc} {input.zip} --ignore {input.html} -n {output}
		'''
	
rule star_alignment:
	input:
		fq='{base_dir}/raw_data/verstockt_ibd/{sample}.fastq.gz'
	output:
		bam='{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Aligned.sortedByCoord.out.bam'
	logs:
		'{base_dir}/outputs/snake/logs/{sample}_star.out'
	params:
		star=config['star'],
                index='/scratch/users/k2142172/resources/GRCh38/STAR/'
	
	shell: '''
		{params.star} --runThreadN 8 --readFilesIn {input.fq} 
		--readFilesCommand zcat --genomeLoad LoadAndKeep --genomeDir {params.index} --outFileNamePrefix {output.bam} 
		--outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 30000000000 outSAMunmapped Within
		'''

rule multiqc_star:
	input: 
#		log_out=expand('{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Log.out', base_dir=config['base_dir'], sample=sample),
#		log_final=expand('{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Log.final.out', base_dir=config['base_dir'], sample=sample)
		logs=expand('{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Log.{ext}', base_dir=config['base_dir'], sample=sample, ext=['final.out', 'out'])
	output:
		'{base_dir}/outputs/snake/multiqc/{project}_multiqc_star.html'
	params:
		multiqc=config['multiqc']
	shell: '''
		{params.multiqc} {input.logs} -n {output}
		'''


rule index_bams:
	input:
                bam='{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Aligned.sortedByCoord.out.bam'
#		bams=rules.star_alignment.output
	output:
		bai='{base_dir}/outputs/snake/processed_bams/{sample}_Aligned.sortedByCoord.out.bam.bai'
	params:
		samtools=config['samtools']
	log:
		'{base_dir}/outputs/snake/fastqc/{sample}_samtools.out'
	shell: '''
                {params.samtools} index -b {input.bam} > {output.bai}
		'''


rule bam_stats:
	input:
		bam='{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Aligned.sortedByCoord.out.bam'
	output: 
		stat='{base_dir}/outputs/snake/samtools_stats/{sample}_stats.txt',
		idx='{base_dir}/outputs/snake/samtools_stats/{sample}_idxstats.txt'
	params:
		samtools=config['samtools']
	shell: '''
		{params.samtools} idxstats {input.bam} > {output.idx}
		{params.samtools} stats {input.bam} > {output.stat}
		'''	


rule multiqc_index:
	input: 
		stats=expand(rules.bam_stats.output, base_dir=config['base_dir'], sample=sample)
#		idxstats=expand('{base_dir}/outputs/verstockt_ibd/processed_bams/samtools_stats/{sample}_idxstats.txt', base_dir=config['base_dir'], sample=sample),
#		stats=expand('{base_dir}/outputs/verstockt_ibd/processed_bams/samtools_stats/{sample}_stats.txt', base_dir=config['base_dir'], sample=sample)
	output:
		'{base_dir}/outputs/snake/multiqc/{project}_multiqc_index.html'
	params:
		multiqc=config['multiqc']
	shell: '''
		{params.multiqc} {input.stats} -n {output}
		'''
#		{params.multiqc} {input.idxstats} {input.stats} -n {output}
#		'''

rule counts:
	input:
		bams=expand(rules.star_alignment.output.bam, base_dir=config['base_dir'], sample=sample),
		gtf='{base_dir}/resources/GRCh38/Homo_sapiens.GRCh38.103.gtf'
	output:
		'{base_dir}/outputs/snake/counts/{project}_gene_counts.tab',
		'{base_dir}/outputs/snake/counts/{project}_gene_counts.tab.summary'
	params:
		fc=config['featurecounts'],
		feature=config['feature'],
		strand=config['strand']
#	log: 
#		'{base_dir}/outputs/snake/fastqc/counts.out'
	shell:	'''
		{params.fc} -a {input.gtf} -F GTF -g {params.feature} -s {params.strand} --verbose -o {output} {input.bams}
		'''
		
rule multiqc_counts:
	input:
		'{base_dir}/outputs/verstockt_ibd/gene_expression/verstockt_ibd_gene_counts.tab.summary'
	output:
		'{base_dir}/outputs/snake/multiqc/{project}_multiqc_featurecounts.html'
	params:
		multiqc=config['multiqc']
#	log:
#		'{base_dir}/outputs/snake/fastqc/multiqc_featurecounts.out'
	shell: '''
		{params.multiqc} {input} -n {output}
		'''
