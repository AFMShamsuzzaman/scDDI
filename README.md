# scDDI
Single Cell Drop-out Detection and Imputation

##Pre-requisites

> R version  4.0.0 or higher
> Python 3.7

## Install
library("devtools")
install_github("AFMShamsuzzaman/scDDI")
Check the installation:
library(scDDI)

## Load required packages

R packages

    library(SingleCellExperiment)
     library(Linnorm)
     library(foreach)
     library(doParallel)
     library(scDoc)

Python Packages: 
 
    pip install scanpy
    pip install leidenalg


## Usage of the R functions

Preprocess raw data using DataProcessing.R function

    Biase_data<- readRDS("Data/darmanis.rds")
    data <- assay(Biase_data) 
    annotation <- Biase_data[[1]] #already factor type class
    colnames(data) <- annotation
    darmanis_process = normalized_data(data)

Now, calculate dropout probabilty matrix and cell-to-cell similarity matrix as follows :

     offsets_darmanis <- as.numeric(log(colSums(darmanis_process)))
     dp_darmanis <- prob.dropout(input = darmanis_process, offsets = offsets_darmanis, mcore = 6)  ## dp_darmanis is the dropout probability matrix
     sim_darmanis <- sim.calc(log2(count_darmanis+1), dp_darmanis)                       ## sim_darmanis is the cell-to-cell similarity matrix

Then, save the processed dataset, dropout probability matrix and cell-to-cell similarity matrix into csv file fromat. 

    write.csv(darmanis_process,"/home/zaman/New2/darmanis_process.csv",row.names = FALSE)
    write.csv(dp_darmanis,"/home/zaman/New2/dp_darmanis.csv",row.names = FALSE)
    write.csv(sim_darmanis,"/home/zaman/New2/sim_darmanis.csv",row.names = FALSE)
    
## Usage of the Python functions 

Now, Run the following python code to impute the given dataset as follows:

    python3 imputation_scDDI.py

    
Then, to validate the results, we utilized clustering performance metrics, specifically the Adjusted Rand Index (ARI). We compared the ARI value for both unimputed dataset and as well as imputed dataset using scDDI.


    clustering_imputed.ipynb
    clustering_unimputed.ipynb


Now,We visualized the clustering outcomes and analyzed the clusters to identify marker genes.

    darmanis_marker.ipynb
