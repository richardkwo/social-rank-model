library(compiler)
enableJIT(1)

library(optimx)

R.estimate <- rnorm(N, 0, 3)
H.estimate <- rnorm(N, 0, 1)

pars.estimate <- c(R.estimate, H.estimate)

Err.Plot <- function(original.vec, estimate.vec) {
    i.vec <- 1:length(original.vec)
    reorder.vec <- order(original.vec)
    draw.df <- data.frame(orig=original.vec[reorder.vec], est=estimate.vec[reorder.vec], index=i.vec)
    fig <- ggplot(draw.df) + geom_point(aes(x=index, y=orig, color="true")) + 
        geom_point(aes(x=index, y=est, color="estimate")) + 
        geom_linerange(aes(x=index, ymin=orig, ymax=est), linetype="longdash")
    return(fig)
}

mle.optim.results <- optimx(par=pars.estimate, fn=log.likelihood.logistic.wrapped, 
                            gr=gradient.wrapped, 
                            hess=NULL, method=c("CG"), itnmax=1000, 
                            control = list(trace=1, save.failures=TRUE, maximize=TRUE, REPORT=1), 
                            A=A)

R.estimate <- as.numeric(mle.optim.results[1, 1:N])
H.estimate <- as.numeric(mle.optim.results[1, (N+1):(2*N)])
pars.estimate <- c(R.estimate, H.estimate)


imagefile.name <- paste("logistic-mle-",network.name, "-", Sys.Date(),".RData",sep="")
save.image(paste("rdata/", imagefile.name, sep=""))

print(paste("Optim over with ll=", log.likelihood.logistic(R.estimate, H.estimate, A)))
print(paste("Image saved to", imagefile.name))


