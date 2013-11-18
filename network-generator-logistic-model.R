library(network)

N.simu <- 50
R.simu <- rgamma(N.simu, shape=0.5, rate=2)
H.simu <- rnorm(N.simu, mean=4, sd=4)

node.simu.df <- data.frame(node=1:N.simu, R=R.simu, H=H.simu)
edge.1 <- NULL
edge.2 <- NULL
A.simu <- diag(rep(0, N.simu))

# construct network
for (i in 1:N.simu) {
    for (j in 1:N.simu) {
        if (j==i) next
        u <- rbinom(n=1, size=1, 1/(1+exp(- (R.simu[j] - R.simu[i] - H.simu[i]))))
        if (u==1) {
            A.simu[i,j] <- 1
            edge.1 <- c(edge.1, i)
            edge.2 <- c(edge.2, j)
        }
    }
}
edge.simu.df <- data.frame(edge.1, edge.2)

G.simu <- network(A.simu, directed=TRUE)
print(G.simu)

