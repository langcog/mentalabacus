rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")

##
split.var <- "spatialwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,split.var] > median(subset(d,year==0)[,split.var],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs


qplot(wholegroupsums,  facets= abacus~year, fill=interaction(hi.split,abacus),
      binwidth=.1, 
      position="dodge",
      data=subset(d,year==2 | year == 3))



## NOW DO INTERVENTION PLOT SPLIT
split.var <- "mentalrot.shapes"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,split.var] > median(subset(d,year==0)[,split.var],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

quartz()
tasks <- c("abacus.add","flashcards","abacus.arith")

mmd <- melt(d, id.vars=c("subnum","year","condition","hi.split"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year + hi.split, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year + hi.split, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year + hi.split, mmd, ci.high)$value
mms$n <- aggregate(value ~ variable + condition + year + hi.split, mmd, n.unique)$value

qplot(year, value, lty=hi.split,
      position=position_dodge(width=.1),
      ymin=value-ci.l, ymax=value+ci.h,
      xlab="Year",ylab="Performance",
      geom=c("pointrange"),
      data = mms) + 
  stat_smooth(method=lm,formula=y ~ x + I(x^2) ,se=FALSE) +
  facet_grid(variable ~ ., scale="free_y") + 
  scale_colour_discrete(guide="none")

