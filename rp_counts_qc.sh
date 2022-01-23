#Rscript -e "rmarkdown::render('rp_normalise_counts.Rmd', \
#params=list(counts_matrix = '/scratch/users/k2142172/outputs/ramsey_s303/gene_expression/STAR/ramsey_s303_gene_counts.tab', \
#drop_samples=TRUE, dropped_samples='Positive.control_S37 Negative.control_S38 Undetermined_S0 NAT.4_S4'))"

#fl=/scratch/users/k2142172/scripts/pipeline/rp_normalise_counts.Rmd

# rp_normalise_counts.Rmd
markdown_file=$1

# gene_counts.tab
counts_matrix=$2

# TRUE/FALSE - default FALSE
drop_samples=$3

# 'sample1 sample2 sample3' - default ''
dropped_samples=$4

Rscript -e "rmarkdown::render('$markdown_file', output_file='/scratch/users/k2142172/tests/test.html', params=list(counts_matrix = '$2', drop_samples='$3', dropped_samples='$4'))"


