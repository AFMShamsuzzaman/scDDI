# Assume 'original_matrix' is your real scRNA-seq matrix (genes x cells)
data <- read.csv("~/Review/darmanis_process.csv", header=FALSE)

set.seed(42)
# Step 1: Find nonzero indices
nonzero_indices <- which(data > 0, arr.ind = TRUE)

# Step 2: Sample 10% to mask
n_mask <- floor(nrow(nonzero_indices) * 0.05)
mask_idx <- nonzero_indices[sample(1:nrow(nonzero_indices), n_mask, replace = FALSE), ]

# Step 3: Mask values
masked_data <- data
true_vals <- numeric(n_mask)

for (k in 1:n_mask) {
  i <- mask_idx[k, 1]
  j <- mask_idx[k, 2]
  true_vals[k] <- data[i, j]
  masked_data[i, j] <- 0
}

write.csv(masked_data,"/home/zaman/Review/darmanis_mask.csv",row.names = FALSE)
write.csv(masked_data,"/home/zaman/Review/pbmc_mask1.csv")

# Replace this with your imputation method
# For example, if you're using scDDI:
# imputed_matrix <- scDDI(masked_data)

#imputed_matrix<-as.matrix(scimpute_count)
data_imputed <- read.csv("~/Review/darmanis_mask_deepimpute.csv", header=FALSE)
imputed_matrix<-data_imputed
true_vals<-darmanis_mask
# Let's assume 'imputed_matrix' is now available


library(Metrics)       # for rmse, mae
library(psych)         # for correlation
library(Hmisc)         # for rcorr (alternative)

# Get imputed values at masked locations
imputed_vals <- numeric(n_mask)
for (k in 1:n_mask) {
  i <- mask_idx[k, 1]
  j <- mask_idx[k, 2]
  imputed_vals[k] <- imputed_matrix[i, j]
}

# Metrics
rmse_val <- rmse(true_vals, imputed_vals)
mae_val <- mae(true_vals, imputed_vals)

#Report
cat(sprintf("RMSE: %.4f\n", rmse_val))
cat(sprintf("MAE: %.4f\n", mae_val))


