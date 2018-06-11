library(dplyr)
library(magrittr)

q331k_5m_fc_hom_sgseq <- read.delim('/RNAseq/Sreedharan_Q331K/frontal_cortex/processed/SGSeq/CONTROL_Q331K_HOM/Jemeen_5mo_frontal_cortex_CONTROL_Q331K_HOM_res_clean_novel.tab')
q331k_5m_fc_het_sgseq <- read.delim('/RNAseq/Sreedharan_Q331K/frontal_cortex/processed/SGSeq/CONTROL_Q331K_HET/Jemeen_5mo_frontal_cortex_CONTROL_Q331K_HET_res_clean_novel.tab')
q331k_5m_lmn_hom_sgseq <- read.delim('/RNAseq/Sreedharan_Q331K/lower_motor_neuron/SGSeq/CTL_HOM/Jemeen_lower_motor_neuron_CTL_HOM_res_clean_novel.tab')
q331k_5m_lmn_het_sgseq <- read.delim('/RNAseq/Sreedharan_Q331K/lower_motor_neuron/SGSeq/CTL_HET/Jemeen_lower_motor_neuron_CTL_HET_res_clean_novel.tab')
q331k_20m_fc_hom_sgseq <- read.delim('E:/RNASeq data/RNAseq/Sreedharan_Q331K/20m_frontal_cortex/SGSeq/CTL_HOM/Jemeen_20mo_frontal_cortex_CTL_HOM_res_clean_novel.tab')
q331k_20m_fC_het_sgseq <- read.delim('E:/RNASeq data/RNAseq/Sreedharan_Q331K/20m_frontal_cortex/SGSeq/CTL_HET/Jemeen_20mo_frontal_cortex_CTL_HET_res_clean_novel.tab')

create_bed_format <- function(x) {
  from_col <- strsplit((as.character(x$from)), split = ":", fixed = TRUE)
  to_col <- strsplit((as.character(x$to)), split = ":", fixed = TRUE)
  from_df <- t(as.data.frame(from_col))
  to_df <- t(as.data.frame(to_col))
  rownames(from_df) <- NULL
  rownames(to_df) <- NULL
  x <- mutate(x, chrom = from_df[,2], chromStart = ifelse(from_df[,3] < to_df[,3], yes = from_df[,3], no = to_df[,3]), chromEnd =   ifelse(from_df[,3] > to_df[,3], yes = from_df[,3], no = to_df[,3]), strand = from_df[,4])
  x <- x[, c(((ncol(x)-3) : (ncol(x))), 1 : (ncol(x)-4))]
}

delta_psi_calculation_hom <- function(x) {
  CTL_psi <- subset(x, select = c(grepl("(CONTROL|CTL).*psi$", colnames(x))))
  HOM_psi <- subset(x, select = c(grepl("*HOM.*psi$", colnames(x))))
  x <- mutate(x, CTL_average_psi = rowMeans(CTL_psi), HOM_average_psi = rowMeans(HOM_psi), delta_psi = HOM_average_psi - CTL_average_psi)
}

delta_psi_calculation_het <- function(x) {
  CTL_psi <- subset(x, select = c(grepl("(CONTROL|CTL).*psi$", colnames(x))))
  HET_psi <- subset(x, select = c(grepl("*HET.*psi$", colnames(x))))
  x <- mutate(x, CTL_average_psi = rowMeans(CTL_psi), HET_average_psi = rowMeans(HET_psi), delta_psi = HET_average_psi - CTL_average_psi)
}

q331k_5m_fc_hom_sgseq_mod <- q331k_5m_fc_hom_sgseq %>%
  create_bed_format() %>%
  delta_psi_calculation_hom() %>%
  subset(select = c(1:3, 51, 53, 4, 29, 14, 54:56, 5:13, 15:28, 30:50, 52))

q331k_5m_fc_het_sgseq_mod <- q331k_5m_fc_het_sgseq %>%
  create_bed_format() %>%
  delta_psi_calculation_het() %>%
  subset(select = c(1:3, 47, 49, 4, 27, 14, 50:52, 5:13, 15:26, 28:46, 48))

q331k_5m_lmn_hom_sgseq_mod <- q331k_5m_lmn_hom_sgseq %>%
  create_bed_format() %>%
  delta_psi_calculation_hom() %>%
  subset(select = c(1:3, 39, 41, 4, 23, 14, 42:44, 5:13, 15:22, 24:38, 40))
  
q331k_5m_lmn_het_sgseq_mod <- q331k_5m_lmn_het_sgseq %>%
  create_bed_format() %>%
  delta_psi_calculation_het() %>%
  subset(select = c(1:3, 39, 41, 4, 23, 14, 42:44, 5:13, 15:22, 24:38, 40))

q331k_20m_fc_hom_sgseq_mod <- q331k_20m_fc_hom_sgseq %>%
  create_bed_format() %>%
  delta_psi_calculation_hom %>%
  subset(select = c(1:3, 57, 59, 4, 32, 14, 60:62, 5:13, 15:31, 33:56, 58))

q331k_20m_fc_het_sgseq_mod <- q331k_20m_fC_het_sgseq %>%
  create_bed_format() %>%
  delta_psi_calculation_het() %>%
  subset(select = c(1:3, 57, 59, 4, 32, 14, 60:62, 5:13, 15:31, 33:56, 58))

write.table(q331k_5m_fc_hom_sgseq_mod, "sgseq_q331k_5m_frontal_cortex_hom.tab", sep = '\t', row.names = FALSE, quote = FALSE)
write.table(q331k_5m_fc_het_sgseq_mod, "sgseq_q331k_5m_frontal_cortex_het.tab", sep = '\t', row.names = FALSE, quote = FALSE)
write.table(q331k_5m_lmn_hom_sgseq_mod, "sgseq_q331k_5m_lower_motor_neuron_hom.tab", sep = '\t', row.names = FALSE, quote = FALSE)
write.table(q331k_5m_lmn_het_sgseq_mod, "sgseq_q331k_5m_lower_motor_neuron_het.tab", sep = '\t', row.names = FALSE, quote = FALSE)
write.table(q331k_20m_fc_hom_sgseq_mod, "sgseq_q331k_20m_frontal_cortex_hom.tab", sep = '\t', row.names = FALSE, quote = FALSE)
write.table(q331k_20m_fc_het_sgseq_mod, "sgseq_q331k_20m_frontal_cortex_het.tab", sep = '\t', row.names = FALSE, quote = FALSE)
