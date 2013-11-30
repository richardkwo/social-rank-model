library(doMC)
library(foreach)
library(compiler)
enableJIT(1)
library(optimx)

registerDoMC()

# load real data before laoding edge removal configuration
source("loadRealData.R")

# load model configuration
source("model-logistic-directed.R")
print("Model spec loaded", quote=F)

# parameter passing wrapped in function to prevent conflicts in parallel
do.estimation <- function(A, N, removedEdgesDir, this.batch, itermax=2000) {
    
    print(paste("** batch", this.batch, "**"), quote=F)
    removed.edges <- read.table(paste(removedEdgesDir, "removed-edges-", this.batch, ".txt", sep=""))
        
    for (j in 1:nrow(removed.edges)) {
        # edge removal
        # directly operates on A
        A[removed.edges[j,1], removed.edges[j,2]] <- 0
    }
    print(sprintf("%d edges removed (%.2f)", nrow(removed.edges), nrow(removed.edges)/nrow(edgelist.df)), quote=F)
    
    R.estimate <- rnorm(N, 0, 3)
    H.estimate <- rnorm(N, 0, 1)
    pars.estimate <- c(R.estimate, H.estimate)
    
    # set regularization
    regularization.coeff=0.01
    
    print(paste("Regularzation coeff =", regularization.coeff), quote=FALSE)
    print("Regression on the way...", quote=FALSE)
    
    mle.optim.results <- optimx(par=pars.estimate, fn=log.likelihood.logistic.wrapped, 
                                gr=gradient.wrapped, 
                                hess=NULL, method=c("CG"), itnmax=itermax, 
                                control = list(trace=1, save.failures=TRUE, maximize=TRUE, REPORT=1), 
                                A=A, regularization.coeff=regularization.coeff)
    
    R.estimate <- as.numeric(mle.optim.results[1, 1:N])
    H.estimate <- as.numeric(mle.optim.results[1, (N+1):(2*N)])
    
    print(paste("Optim over with ll=", log.likelihood.logistic(R.estimate, H.estimate, A, regularization.coeff)))
    
    ## write
    estimate.df <- data.frame(node=1:N, R=R.estimate, H=H.estimate)
    estimate.save.filename = paste(removedEdgesDir, "estimate-", this.batch, ".txt", sep="")
    write.table(estimate.df, estimate.save.filename, row.names=FALSE)
    print(paste("Estimation saved to", estimate.save.filename))
    
}

removedEdgesDir = "data/celegansneural/edge-removal/"
batch.profile <- read.table(paste(removedEdgesDir, "batch-profile.txt", sep=""), header=TRUE, 
                            stringsAsFactors=F)
batches <- batch.profile$batches
batches <- c("b1")


foreach(t=1:length(batches), .combine="c", .packages="optimx") %dopar% 
    do.estimation(A, N, removedEdgesDir, batches[t], itermax=2000)