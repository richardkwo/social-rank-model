library(optimx)

R.estimate <- rnorm(N, 0, 3)
H.estimate <- rnorm(N, 0, 1)

pars.estimate <- c(R.estimate, H.estimate)

mle.optim.results <- optimx(par=pars.estimate, fn=log.likelihood.logistic.wrapped, 
                            gr=gradient.wrapped, 
                            hess=NULL, method=c("CG"), itnmax=10, 
                            control = list(trace=1, save.failures=TRUE, maximize=TRUE, REPORT=1), 
                            A=A)

