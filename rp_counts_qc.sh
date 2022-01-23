Rscript -e "rmarkdown::render('rp_normalise_counts.Rmd', \
params=list(counts_matrix = '/scratch/users/k2142172/outputs/ramsey_s303/gene_expression/STAR/ramsey_s303_gene_counts.tab', \
 sample_table= '/scratch/users/k2142172/outputs/ramsey_s303/ramsey_s303_sample_table.tab'))"
