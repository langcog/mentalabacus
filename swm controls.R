rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")
d.demo <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith demographics.csv")
cntls <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/SWM controls.csv")
cntls.demo <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/SWM controls demographics.csv")


## datas
highses <- merge(subset(cntls,year=="highSES"),cntls.demo)
highses$dataset <- "highSES"
highses$age <- highses$age.months
adults <- subset(cntls,year=="adults")
names(adults) <- c("subnum","age","spatialwm")
adults$dataset <- "adults"
adults$age <- 21 + rnorm(20, mean=0, sd=.2)
zenith <- merge(d[,c("subnum","year","spatialwm")], d.demo[,c("subnum","age")])
zenith$age <- zenith$age + zenith$year
zenith$dataset <- "zenith"
alld <- rbind.fill(highses[,c("subnum","age","dataset","spatialwm")],
           adults,
           zenith[,c("subnum","age","dataset","spatialwm")])


##
summary(highses)
summary(adults)

## plot of spatial WM by year
qplot(age,spatialwm,col=factor(year),
      data=zenith) + geom_smooth(method="lm",SE=FALSE) + 
  xlab("Age (years)") + 
  ylab("Spatial Working Memory Span")

## plot of spatial WM in comparison to high SES
quartz()
qplot(age,spatialwm, col=dataset, data=alld) + 
  geom_smooth(method="lm",se=TRUE) +
  ylab("Spatial Working Memory Span") + 
  xlab("Age (Years)")

## do analysis where we only include children > 1SD below mean of highses



  
  
## histograms  
quartz()
ggplot(d, aes(x=spatialwm, fill=condition)) +
  geom_histogram(aes(y=..density..), binwidth=.5) +
  geom_line(aes(y = ..density..), col="black", adjust=2, stat = 'density') + 
  facet_grid(condition~year)



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