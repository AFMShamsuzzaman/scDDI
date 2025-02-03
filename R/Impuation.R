library(scDoc)
library(readr)
data <- read_csv("~/data/darmanis_process.csv")
offsets_data <- as.numeric(log(colSums(data)))
dp<- prob.dropout(input = data, offsets = offsets_data, mcore = 8)
dp[is.na(dp)] <- 0
sim <- sim.calc(log2(data+1), dp)
sim[is.na(sim)] <- 0
impute_data <- impute.knn(input = data, dmat = dp, sim.mat = sim, k = 6, sim.cut = 1e-4)
imp <- impute_data[["output.imp"]]
write.csv(dp,"~/data/dp_darmanis.csv",row.names = FALSE)
write.csv(sim,"~/data/sim_darmanis.csv",row.names = FALSE)
write.csv(imp,"~/data/imp_darmanis.csv",row.names = FALSE)
