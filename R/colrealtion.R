library(SingleCellExperiment)
library(Matrix)
library(stats)
true_vals<-sim   # sim is the simulated data with known ground truth

# Replace this with your imputation method
# For example, if you're using scDDI:
# imputed_vals <- scDDI(simulated data)
imputed_vals<-data_imputed
# Flatten the matrices into vectors
true_vec <- as.vector(as.matrix(true_vals))
imputed_vec <- as.vector(as.matrix(imputed_vals))

# Compute correlations
pearson_corr <- cor(true_vec, imputed_vec, method = "pearson", use = "complete.obs")
spearman_corr <- cor(true_vec, imputed_vec, method = "spearman", use = "complete.obs")

# Print
cat(sprintf("Pearson: %.4f\n", pearson_corr))
cat(sprintf("Spearman: %.4f\n", spearman_corr))

