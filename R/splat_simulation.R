library(splatter)
library(SingleCellExperiment)  
dataset1 <- splatSimulate(
    group.prob = c(0.8, 0.1, 0.1), # Cell group proportions
    method = 'groups',             # Simulation method 
    batchCells = 500,            # Total number of cells
    de.prob = c(0.6, 0.2, 0.2), # Proportion of DE genes for each group
    de.facLoc = 0.4,        # Mean log fold change
    de.facScale = 0.8,     # Variability in log fold change
    nGenes = 5000,         # Total number of genes
    out.prob = 0,          # Proportion of outlier genes
    verbose = FALSE        # Suppress detailed output messages
)
#Extract observed and true (pre-dropout) count matrices
observed_counts <- counts(dataset1)
true_counts <- assays(dataset1)$TrueCounts
