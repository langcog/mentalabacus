rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/FULL ANALYSIS/data/zenith all complete cases data.csv")

## PLOT OF TASK DATA
tasks <- c("wiat","woodcock","ans","arith","placeval","commute","spatialwm","verbalwm","ravens","mentalrot.letters","mentalrot.shapes")
#tasks <- c("ans","commute","mentalrot.letters","mentalrot.shapes")

for (t in tasks) {
  sd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=t)
  
  pdf(paste("~/Projects/India Abacus/ZENITH/full analysis/plots/subjects/",
            t,"_subs_quad.pdf",sep=""))
  
  v <- qplot(year,value, colour=condition,
             geom=c("point"),          
             data=subset(sd,round(subnum / 7) == subnum/7 )) + 
    facet_wrap(~ subnum) + 
    stat_smooth(method=lm,formula=y ~ x + I(x^2)  ,se=FALSE) 
  
  print(v)
  dev.off()
}
