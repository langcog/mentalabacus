## MATH OUTCOMES ANALYSES
rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

tasks <- c("arith","placeval","woodcock","wiat")
titles <- c("Arithmetic","Place Value","Woodcock-Johnson III", "WIAT")

mmd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
mms$n <- aggregate(subnum ~ variable + condition + year, mmd, n.unique)$subnum

levels(mms$variable) <- titles
levels(mms$condition) <- c("MA","Control")

pdf("~/Projects/India Abacus/ZENITH/full analysis/plots/figures/math outcomes.pdf",
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