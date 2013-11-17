library(network)

edgelist.df <- read.table("data/pareto1-edgelist.txt")
nodelist.df <- read.table("data/pareto1-nodelist.txt", col.names=c("node","R"))
N <- max(nodelist.df$node)

G <- network(edgelist.df, directed=F, loops=T, matrix.type="edgelist")

Phi <- function(i, j, R, Beta) {
    return (exp(- Beta * (R[i] - R[j])^2 ))
}

Expected.Number.of.Edges <- function(G, R, Beta) {
    ene <- 0
    for (i in 1:(G$gal$n-1)) {
        for (j in (i+1):G$gal$n) {
            ene <- ene + Phi(i, j, R, Beta)
        }
    }
    return (ene)
}

log.likelihood <- function(G, R, Beta) {
    ll <- 0
    for (i in 1:(G$gal$n-1)) {
        i.adj.vec <- G[i,]
        for (j in (i+1):G$gal$n) {
            if (i.adj.vec[j]==1) {
                ll <- ll - Beta * (R[i]-R[j])^2
            } else {
                ll <- ll + log(1 - exp(-Beta * (R[i] - R[j])^2))
            }
        }
    }
    return (ll)
}

derivative.R <- function(i, G, R, Beta) {
    link.vec <- G[i,]
    part.1 <- -sum(R[i] - R[link.vec==1])
    node.vec <- 1:(G$gal$n)
    phi.no.link <- Phi(i, node.vec[link.vec==0], R, Beta)
    # remove i-i link by rm.na
    part.2 <- sum(phi.no.link/(1-phi.no.link) * (R[i] - R[link.vec==0]), na.rm=T)
    return ((part.1 + part.2) * 2 * Beta)
}

Beta = 15
R.mle <- runif(n=N, 0, 1)
step.size <- 1
err.threshold <- 1
err <- 10
node.vec <- 1:N



