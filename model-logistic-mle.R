library(compiler)
enableJIT(1)

library(optimx)

R.estimate <- rnorm(N, 0, 3)
H.estimate <- rnorm(N, 0, 1)

pars.estimate <- c(R.estimate, H.estimate)

mle.optim.results <- optimx(par=pars.estimate, fn=log.likelihood.logistic.wrapped, 
                            gr=gradient.wrapped, 
                            hess=NULL, method=c("CG"), itnmax=100, 
                            control = list(trace=1, save.failures=TRUE, maximize=TRUE, REPORT=1), 
                            A=A)

R.estimate <- as.numeric(mle.optim.results[1, 1:N])
H.estimate <- as.numeric(mle.optim.results[1, (N+1):(2*N)])
pars.estimate <- c(R.estimate, H.estimate)


imagefile.name <- paste("logistic-mle-",Sys.Date(),".RData",sep="")
save.image(paste("rdata/", imagefile.name, sep=""))

print(paste("Optim over with ll=", log.likelihood.logistic(R.estimate, H.estimate, A)))
print(paste("Image saved to", imagefile.name))


