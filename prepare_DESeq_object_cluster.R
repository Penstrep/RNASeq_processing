library(dplyr)
library(GenomicAlignments)
library(GenomicFiles)
library(rtracklayer)
library(DESeq2)
library(magrittr)

mouse_gff <- import('/SAN/vyplab/HuRNASeq/reference_datasets/RNASeq/Mouse/Mus_musculus.GRCm38.82_fixed.gtf')
mouse_gff_genes <- split(mouse_gff, mcols(mouse_gff)$gene_name)

SRR3657469_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657469_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657469_unique.bam.bai',
                          yieldSize = 100000)

SRR3657470_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657470_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657470_unique.bam.bai',
                          yieldSize = 100000)

SRR3657471_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657471_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657471_unique.bam.bai',
                          yieldSize = 100000)

SRR3657472_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657472_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657472_unique.bam.bai',
                          yieldSize = 100000)

SRR3657473_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657473_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657473_unique.bam.bai',
                          yieldSize = 100000)

SRR3657474_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657474_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657474_unique.bam.bai',
                          yieldSize = 100000)

SRR3657475_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657475_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657475_unique.bam.bai',
                          yieldSize = 100000)

SRR3657476_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657476_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657476_unique.bam.bai',
                          yieldSize = 100000)

SRR3657477_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657477_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657477_unique.bam.bai',
                          yieldSize = 100000)

SRR3657478_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657478_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657478_unique.bam.bai',
                          yieldSize = 100000)

SRR3657479_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657479_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657479_unique.bam.bai',
                          yieldSize = 100000)

SRR3657480_bam <- BamFile('/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657480_unique.bam', 
                          index = '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/SRR3657480_unique.bam.bai',
                          yieldSize = 100000)


bam_files <- c(SRR3657469_bam, SRR3657470_bam, SRR3657471_bam, SRR3657472_bam, SRR3657473_bam, SRR3657474_bam, SRR3657475_bam, SRR3657476_bam, SRR3657477_bam, SRR3657478_bam, SRR3657479_bam, SRR3657480_bam)
bam_list <- BamFileList(bam_files)
path <- "/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/sorted_bams/"

gene_counts <- summarizeOverlaps(features = mouse_gff_genes, reads = bam_list, mode = "IntersectionNotEmpty", singleEnd = FALSE)
Conditions <- as.factor(c(rep("WT", 6), rep("FUS-/-", 6)))
SRA_runtable <- '/SAN/vyplab/IoN_RNAseq/Errichelli_FUS/SraRunTable.txt'
SRA_runtable_col <- as.data.frame(SRA_runtable, row.names = as.character(SRA_runtable[, 5]))
colData(gene_counts) <- DataFrame(SRA_runtable_col)

#design <- data.frame(
#condition = c("control", "control", "FUS_KO", "FUS_KO"), 
#replicate = c(1, 2, 1, 2), 
#type = rep("paired-read", 4),
#countfiles = Conditions, 
#stringsAsFactors = TRUE)

gene_counts$genotype_s %<>% relevel("WT")
geneCDS <- DESeqDataSet(se = gene_counts, design = ~ Run_s + genotype_s)
