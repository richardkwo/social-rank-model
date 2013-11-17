library(optimx)

R.estimate <- rnorm(N, 0, 3)
H.estimate <- rnorm(N, 0, 1)

pars.estimate <- c(R.estimate, H.estimate)

mle.optim.results <- optimx(par=pars.estimate, fn=log.likelihood.logistic.wrapped, 
                            gr=gradient.wrapped, 
                            hess=NULL, method=c("BFGS", "CG"), itnmax=100, 
                            control = list(trace=1, save.failures=TRUE, maximize=TRUE, REPORT=1), 
                            A=A)

imagefile.name <- paste("logistic-mle-",Sys.Date(),".RData",sep="")
save.image(paste("rdata/", imagefile.name, sep=""))
