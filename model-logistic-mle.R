library(compiler)
enableJIT(1)

library(optimx)

R.estimate <- rnorm(N, 0, 3)
H.estimate <- rnorm(N, 0, 1)

pars.estimate <- c(R.estimate, H.estimate)

# set regularization
regularization.coeff=0.01

print(paste("Network size =", N), quote=FALSE)
print(paste("Regularzation coeff =", regularization.coeff), quote=FALSE)
print("Regression on the way...", quote=FALSE)


mle.optim.results <- optimx(par=pars.estimate, fn=log.likelihood.logistic.wrapped, 
                            gr=gradient.wrapped, 
                            hess=NULL, method=c("CG"), itnmax=2000, 
                            control = list(trace=1, save.failures=TRUE, maximize=TRUE, REPORT=1), 
                            A=A, regularization.coeff=regularization.coeff)

R.estimate <- as.numeric(mle.optim.results[1, 1:N])
H.estimate <- as.numeric(mle.optim.results[1, (N+1):(2*N)])
pars.estimate <- c(R.estimate, H.estimate)


# imagefile.name <- paste("logistic-mle-",network.name, "-", Sys.Date(),".RData",sep="")
# save.image(paste("rdata/", imagefile.name, sep=""))

print(paste("Optim over with ll=", log.likelihood.logistic(R.estimate, H.estimate, A, regularization.coeff)))
# print(paste("Image saved to", imagefile.name))


