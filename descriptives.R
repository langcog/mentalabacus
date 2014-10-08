rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")

cohen.d <- function (x,xdata) {
  xd <- xdata[x,]
  d1 <- subset(xd,condition=="control")[,1]
  d2 <- subset(xd,condition=="abacus")[,1]
  pooled.sd <- sqrt(((sd(d1)^2) + (sd(d2)^2))/2)
  es <- (mean(d2) - mean(d1)) / pooled.sd
  return(es)
}

## read data
d <- read.csv("data/zenith all data complete cases.csv")

## effect sizes
tasks <- c("arith","placeval","commute","wiat","woodcock",
           "ravens","spatialwm","verbalwm","mentalrot.letters","mentalrot.shapes","ans")

for (t in tasks) {
  td <- subset(d,year == 3)[,c(t,"condition")]
  bs <- bootstrap(1:nrow(td),1000,cohen.d,td)
  ci <- signif(quantile(bs$thetastar,c(.025,.975)),digits=2)
  
  print(paste(t,":",signif(cohen.d(1:nrow(td),td),digits=2),",",
              ci[1],"-",ci[2]))
}


## mediation
arith <- subset(d,year==3)[,c("subnum","arith","condition")]
swm0 <- subset(d,year==0)[,c("subnum","spatialwm","condition")]
med <- merge(arith,swm0)

summary(lm(arith ~ condition, data = med))
summary(lm(arith ~ spatialwm, data = med))
summary(lm(arith ~ condition * spatialwm, data = med))


## some correlations
library(Hmisc)
library(reshape2)
recast(data=d, ans ~ year, id.var="subnum", measure.var = "ans")

for (y in 0:3) {
  print(rcorr(cbind(d$ans[d$year==y],
                    d$arith[d$year==y],
                    d$wiat[d$year==y])))
}



wiat <- rcorr(cbind(d$wiat[d$year==0],
                  d$wiat[d$year==1],
                  d$wiat[d$year==2],
                  d$wiat[d$year==3]))

arith <- rcorr(cbind(d$arith[d$year==0],
                  d$arith[d$year==1],
                  d$arith[d$year==2],
                  d$arith[d$year==3]))

wj <- rcorr(cbind(d$woodcock[d$year==0],
                  d$woodcock[d$year==1],
                  d$woodcock[d$year==2],
                  d$woodcock[d$year==3]))
mean(wiat$r[wiat$r!=1])
mean(wj$r[wj$r!=1])
mean(arith$r[arith$r!=1])

### pretty print
library(Hmisc)
library(xtable)

tasks <- c("arith","placeval","wiat","woodcock",
           "spatialwm","verbalwm","mental.rot","ans")

for (t in tasks) {
  summaries <- data.frame(row.names=NULL)
  for (y in 0:3) {
    summaries <- rbind(summaries,
                       data.frame(year=y,
                                  mean_control=na.mean(d[d$year==y&d$abacus==0,t]),
                                  mean_MA=na.mean(d[d$year==y&d$abacus==1,t]),
                                  median_control=na.median(d[d$year==y&d$abacus==0,t]),
                                  median_MA=na.median(d[d$year==y&d$abacus==1,t]),
                                  SD_control=na.sd(d[d$year==y&d$abacus==0,t]),
                                  SD_MA=na.sd(d[d$year==y&d$abacus==1,t])))
  }
  print(xtable(summaries,
               caption=paste("Descriptive statistics for",t),
               label=paste("tab:",t,sep="")),        
        include.rownames=FALSE)
}
                                
    


xtable(xtabs(arith ~ year + abacus.f,data=d))
      