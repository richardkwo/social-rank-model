library(network)

log.likelihood.outlink.for.node <- function(i, R, H, A) {
    out.links <- (A[i,]==1)
    out.nonlinks <- (A[i,]==0)
    # exclude i-i
    out.nonlinks[i] <- FALSE
    log.part1 <- log(1/(1+exp(-(R[out.links] -R[i] - H[i]))))
    log.part2 <- log(1 - 1/(1 + exp(-(R[out.nonlinks] - R[i] - H[i]))))
    
    
    return(sum(log.part1) + sum(log.part2))
}

log.likelihood.logistic <- function(R, H, A, regularization.coeff=0.01) {
    N <- nrow(A)
    node.vec <- 1:N
    ll <- 0
    for (i in 1:N) {
        out.links <- (A[i,]==1)
        out.nonlinks <- (A[i,]==0)
        # exclude i-i
        out.nonlinks[i] <- FALSE
        log.part1 <- log(1/(1+exp(-(R[out.links] -R[i] - H[i]))))
        log.part2 <- log(1 - 1/(1 + exp(-(R[out.nonlinks] - R[i] - H[i]))))
        ll <- ll + sum(log.part1) + sum(log.part2)
    }
    ll <- ll - regularization.coeff * (sum(R^2) + sum(H^2))
    return (ll)
}

log.likelihood.logistic.wrapped <- function(pars, A, regularization.coeff=0.01) {
    N <- nrow(A)
    R <- pars[1:N]
    H <- pars[(N+1):(2*N)]
    return (log.likelihood.logistic(R, H, A, regularization.coeff))
}

gradient.Ri <- function(i, R, H, A, regularization.coeff) {
    N <- nrow(A)
    node.vec <- 1:N
    return (sum(A[,i] - A[i,] + 1/(1+exp(-(R[node.vec] - R[i] - H[i]))) - 
                1/(1+exp(-(R[i] - R[node.vec] - H[node.vec])))) - 2 * regularization.coeff * R[i])
}

gradient.Hi <- function(i, R, H, A, regularization.coeff) {
    N <- nrow(A)
    node.vec <- 1:N
    result.vec <- -A[i,] + 1/(1+exp(-(R[node.vec] - R[i] - H[i])))
    # remove i-i in the vector
    return (sum(result.vec[-i]) - 2 * regularization.coeff * H[i]) 
}

gradient.wrapped <- function(pars, A, regularization.coeff=0.01) {
    N <- nrow(A)
    node.vec <- 1:N
    R <- pars[1:N]
    H <- pars[(N+1):(2*N)]
    grad.R.vec <- sapply(node.vec, function(x) gradient.Ri(x, R, H, A, regularization.coeff))
    grad.H.vec <- sapply(node.vec, function(x) gradient.Hi(x, R, H, A, regularization.coeff))
    return (c(grad.R.vec, grad.H.vec))
}

edge.link.prob.mat <- function(R, H) {
    N <- length(R)
    A <- diag(rep(0, N))
    for (i in 1:N) {
        for (j in 1:N) {
            if (j==i) next
            A[i,j] = 1/(1+exp(-(R[j] - R[i] - H[i])))
        }
    }
    return (A)
}

expected.number.of.edges <- function(R, H) {
    prob.mat <- edge.link.prob.mat(R, H)
    return (sum(rowSums(prob.mat)))
}
