# load real data before laoding edge removal configuration
source("loadRealData.R")
A.original <- A

# load model configuration
source("model-logistic-directed.R")


removedEdgesDir = "data/celegansneural/edge-removal/"
batches = c("b1")


for (t in 1:length(batches)) {
    print("", quote=F)
    print(paste("** batch", batches[t], "**"), quote=F)
    
    this.batch = batches[t]
    removed.edges <- read.table(paste(removedEdgesDir, "removed-edges-", this.batch, ".txt", sep=""))
    
    # restore
    A <- A.original
    for (j in 1:nrow(removed.edges)) {
        # edge removal
        # directly operates on A
        A[removed.edges[j,1], removed.edges[j,2]] <- 0
    }
    print(sprintf("%d edges removed (%.2f)", nrow(removed.edges), nrow(removed.edges)/nrow(edgelist.df)), quote=F)
    
    ## estimate
    source("model-logistic-mle.R")
    estimate.df <- data.frame(node=1:N, R=R.estimate, H=H.estimate)
    estimate.save.filename = paste(removedEdgesDir, "estimate-", this.batch, ".txt", sep="")
    write.table(estimate.df, estimate.save.filename, row.names=FALSE)
    print(paste("Estimation saved to", estimate.save.filename))
}