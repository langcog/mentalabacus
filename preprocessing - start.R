rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R") # from github.com/langcog/Ranalysis

## MERGE TOGETHER PAPER RECORDS
data2010 <- read.csv("data/paper/2010_PaperTaskData_Final.csv")
data2011 <- read.csv("data/paper/2011_PaperTaskData_Final.csv")
data2012 <- read.csv("data/paper/2012_PaperTaskData_Final.csv")
data2013 <- read.csv("data/paper/2013_PaperTaskData_Final.csv")
d <- rbind.fill(data2010,data2011,data2012,data2013)
d$year <- d$year - 2010 ## set year to 0

## MERGE IN DEMOGRAPHICS
demo <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith demographics.csv")
demo$class[demo$class==""] <- NA
d <- merge(d,demo)

## MERGE IN COMPUTER DATA
cdata <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/computer/zenith all computer tasks.csv")
cdata$year <- cdata$year - 2010 ## set year to 0
d <- merge(d,cdata,by.x = c("subnum","year"),by.y = c("subnum","year"))

## MERGE IN GRADES
grades2010 <- read.csv("data/grades/grades 2010.csv")
grades2011 <- read.csv("data/grades/grades 2011.csv")
grades2012 <- read.csv("data/grades/grades 2012.csv")
grades2013 <- read.csv("data/grades/grades 2013.csv")
g <- rbind.fill(grades2010,grades2011,grades2012,grades2013)
g$year <- g$year - 2010 ## set year to 0
d <- merge(d,g,by.x = c("subnum","year"), by.y = c("subnum","year"))

## write out
write.csv(d,"data/zenith all data.csv",row.names=FALSE)