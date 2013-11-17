library(network)

# edgelist.df <- read.table("data/football/football-edgelist.txt")
# nodelist.df <- read.table("data/football/football-nodelist.txt", header=T)
# N <- max(nodelist.df$node)
# G <- network(edgelist.df, directed=F, loops=T, matrix.type="edgelist")
# 
# print(G)

## ==== celegans neural 
edgelist.df <- read.table("data/celegansneural/celegansneural-directed-edgelist.txt")
nodelist.df <- read.table("data/celegansneural/celegansneural-directed-nodelist.txt", header=T)
network.name <- "Celegans-neural"
N <- max(nodelist.df$node)
G <- network(edgelist.df, directed=TRUE, loops=FALSE, matrix.type="edgelist")
A <- as.sociomatrix(G)
indegree.vec <- apply(A, 2, sum)
outdegree.vec <- apply(A, 1, sum)
print(G)
print(paste("Network loaded:", network.name))
## ====




