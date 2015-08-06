rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")
d.demo <- read.csv("data/zenith demographics.csv")
cntls <- read.csv("data/SWM controls.csv")
cntls.demo <- read.csv("data/SWM controls demographics.csv")

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
alld <- bind_rows(highses[,c("subnum","age","dataset","spatialwm")],
           adults,
           zenith[,c("subnum","age","dataset","spatialwm")])

## plot of spatial WM by year
qplot(age,spatialwm,col=factor(year),
      data=zenith) + geom_smooth(method="lm",SE=FALSE) + 
  xlab("Age (years)") + 
  ylab("Spatial Working Memory Span")

## plot of spatial WM in comparison to high SES
qplot(age,spatialwm, col=dataset, data=alld) + 
  geom_smooth(method="lm",se=TRUE) +
  ylab("Spatial Working Memory Span") + 
  xlab("Age (Years)")

## histograms  
ggplot(d, aes(x=spatialwm, fill=condition)) +
  geom_histogram(aes(y=..density..), binwidth=.5) +
  geom_line(aes(y = ..density..), col="black", adjust=2, stat = 'density') + 
  facet_grid(condition~year)