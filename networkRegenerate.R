library(ggplot2)

N <- length(R.estimate)
regen.edgelist <- NULL
for (i in 1:N) {
    for (j in 1:N) {
        if (j!=i) {
            # i -> j
            r <- 1/(1+exp(-(R.estimate[j] - R.estimate[i] - H.estimate[i])))
            u <- rbinom(n=1, 1, r)
            if (u==1) {
                regen.edgelist <- rbind(regen.edgelist, c(i, j))
            }
        }
    }
}
regen.edgelist <- as.data.frame(regen.edgelist)
print(paste("Network regenerated with estimated parameters."))
print(paste("M =", nrow(regen.edgelist), "compared to E[M] =", expected.number.of.edges(R.estimate, H.estimate)))

# regen.filename <- paste("RegeneratedData/", network.name, "-edgelist-regenerated.txt", sep="")
# write.table(regen.edgelist, regen.filename, row.names=FALSE, col.names=FALSE)

# plotting degree distributions
indegree.real.df <- get.degree.frequencies(edgelist.df$V2)
outdegree.real.df <- get.degree.frequencies(edgelist.df$V1)
indegree.regen.df <- get.degree.frequencies(regen.edgelist$V2)
outdegree.regen.df <- get.degree.frequencies(regen.edgelist$V1)

fig1 <- ggplot(indegree.real.df) + 
    geom_line(aes(x=degree, y=freq, colour="Real"), data=indegree.real.df) + geom_point(aes(x=degree, y=freq, colour="Real"), data=indegree.real.df) + 
    geom_line(aes(x=degree, y=freq, colour="Generated"), data=indegree.regen.df) + geom_point(aes(x=degree, y=freq, colour="Generated"), data=indegree.regen.df) + 
    scale_y_log10() + scale_x_log10() + xlab("in-degree") + ylab("frequency") + 
    theme(legend.title=element_blank())
print(fig1) 

fig2 <- ggplot(indegree.real.df) + 
    geom_line(aes(x=degree, y=freq, colour="Real"), data=outdegree.real.df) + geom_point(aes(x=degree, y=freq, colour="Real"), data=outdegree.real.df) + 
    geom_line(aes(x=degree, y=freq, colour="Generated"), data=outdegree.regen.df) + geom_point(aes(x=degree, y=freq, colour="Generated"), data=outdegree.regen.df) + 
    scale_y_log10() + scale_x_log10() + xlab("out-degree") + ylab("frequency") + 
    theme(legend.title=element_blank())
print(fig2) 



    
    



