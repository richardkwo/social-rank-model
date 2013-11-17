library(ggplot2)
coordinatewise.grad <- function(i, G, R, Beta, Lambda) {
    link.vec <- G[i,]
    node.vec <- 1:(G$gal$n)
    kernel.vec <- exp(Beta * (R[i] - R[node.vec])^2)
    middle.part <- (link.vec + (link.vec - 1) * (1 / (kernel.vec -1))) * (R[i] - R[node.vec])
    # use na.rm to remove i-i link term
    grad <- sum(-2 * Beta * sum(middle.part, na.rm=T) - Lambda * R[i])
    return (grad)
}

Err.Plot <- function(original.vec, estimate.vec) {
    i.vec <- 1:length(original.vec)
    reorder.vec <- order(original.vec)
    draw.df <- data.frame(orig=original.vec[reorder.vec], est=estimate.vec[reorder.vec], index=i.vec)
    fig <- ggplot(draw.df) + geom_point(aes(x=index, y=orig, color="true")) + 
        geom_point(aes(x=index, y=est, color="estimate")) + 
        geom_linerange(aes(x=index, ymin=orig, ymax=est), linetype="longdash")
    print(fig)
}

Beta = 8.8
Lambda = 9
N <- G$gal$n
R.estimate <- runif(N, -3, 3)
stepsize <- 0.001


for (k in 1:50000) {
    node.pick.vec <- sample(1:N, size=N, replace=FALSE)
    R.estimate.old <- R.estimate
    for (i in node.pick.vec) {
        R.estimate[i] <- R.estimate[i] + stepsize * coordinatewise.grad(i, G, R.estimate, Beta, Lambda)
    }

    # err.vec <- abs(R.estimate - nodelist.df$R)
    change.vec <- abs(R.estimate - R.estimate.old)
    if (k %% 50 ==0) {
    print(paste("--",k,"--"))
    print(summary(change.vec))
    print(paste("ll=", log.likelihood(G, R.estimate, Beta)))
    }
}

