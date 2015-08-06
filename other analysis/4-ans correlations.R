## notebook to look at ANS correlations
rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

library(stringr)
library(Hmisc)

for (y in 0:3) {
  this.year <- data.frame(ans=d$ans[d$year==y],
                          arith=d$arith[d$year==y],
                          wiat=d$wiat[d$year==y],
                          woodcock=d$woodcock[d$year==y])
  
#   quartz()
#   splom(this.year,pch=20)

  corrs <- rcorr(as.matrix(this.year),type="spearman")
  print(paste("**** year",as.character(y),"****"))
  print(round(corrs$r,digits=2))
  print(round(corrs$P,digits=2))
}

## add MCMC

mc <- read.table("~/Projects/India Abacus/ZENITH/zenith full analysis/data/mcmc.txt",
                 header=TRUE)
mc$W.ML[mc$W.ML > 1] <- NA 

mc$subnum <- floor(mc$subject)
mc$year <- round(((mc$subject - floor(mc$subject)) * 10000)) - 2010

dplus <- merge(d,mc,by.x=c("subnum","year"), by.y=c("subnum","year"))



library(ggplot2)
qplot(W.ML, ans,facets=~ year,
      data=dplus)

quartz()
qplot(ans, W.mcmc,facets=~ year,
      data=dplus) + 
  geom_linerange(aes(ymin=W.lower,ymax=W.upper),alpha=.25) + 
  geom_abline(aes(slope=1),colour="red") + 
  xlab("ML estimate (Mike)") + 
  ylab("MCMC estimate (Steve)") + theme_bw()

quartz()
qplot(W.mcmc,arith,facets=~ year,colour=factor(abacus),
      data=dplus) + 
  geom_linerange(aes(ymin=W.lower,ymax=W.upper),alpha=.25) + theme_bw()

## weighted regression
for (y in 0:3) {
  print(paste("*** year ",y,"***"))
  print(summary(lm (arith ~ ans, data=subset(dplus,year==y))))
  print(summary(lm (arith ~ W.mcmc, data=subset(dplus,year==y), 
              weights=(1/dplus[dplus$year==y,]$W.sd^2))))
}

for (y in 0:3) {
  this.year <- data.frame(ans=dplus$W.mcmc[dplus$year==y],
                          arith=dplus$arith[dplus$year==y],
                          wiat=dplus$wiat[dplus$year==y],
                          woodcock=dplus$woodcock[dplus$year==y])
  
  corrs <- rcorr(as.matrix(this.year),type="spearman")
  print(paste("**** year",as.character(y),"****"))
  print(round(corrs$r,digits=2))
  print(round(corrs$P,digits=2))
}