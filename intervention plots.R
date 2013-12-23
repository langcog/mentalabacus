rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/FULL ANALYSIS/data/zenith all complete cases data.csv")

## FULL INTERVENTION PLOT
quartz()
tasks <- list()
tasks[[1]] <- c("arith","woodcock")
tasks[[2]] <- c("placeval","wiat")
tasks[[3]] <- c("spatialwm","verbalwm")
tasks[[4]] <- c("ans","mental.rot")

titles <- list()
titles[[1]] <- c("Arithmetic","Woodcock-Johnson III")
titles[[2]] <- c("Place Value","WIAT")
titles[[3]] <- c("Spatial WM","Verbal WM")
titles[[4]] <- c("Weber Fraction","Mental Rotation")

scales <- list()
scales[[1]] <- c(0,.5)
scales[[2]] <- c(0,1)
scales[[3]] <- c(2,5)
scales[[4]] <- c(0,1)

p <- list()
vp <- list()
xs <- c(.125,.375,.625,.875)

for (t in 1:4) {
  mmd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks[[t]])  
  mms <- aggregate(value ~ variable + condition + year, mmd, mean)
  mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
  mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
  mms$n <- aggregate(value ~ variable + condition + year, mmd, n.unique)$value
  
  levels(mms$variable) <- titles[[t]]
  p[[t]] <- qplot(year, value, colour=condition, 
                  group=condition,
                  position=position_dodge(width=.1),
                  ymin=value-ci.l, ymax=value+ci.h,
                  ylim=scales[[t]],
                  xlab="Year",ylab="Performance",
                  geom=c("pointrange"),
                  facets = . ~ variable, 
                  data = mms) + 
    geom_line() + 
  #     stat_smooth(method=lm,formula=y ~ x + I(x^2) ,se=FALSE) +
  facet_grid(variable ~ ., scale="free_y") + 
    scale_colour_discrete(guide="none")
  
  # plot to separate viewport
  vp[[t]] <- viewport(x=xs[t],y=.5,width=.25,height=1)
  print(p[[t]],vp=vp[[t]])
}

