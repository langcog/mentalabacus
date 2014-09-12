rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")
d <- subset(d,abacus==TRUE)

## MERGE IN ALL THE ABACUS DATA
a1 <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/abacus/2011_AbacusOnlypaperTask.csv")
a1$year <- a1$year - 2010
a2 <- read.csv("~/Projects/Abacus/ZENITH/zenith full analysis/data/abacus/2012_AbacusOnlypaperTask.csv")
a2$year <- a2$year - 2010
a3 <- read.csv("~/Projects/Abacus/ZENITH/zenith full analysis/data/abacus/2013_AbacusOnlypaperTask.csv")
a3$year <- a3$year - 2010

d <- merge(d,rbind(a1,a2,a3),by.x=c("subnum","year"),by.y=c("subnum","year"),all.x=TRUE,all.y=FALSE)

## NOW DO INTERVENTION PLOT SPLIT
split.var <- "spatialwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,split.var] > median(subset(d,year==0)[,split.var],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

quartz()
tasks <- c("abacus.sums","abacus.flashcards","abacus.arith")

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

## NOW CHECK FOR CLASS EFFECTS
mmd <- melt(d, id.vars=c("subnum","year","condition","class"), 
            measure.vars=c("abacus.sums","abacus.flashcards","abacus.arith"))  
mms <- ddply(subset(mmd, !is.na(class) & year>0), 
             .(variable,condition,year,class), 
             summarise,
             m = mean(value, na.rm=TRUE), 
             ci.l = ci.low(value), 
             ci.h = ci.high(value), 
             n = n.unique(subnum))

qplot(factor(year), m, lty=class, col="red",
      position=position_dodge(width=.1),
      ymin=m-ci.l, ymax=m+ci.h,
      xlab="Year",ylab="Performance",
      geom=c("pointrange"),
      data = mms) + 
  geom_line(aes(group=class)) +
  facet_grid(variable ~ ., scale="free_y") + 
  scale_colour_discrete(guide="none") 