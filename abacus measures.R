rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/FULL ANALYSIS/data/zenith all complete cases data.csv")
d <- subset(d,abacus==TRUE)

## MERGE IN ALL THE ABACUS DATA
a1 <- read.csv("~/Projects/India Abacus/ZENITH/FULL ANALYSIS/data/abacus/ZENITH 2011 abacus expts.csv")
a1$year <- a1$year - 2010
a2 <- read.csv("~/Projects/India Abacus/ZENITH/FULL ANALYSIS/data/abacus/ZENITH 2012 abacus expts.csv")
a2$year <- a2$year - 2010
a3 <- read.csv("~/Projects/India Abacus/ZENITH/FULL ANALYSIS/data/abacus/ZENITH 2013 abacus expts.csv")
a3$year <- a3$year - 2010

d <- merge(d,rbind(a1,a2,a3),by.x=c("subnum","year"),by.y=c("subnum","year"),all.x=TRUE,all.y=FALSE)

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

