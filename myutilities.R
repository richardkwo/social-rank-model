library(ggplot2)

## err plot
err.plot <- function(true.vec, estimate.vec) {
    draw.df <- data.frame(true.vec, estimate.vec)
    draw.df$index <- 1:nrow(draw.df)
    rmse <- sqrt(sum((true.vec-estimate.vec)^2)/nrow(draw.df))
    fig <- ggplot(draw.df) + geom_linerange(aes(x=index, ymin=estimate.vec, ymax=true.vec)) + 
        geom_point(aes(x=index, y=true.vec, colour="True")) + 
        geom_point(aes(x=index, y=estimate.vec, colour="Estimate"))
    print(fig)
    print(paste("rmse=",rmse), quote=FALSE)
}

### degree distribution from one column of edgelist
get.degree.frequencies <- function(nodecol) {
    degree.seq <- as.numeric(table(nodecol))
    degree.seq <- degree.seq[order(degree.seq)]
    degree.seq.tab <- table(degree.seq)
    degree.vec <- as.numeric(names(degree.seq.tab))
    freq.vec <- as.numeric(degree.seq.tab)
    freq.vec <- freq.vec / sum(freq.vec)
    result.df <- data.frame(degree=degree.vec, freq=freq.vec)
    return (result.df)
} 
