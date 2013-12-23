rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/paper expts/2013_MathAnxiety.csv")

## average the measures
names(d)[6:21]
names(d)[25:36]
names(d)[c(25,32,36)]
d$anxiety <- rowMeans(d[,6:21],na.rm=TRUE)
d$mindset <- rowMeans(d[,25:36],na.rm=TRUE)
d$mindset2 <- rowMeans(d[,c(25,32,36)],na.rm=TRUE)

## aggregate and test
aggregate(anxiety ~ abacus,d,mean)
sd(d$anxiety[d$abacus==0],na.rm=TRUE)
sd(d$anxiety[d$abacus==1],na.rm=TRUE)
t.test(d$anxiety[d$abacus==1],d$anxiety[d$abacus==0],
       var.equal=TRUE)
(na.mean(d$anxiety[d$abacus==1]) - na.mean(d$anxiety[d$abacus==0])) / sd(d$anxiety,na.rm=TRUE)

aggregate(mindset ~ abacus,d,mean)
sd(d$mindset[d$abacus==0],na.rm=TRUE)
sd(d$mindset[d$abacus==1],na.rm=TRUE)
t.test(d$mindset[d$abacus==1],d$mindset[d$abacus==0],
       var.equal=TRUE)
(na.mean(d$mindset[d$abacus==1]) - na.mean(d$mindset[d$abacus==0])) / sd(d$mindset,na.rm=TRUE)

## items 1, 8, and 12 ONLY
aggregate(mindset2 ~ abacus,d,mean)
sd(d$mindset2[d$abacus==0],na.rm=TRUE)
sd(d$mindset2[d$abacus==1],na.rm=TRUE)
t.test(d$mindset2[d$abacus==1],d$mindset2[d$abacus==0],
       var.equal=TRUE)
(na.mean(d$mindset2[d$abacus==1]) - na.mean(d$mindset2[d$abacus==0])) / sd(d$mindset2,na.rm=TRUE)