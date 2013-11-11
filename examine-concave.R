library(ggplot2)

ll.single.var.replace <- function(x, i, R, G, Beta) {
    R2 <- R
    R2[i] <- x
    return (log.likelihood(G, R2, Beta))
}

i <- 3
r <- seq(0, 1, length.out=100)
r.mle <- nodelist.df$R[i]
y <- sapply(r, function(x) ll.single.var.replace(x, i, nodelist.df$R, G, Beta))
fig <- qplot(x=r, y=y) + geom_vline(xintercept=r.mle, color="red")
print(fig)

ll.double.replace <- function(x1, x2, i1, i2, R, G, Beta) {
    R2 <- R
    R2[i1] <- x1
    R2[i2] <- x2
    return (log.likelihood(G, R2, Beta))
}


i1 <- 2
i2 <- 3

z <- x1 <- x2 <- NULL
for (x in seq(0,1,length.out=60)) {
    for (y in seq(0,1,length.out=60)) {
        x1 <- c(x1, x)
        x2 <- c(x2, y)
        rslt <- ll.double.replace(x, y, i1, i2, nodelist.df$R, G, Beta)
        z <- c(z, rslt)
    }
}
draw.df <- data.frame(x1, x2, z)
fig2 <- ggplot(draw.df, aes(x=x1, y=x2, z=z))  + geom_tile(aes(fill=z)) + stat_contour()
print(fig2)
