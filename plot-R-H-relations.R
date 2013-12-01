fig.1 <- ggplot(twitter.estimate.df) + 
    geom_point(aes(x=indegree.vec, y=R, color="Blogs"), data=polblogs.estimate.df) + 
    geom_point(aes(x=indegree.vec, y=R, color="Twitter"), data=twitter.estimate.df) + 
    xlab("In-degree") + ylab("R (social status)") + 
    scale_color_discrete(name="Dataset")

print(fig.1)

fig.2 <- ggplot(twitter.estimate.df) + 
    geom_point(aes(x=outdegree.vec, y=H, color="Blogs"), shape=1, data=polblogs.estimate.df) + 
    geom_point(aes(x=outdegree.vec, y=H, color="Twitter"), shape=1, data=twitter.estimate.df) + 
    xlab("Out-degree") + ylab("H (threshold)") + 
    scale_color_discrete(name="Dataset")

print(fig.2)


fig.3 <- ggplot(twitter.estimate.df) + 
    geom_point(aes(x=R, y=H, color="Blogs"),  data=polblogs.estimate.df) + 
    geom_point(aes(x=R, y=H, color="Twitter"), data=twitter.estimate.df) + 
    xlab("R (social status)") + ylab("H (threshold)") + 
    scale_color_discrete(name="Dataset")

print(fig.3)