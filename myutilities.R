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