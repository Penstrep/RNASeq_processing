library(GenomicRanges)
library(GenomicFeatures)
library(GenomicAlignments)

hse <- makeTxDbFromBiomart(biomart = "ensembl", dataset = "mmusculus_gene_ensembl")

exonicParts <- disjointExons(hse, aggregateGenes = FALSE)

bamDirpath <- "X:/M323K/Adult spinal cord/"

bamDirs <- list.files(bamDirpath, pattern = "_[0-9]$", full.names = TRUE)

sample_names_vec <- list.files(bamDirpath, pattern = "_[0-9]$", full.names = FALSE)

bam_files <- unname(sapply(bamDirs, list.files, pattern = "bam$", full.names = TRUE))
bam_index_files <- unname(sapply(bamDirs, list.files, pattern = "bai$", full.names = TRUE))

bamVec <- list()

for (i in 1:length(bam_files)) {
 bamVec <- append(bamVec, BamFile(bam_files[i], index = bam_index_files[i], asMates = TRUE))
}

bamlst <- BamFileList(bamVec, yieldSize = 10000)

#SE <- summarizeOverlaps(exonicParts, bamlst, mode = "Union", singleEnd = FALSE, ignore.strand = TRUE)
