rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")

## FULL INTERVENTION PLOT
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

for (t in 1:4) {
  mmd <- melt(d, id.vars=c("subnum","year","condition","class"), measure.vars=tasks[[t]])  
  mms <- ddply(mmd, .(variable,condition,year,class), summarise,
               m = mean(value, na.rm=TRUE), 
               ci.l = ci.low(value), 
               ci.h = ci.high(value), 
               n = n.unique(subnum))
  
  levels(mms$variable) <- titles[[t]]
  
  quartz()  
  p <- qplot(year, m, colour=interaction(condition,class), 
        group=interaction(condition,class),
        position=position_dodge(width=.1),
        ymin=m - ci.l, ymax=m + ci.h,
        ylim=scales[[t]],                  
        xlab="Year",ylab="Performance",
        geom=c("pointrange"),
        facets = . ~ variable, 
        data = subset(mms,
                      (condition=="abacus" & class=="A") | 
                        (class=="B") |
                        (condition=="control" & class=="C"))) + 
    geom_line() + 
    facet_grid(variable ~ ., scale="free_y") + 
    scale_colour_discrete(name="Condition/Class")
  print(p)
}

