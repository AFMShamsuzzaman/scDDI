library(splatter)
library(SingleCellExperiment)

# Step 1: Simulate data WITHOUT dropout, but with group structure and DE genes
params <- newSplatParams()
params <- setParams(params,
                    group.prob = c(0.6, 0.3, 0.1),  # Cell group proportions
                    de.prob = c(0.3, 0.5, 0.8),     # DE probability per group
                    de.facLoc = 0.4,                # Mean log fold change
                    de.facScale = 0.8,              # Variability in log fold change
                    batchCells = 200,               # Number of cells
                    nGenes = 5000,                  # Number of genes
                    dropout.type = "none"           # Disable built-in dropout
)

sim <- splatSimulate(params, verbose = FALSE, seed = 123)
true_counts <- assay(sim, "counts")  # Get the ground truth counts

# Step 2: Function to apply manual dropout
add_dropout <- function(count_matrix, rate, seed = 1) {
  set.seed(seed)
  mask <- matrix(runif(length(count_matrix)) < rate,
                 nrow = nrow(count_matrix),
                 ncol = ncol(count_matrix))
  dropped <- count_matrix
  dropped[mask & count_matrix > 0] <- 0
  return(dropped)
}

# Step 3: Desired dropout rates
dropout_rates <- c(0.4, 0.5, 0.6, 0.7, 0.8)
names(dropout_rates) <- paste0("dropout", dropout_rates * 100)

# Step 4: Apply dropout and save datasets
for (name in names(dropout_rates)) {
  rate <- dropout_rates[name]
  dropped_counts <- add_dropout(true_counts, rate, seed = 123)
  
  # Create new SingleCellExperiment object
  sim_dropout <- sim
  assay(sim_dropout, "counts") <- dropped_counts
  assay(sim_dropout, "TrueCounts") <- true_counts  # Store original
  
  # Compute actual dropout rate
  dropout_events <- (dropped_counts == 0) & (true_counts > 0)
  observed_rate <- sum(dropout_events) / sum(true_counts > 0)
  
  cat(sprintf("Dataset %s - Target: %.0f%%, Observed: %.2f%%\n",
              name, rate * 100, observed_rate * 100))
  
  # Save to file
  saveRDS(sim_dropout, paste0(name, "_sim.rds"))
}
