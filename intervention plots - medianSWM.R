rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")

## FULL INTERVENTION PLOT
tasks <- list()
tasks[[1]] <- c("arith","woodcock","placeval","wiat")
tasks[[2]] <- c("spatialwm","verbalwm","ans","mental.rot")

titles <- list()
titles[[1]] <- c("Arithmetic","Woodcock-Johnson III","Place Value","WIAT")
titles[[2]] <- c("Spatial WM","Verbal WM","Weber Fraction","Mental Rotation")

scales <- list()
scales[[1]] <- c(0,1)
scales[[2]] <- c(2,5)

t <- "spatialwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,t] > median(subset(d,year==0)[,t],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs


for (t in 1:2) {
  mmd <- melt(subset(d,hi.split), 
              id.vars=c("subnum","year","condition"), 
              measure.vars=tasks[[t]])  
  mms <- ddply(mmd, .(variable,condition,year), summarise,
               m = mean(value, na.rm=TRUE), 
               ci.l = ci.low(value), 
               ci.h = ci.high(value), 
               n = n.unique(subnum))
  
  levels(mms$variable) <- titles[[t]]
  
  quartz()  
  p <- qplot(year, m, colour=condition, 
        group=condition,
        position=position_dodge(width=.1),
        ymin=m - ci.l, ymax=m + ci.h,
        ylim=scales[[t]],                  
        xlab="Year",ylab="Performance",
        geom=c("pointrange"),
        facets = ~ variable, 
        data = mms) + 
    geom_line() + 
    facet_grid(variable ~ ., scale="free_y") + 
    scale_colour_discrete(name="Condition/Class")
  print(p)
}

