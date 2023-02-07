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

     library(scDoc)
     library(foreach)
     library(doParallel)

Python Packages: 
 
    pip install scanpy
    pip install leidenalg


## Usage of the R functions

import the datatset
goolam_process <- read.csv("~/Data/yan_process.csv", header=FALSE)

**Run the following code in Rstudio**
offsets_goolam <- as.numeric(log(colSums(goolam_process)))

count_goolam <- goolam_process[rowSums(goolam_process > 5) > 4, ]

dp_goolam <- prob.dropout(input = count_goolam, offsets = offsets_goolam, mcore = 3)

dp_goolam[is.na(dp_goolam)] <- 0

sim_goolam <- sim.calc(log2(count_goolam+1), dp_goolam)

**Save the output into csv file**

write.csv(count_goolam,"/home/zaman/count_goolam.csv",row.names = FALSE)

write.csv(dp_goolam,"/home/zaman/dp_goolam.csv",row.names = FALSE)

write.csv(sim_goolam,"/home/zaman/sim_goolam.csv",row.names = FALSE)

**Import the above csv files into Jupyter Notebook**

Run the the following ipynb file

imputation_goolam.ipynb
clustering_goolam.ipynb
original_goolam.ipynb
