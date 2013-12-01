library(ggplot2)
library(reshape)

auc.result.filename = "data/celegansneural/edge-removal/auc-result.txt"
auc.result.df <- read.table(auc.result.filename, header=TRUE, stringsAsFactors=FALSE)
auc.result.df$fraction.observed.edges = 1 - auc.result.df$fraction.removed.edges


auc.result.df.melted <- melt.data.frame(auc.result.df, 
                                        id=c("batch", "number.removed.egdes", "fraction.removed.edges", "fraction.observed.edges"), 
                                        variable_name="method")

fig <- ggplot(auc.result.df.melted, aes(x=fraction.observed.edges, y=value)) + 
    geom_point(aes(color=method)) + 
    geom_line(aes(color=method)) + 
    geom_hline(yintercept=0.5, linetype="dashed", aes(color="pure chance")) + 
    xlab("Fraction of observed edges") + ylab("AUC")
print(fig)