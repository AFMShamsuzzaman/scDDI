# Load required libraries
library(SingleCellExperiment)
library(Matrix)

# Example: Load your simulated dataset (already a SingleCellExperiment object)
s1 <- readRDS("dropout40_sim.rds")

dp <- prob.dropout(input = observed_counts, offsets = offsets, mcore = 6)
dp[is.na(dp)] <- 0

# Get true counts and observed counts
true_counts <- assays(s1)$TrueCounts
observed_counts <- counts(s1)

# 1. Define ground truth dropout matrix (1 = dropout happened, 0 = not)
true_dropout <- (true_counts > 0) & (observed_counts == 0)

# 2. Define predicted dropout matrix (use your predicted dropout probability matrix and threshold)
# Example: Assume pred_dropout_prob is a matrix with same dimensions
# Threshold = 0.5


predicted_dropout <- dp > 0.3

# 3. Flatten matrices to vectors
true_vec <- as.vector(true_dropout)
pred_vec <- as.vector(predicted_dropout)

# 4. Compute precision, recall, F1-score
TP <- sum(true_vec & pred_vec)
FP <- sum(!true_vec & pred_vec)
FN <- sum(true_vec & !pred_vec)

precision <- TP / (TP + FP)
recall <- TP / (TP + FN)
f1_score <- 2 * precision * recall / (precision + recall)

# 5. Output metrics
cat("Precision:", round(precision, 3), "\n")
cat("Recall:", round(recall, 3), "\n")
cat("F1 Score:", round(f1_score, 3), "\n")
