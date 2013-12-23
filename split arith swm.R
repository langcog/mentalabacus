rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

### FIGURE FOR SPATIAL WM
t <- "spatialwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,t] > median(subset(d,year==0)[,t],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

md <- melt(d, id.vars=c("subnum","year","condition","hi.split"), measure.vars="arith") 
ms <- aggregate(value ~ variable + condition + year + hi.split, md, mean)
ms$ci.l <- aggregate(value ~ variable + condition + year + hi.split, 
                     md, ci.low)$value
ms$ci.h <- aggregate(value ~ variable + condition + year + hi.split, 
                     md, ci.high)$value
ms$n <- aggregate(value ~ variable + condition + year + hi.split, 
                  md, n.unique)$value
ms$hi.split <- factor(c("Low","High")[as.numeric(ms$hi.split)+1],
                      levels=c("Low","High"))
levels(ms$condition) <- c("MA","Control")

# pdf("~/Projects/India Abacus/ZENITH/zenith full analysis/plots/figures/arith swm split.pdf",
#     width=4.75,height=3)
qplot(year, value, colour=condition,linetype=hi.split, 
           position=position_dodge(width=.1),
           ymin=value-ci.l, ymax=value+ci.h,
           xlab="Year",ylab="Arithmetic Performance",
           geom=c("pointrange"),
           facets = . ~ variable, 
           data = ms) + 
  geom_line() +
#   stat_smooth(method=lm,formula=y ~ x + I(x^2) ,se=FALSE) +
  facet_grid(variable ~ ., scale="free_y") +
  scale_linetype_discrete(name="Spatial WM") + 
  scale_colour_discrete(name="Condition") 
# dev.off()