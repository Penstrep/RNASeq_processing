library(tidyverse)
library(DESeq2)

# load counts matrix file and sample table
df <- read.table('ramsey/ramsey_s303_gene_counts.tab', header = T, row.names = 1, skip = 1)
st <- read.table('ramsey/ramsey_s303_sample_table.tab')

# set names for sample table columns
names(st) <- c('name', 'fq1', 'fq2', 'cond')

# convert counts matrix file to counts matrix
cm <- df %>%
  dplyr::select(-c(1:5)) %>%
  apply(c(1, 2), as.integer) %>%
  as.matrix()

# convert counts matrix path headers to IDs only
ids <- str_remove(colnames(cm), '^.*bams.') %>% str_remove('_Aligned.*$')

# create comparison dataframe of old and new matrix IDS
names.df <- data.frame(
  counts_matrix_name = colnames(cm), 
  new_names = ids
)

# set new matrix IDs
colnames(cm) <- ids

# remove all genes wiht 0 counts in any sample from matrix
filtZeroCounts <- function(mat){
  mat[apply(mat, 1, function(x) all(x !=0 )), ]
}

dim(cm)
cm <- filtZeroCounts(cm)
dim(cm)

sf <- estimateSizeFactorsForMatrix(cm)

plotColsums <- function(mat){ 
  colSums(mat) %>%
    as.data.frame() %>% 
    `colnames<-`('sf') %>% 
    rownames_to_column('sample') %>% 
    ggplot(aes(sample, sf)) + 
    geom_col() +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0)) +
    xlab('Sample') +
    ylab('Counts')
}


ncm <- sweep(cm, 2, sf, '/')

plotColsums(cm)
plotColsums(ncm)


plotDist <- function(mat){
  as.data.frame(mat)[1:20, ] %>% 
    rownames_to_column('gene') %>% 
    pivot_longer(2:last_col(), names_to = 'sample') %>%
    ggplot(aes(gene, log10(value))) + 
    geom_violin(aes(colour = gene)) + 
    geom_jitter(size = 0.5, alpha = 0.2) +
    geom_boxplot(alpha = 0.2) +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 75, hjust = 1, vjust = 1, size = 7), 
          legend.position = 'None') +
    labs(x = 'Gene', y = 'Log10 counts')
}

plotDist(cm)
plotDist(ncm)

