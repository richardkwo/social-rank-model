library(network)
# 
# 
# ## ==== celegans neural 
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
# ## ====
# 
# ## ==== football
# edgelist.df <- read.table("data/football/football-edgelist.txt")
# nodelist.df <- read.table("data/football//football-nodelist.txt", header=T)
# network.name <- "Football"
# N <- max(nodelist.df$node)
# G <- network(edgelist.df, directed=TRUE, loops=FALSE, matrix.type="edgelist")
# A <- as.sociomatrix(G)
# indegree.vec <- apply(A, 2, sum)
# outdegree.vec <- apply(A, 1, sum)
# print(G)
# print(paste("Network loaded:", network.name))
# ## ====

# ## ==== logisitc simu 1 (100 nodes)
# edgelist.df <- read.table("data/logistic-simu/simu1-edgelist.txt")
# nodelist.df <- read.table("data/logistic-simu/simu1-nodelist.txt", header=T)
# network.name <- "logistic-simu-1"
# N <- max(nodelist.df$node)
# G <- network(edgelist.df, directed=TRUE, loops=FALSE, matrix.type="edgelist")
# A <- as.sociomatrix(G)
# indegree.vec <- apply(A, 2, sum)
# outdegree.vec <- apply(A, 1, sum)
# print(G)
# print(paste("Network loaded:", network.name))
# ## ====

## ==== logisitc simu 2 (500 nodes)
# edgelist.df <- read.table("data/logistic-simu/simu2-edgelist.txt")
# nodelist.df <- read.table("data/logistic-simu/simu2-nodelist.txt", header=T)
# network.name <- "logistic-simu-2"
# N <- max(nodelist.df$node)
# G <- network(edgelist.df, directed=TRUE, loops=FALSE, matrix.type="edgelist")
# A <- as.sociomatrix(G)
# indegree.vec <- apply(A, 2, sum)
# outdegree.vec <- apply(A, 1, sum)
# print(G)
# print(paste("Network loaded:", network.name))
## ====

# # ==== pol blogs
# edgelist.df <- read.table("data/polblogs/polblogs-edgelist.txt")
# nodelist.df <- read.table("data/polblogs/polblogs-nodelist.txt", header=T)
# network.name <- "polblogs"
# N <- max(nodelist.df$node)
# G <- network(edgelist.df, directed=TRUE, loops=FALSE, matrix.type="edgelist")
# A <- as.sociomatrix(G)
# indegree.vec <- apply(A, 2, sum)
# outdegree.vec <- apply(A, 1, sum)
# print(G)
# print(paste("Network loaded:", network.name))
# # ====

