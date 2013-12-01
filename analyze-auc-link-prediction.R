library(ggplot2)
library(reshape)

# auc.result.filename = "data/twitter/edge-removal/auc-result.txt"
auc.result.filename = "data/polblogs/edge-removal/auc-result.txt"
auc.result.df <- read.table(auc.result.filename, header=TRUE, stringsAsFactors=FALSE)
auc.result.df$fraction.observed.edges = 1 - auc.result.df$fraction.removed.edges


auc.result.df.melted <- melt.data.frame(auc.result.df, 
                                        id=c("batch", "number.removed.egdes", "fraction.removed.edges", "fraction.observed.edges"), 
                                        variable_name="method")

fig <- ggplot(auc.result.df.melted, aes(x=fraction.removed.edges, y=value)) + 
    geom_point(aes(color=method)) + 
    geom_line(aes(color=method)) + 
    geom_hline(yintercept=0.5, linetype="dashed", aes(color="pure chance")) + 
    xlab("Fraction of removed edges") + ylab("AUC") + 
    scale_color_discrete(name="Method", 
                         breaks=c("CommonNeighbor", "CommonSuc", "CommonPre", 
                                  "Jaccard", "ProdOutDeg", "ProdInDeg", 
                                  "ProdDeg", "ShortestPath", "Model"), 
                         labels=c("Common Neighbors", "Common successors", "Common predecessors", 
                                  "Jaccard", "Out-degree product", "In-degree product", 
                                  "Degree product", "Shortest path", "Model")) + 
    ggtitle("Link prediction on Blogs")
print(fig)