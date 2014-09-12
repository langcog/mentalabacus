rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

### FIGURE FOR SPATIAL WM
t <- "verbalwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,t] > median(subset(d,year==0)[,t],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

md <- melt(d, id.vars=c("subnum","year","condition","hi.split"), 
           measure.vars="arith") 
ms <- ddply(md, .(variable, condition, year, hi.split), 
            summarise, 
            m.value = mean(value, na.rm=TRUE), 
            ci.l = ci.low(value), 
            ci.h = ci.high(value), 
            n = n.unique(value))

ms$hi.split <- factor(c("Low","High")[as.numeric(ms$hi.split)+1],
                     levels=c("Low","High"))

levels(ms$condition) <- c("MA","Control")

pdf("~/Projects/Abacus/ZENITH/mentalabacus/supplemental/figures/wj_by_vwm.pdf",
    width=4.75,height=3)
qplot(year, m.value, colour=condition,linetype=hi.split, 
           position=position_dodge(width=.1),
           ymin=m.value-ci.l, ymax=m.value+ci.h,
           xlab="Year",ylab="Arithmetic Performance",
           geom=c("pointrange"),
           data = ms) + 
  geom_line() +
  scale_linetype_discrete(name="Verbal WM") + 
  scale_colour_discrete(name="Condition") 
dev.off()
