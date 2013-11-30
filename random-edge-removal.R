# load real data before laoding edge removal configuration
source("loadRealData.R")
M <- nrow(edgelist.df)

removedEdgesDir = "data/celegansneural/edge-removal/"
removal.fractions <- c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9)
removal.numbers <- as.integer(M * removal.fractions)
total.batches <- length(removal.fractions)
batches <- sapply(1:total.batches, function(x) paste("b",x,sep=""))
batch.profile.df <- data.frame(batches=batches, removal.numbers=removal.numbers, 
                            removal.fractions=removal.fractions)

write.table(batch.profile.df, paste(removedEdgesDir, "batch-profile.txt", sep=""), row.names=FALSE)
print("", quote=F)
print(batch.profile.df, quote=F)

for (t in 1:total.batches) {
    edge.removal.df <- edgelist.df[sample(1:nrow(edgelist.df), removal.numbers[t]), ]
    removal.file.name <- paste(removedEdgesDir, "removed-edges-", batches[t], ".txt", sep="")
    write.table(edge.removal.df, removal.file.name, row.names=FALSE, col.names=FALSE)
    print(paste("Saved to", removal.file.name))
}

