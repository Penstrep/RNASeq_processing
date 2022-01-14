configfile: 'config.yml'


rule all:
	input:
#               expand('{base_dir}/outputs/snake/fastqc/{sample}_fastqc.zip', sample=config['sample'], base_dir=config['base_dir']),
#		'{base_dir}/outputs/snake/fastqc/{sample}_fastqc.zip',
		expand('{base_dir}/outputs/snake/fastqc/{sample}_multiqc.html', sample=config['sample'], base_dir=config['base_dir'])
#		'{base_dir}/outputs/snake/fastqc/{sample}_multiqc.html'

rule fastqc:
	output: 
		zip='{base_dir}/outputs/snake/fastqc/{sample}_fastqc.zip',
		html='{base_dir}/outputs/snake/fastqc/{sample}_fastqc/html'
	input: 
#		'{base_dir}/raw_data/verstockt_ibd/{sample}.fastq.gz'
		fq=expand('{base_dir}/raw_data/{project}/{sample}.fastq.gz', base_dir=config['base_dir'], project=config['project'], sample=config['sample'])
#		fq=expand('config['base_dir']/raw_data/verstockt_ibd/config['sample'].fastq.gz')
	param:
		outdir='{base_dir}/outputs/snake/fastqc'
	log: 
		'{base_dir}/outputs/snake/fastqc/{sample}.out'
	shell: 
		'''
		/scratch/users/k2142172/packages/FastQC/fastqc {input} --outdir={param.outdir}
		'''
#		/scratch/users/k2142172/packages/FastQC/fastqc {input} --outdir=/scratch/users/k2142172/outputs/snake/fastqc/
#		'''

rule multiqc_fastqc:
	input: 
		zip=rules.fastqc.output.zip
		html=rules.fastqc.output.html
#		zip='{base_dir}/outputs/snake/fastqc/{sample}_fastqc.zip',
#		html='{base_dir}/outputs/snake/fastqc/{sample}_fastqc.html'
	output: 
		'{base_dir}/outputs/snake/fastqc/{sample}_multiqc.html'
	log:
		'{base_dir}/outputs/snake/fastqc/{sample}_multiqc.out'
	shell: '''
		/scratch/users/k2142172/packages/anaconda3/envs/r4/bin/multiqc {input.zip} 
		--ignore {input.html} -n {output}
		'''
	
rule star_alignment:
	input:
		index='{base_dir}/resources/STAR',
		fqs=expand('{base_dir}/raw_data/verstockt_ibd/{sample}_fastq.gz', sample=config['sample'], base_dir=config['base_dir'])
	output:
		bams=expand('{base_dir}/outupts/snake/fastq/{sample}_', sample=config['sample'], base_dir=config['base_dir'])
	shell: '''
		/scratch/users/k2142172/packages/STAR-2.7.8a/bin/Linux_x86_64_static/STAR --runThreadN 8 --readFilesIn {input.fqs} 
		--readFilesCommand zcat --genomeLoad LoadAndKeep --genomeDir {input.index} --outFileNamePrefix {output} 
		--outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 30000000000 outSAMunmapped Within
		'''


rule index_bams:
	input:
                bams=expand('{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Aligned.sortedByCoord.out.bam', sample=config['sample'], base_dir=config['base_dir'])
	output:
		bai=expand('{base_dir}/outputs/snake/fastqc/{sample}_Aligned.sortedByCoord.out.bam.bai', sample=config['sample'], base_dir=config['base_dir'])
#		idxstats='{base_dir}/outputs/snake/fastqc/{sample}_idxstats.txt',
#		stats='{base_dir}/outputs/snake/fastqc/{sample}_stats.txt'
#	log:
#		'{base_dir}/outputs/snake/fastqc/{sample}_samtools.out'
	shell: '''
		/scratch/users/k2142172/packages/samtools-1.11/bin/samtools index -b {input} {output.bai}
		'''
#		/scratch/users/k2142172/packages/samtools-1.11/bin/samtools idxstats {input} > {output.idxstats}
#		/scratch/users/k2142172/packages/samtools-1.11/bin/samtools stats {input} > {output.stats}
#		'''


rule multiqc_index:
	input: 
		'{base_dir}/outputs/snake/fastqc'
	output:
		'{base_dir}/outputs/snake/fastqc/multiqc_index.html'
	shell: '''
		/scratch/users/k2142172/packages/anaconda3/envs/r4/bin/multiqc {input} -n {output}
		'''

rule counts:
	input:
		bams=expand('{base_dir}/outputs/verstockt_ibd/processed_bams/{sample}_Aligned.sortedByCoord.out.bam', sample=config['sample'], base_dir=config['base_dir']),
		gtf='{base_dir}/resources/GRCh38/Homo_sapiens.GRCh38.103.gtf'
	output:
		'{base_dir}/outputs/snake/fastqc/gene_counts.tab'
	params:
		feat=config['feature']
	log: 
		'{base_dir}/outputs/snake/fastqc/counts.out'
	shell:	'''
		/scratch/users/k2142172/packages/subread-2.0.1-Linux-x86_64/bin/featureCounts \
		-a {input.gtf} \
		-F GTF \
		-g {params.feat} \
		--verbose \
		-o {output} \
		{input.bams}
		'''
		
rule multiqc_counts:
	input:
		'{base_dir}/outputs/snake/fastqc'
	output:
		'{base_dir}/outputs/snake/fastqc/multiqc_featurecounts.html'
	log:
		'{base_dir}/outputs/snake/fastqc/multiqc_featurecounts.out'
	shell: '''
		/scratch/users/k2142172/packages/anaconda3/envs/r4/bin/multiqc {input} -n {output}
		'''
