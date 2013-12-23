## MATH OUTCOMES ANALYSES
rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

tasks <- c("spatialwm","verbalwm","ans","mental.rot")
titles <-  c("Spatial WM","Verbal WM","Weber Fraction","Mental Rotation")

mmd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
mms$n <- aggregate(subnum ~ variable + condition + year, mmd, n.unique)$subnum

levels(mms$variable) <- titles
levels(mms$condition) <- c("MA","Control")

pdf("~/Projects/India Abacus/ZENITH/full analysis/plots/figures/cognitive outcomes.pdf",
    width=7.5,height=4)
qplot(year, value, colour=condition, 
      group=condition,label=condition,
      position=position_dodge(width=.05),
      ymin=value-ci.l, ymax=value+ci.h,
#       xlim=c(-0.05,3.5),
      xlab="Year",ylab="Proportion Correct",
      geom=c("pointrange"),
      data = mms) + 
  geom_line() + 
  facet_wrap(~ variable, scale="free_y") +
  scale_colour_discrete(name="Condition") 
dev.off()

## t-tests for Raven's
t.test(d$ravens[d$year==0 & d$abacus==0],
       d$ravens[d$year==0 & d$abacus==1])

t.test(d$ravens[d$year==1 & d$abacus==0],
       d$ravens[d$year==1 & d$abacus==1])

t.test(d$ravens[d$year==2 & d$abacus==0],
       d$ravens[d$year==2 & d$abacus==1])

t.test(d$ravens[d$year==3 & d$abacus==0],
       d$ravens[d$year==3 & d$abacus==1])