## ACADEMIC OUTCOMES ANALYSES
rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/FULL ANALYSIS/data/zenith all data complete cases.csv")

tasks <- c("math","science","english","computer")
titles <-  c("Math","Science","English","Computer")

mmd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
mms$n <- aggregate(subnum ~ variable + condition + year, mmd, n.unique)$subnum

levels(mms$variable) <- titles
levels(mms$condition) <- c("MA","Control")

pdf("~/Projects/India Abacus/ZENITH/full analysis/plots/figures/academic outcomes.pdf",
    width=7.5,height=4)
qplot(year, value, colour=condition, 
      group=condition,label=condition,
      position=position_dodge(width=.05),
      ymin=value-ci.l, ymax=value+ci.h,
#       xlim=c(-0.05,3.5),
      xlab="Year",ylab="Numeric Grade",
      geom=c("pointrange"),
      ylim=c(50,100),
      data = mms) + 
  geom_line() + 
  facet_wrap(~ variable) +
  scale_colour_discrete(name="Condition") 
dev.off()
