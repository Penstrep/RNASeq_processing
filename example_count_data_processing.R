library(readr)
library(tidyr)
library(dplyr)
library(tibble)
library(ggplot2)
library(RColorBrewer)
library(mixOmics)

#count data
load('X:/M323K/Adult spinal cord/deseq2/deseq_counts_M323K_adult.RData')

#conversion to df
pseudoCount <- log2(genes.counts + 1)
pseudoCount_df <- pseudoCount %>%
  as.data.frame() %>%
  rownames_to_column(var = "EnsemblID")

#log2 visualisation of count distributions
ggplot(pseudoCount_df, aes(x = M323K_WT_1)) + geom_histogram(binwidth = 0.6)

#rpkm data
m323k_adult_rpkms <- read_csv('X:/M323K/Adult spinal cord/deseq2/rpkm_values.csv')

#conversion to required df for WT 1
pseudorpkm <- log2(m323k_adult_rpkms[["M323K_WT_1"]] + 1) %>%
  as.data.frame()
names(pseudorpkm) <- "rpkms"

#log2 visualisation of rpkm distributions  
ggplot(pseudorpkm, aes(x = rpkms)) + geom_histogram(binwidth = 0.6)

#melted count data
meltCount <- pseudoCount_df %>%
  gather(key = sample, value = counts, -EnsemblID) %>%
  mutate(condition = ifelse(grepl("WT", sample), yes = "WT", 
                            no = ifelse(grepl("HET", sample), yes = "HET", 
                                      no = "HOM")))

#box plot visualisation of variance in count data for each sample
ggplot(meltCount, aes(x = sample, y = counts, fill = condition)) + 
  geom_boxplot()

#density plot (smooth histogram) of count data in each sample by condition
ggplot(meltCount, aes(x = counts, colour = sample, fill = sample)) + 
  geom_density(alpha = 0.2, size = 1.25) +
  facet_wrap(~condition)

#MA plot of count data variance between samples
x = pseudoCount_df[, "M323K_WT_1"]
y = pseudoCount_df[, "M323K_WT_2"]
M = x - y
A = (x + y) / 2
MA_df <- data.frame(A, M)
ggplot(MA_df, aes(A, M)) +
  geom_point(alpha = 0.2) +
  geom_hline(yintercept = 0) + 
  stat_smooth(se = FALSE, method = "loess")

#clustering samples with clustering image map
mat_dist <- as.matrix(dist(t(pseudoCount_df[, -1])))
mat_dist <- mat_dist/max(mat_dist)  

hmcol <- colorRampPalette(brewer.pal(9, "GnBu"))(16)
cim(mat_dist, color = rev(hmcol))

#PCA
rv <- pseudoCount %>% 
  rowVars() %>%
  order(decreasing = TRUE)
pca <- prcomp(t(pseudoCount[rv, ]))

anno <- AnnotatedDataFrame(data = data.frame(pseudoCount_df$condition, row.names = colnames(pseudoCount)))
expSet <- new("ExpressionSet", exprs = pseudoCount, phenoData = annot)
#...

#MDS
x <- pseudoCount
s <- rowMeans((x - rowMeans(x)) ^ 2)
o <- order(s, decreasing = TRUE)
x <- x[o, ]
x <- x[1:5000, ]
D[i, j] <- sqrt(colMeans((x[, i] - x[, j]) ^ 2))
#...


