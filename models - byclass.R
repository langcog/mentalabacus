rm(list=ls())
library(memisc)
library(texreg)
library(xtable)
source("~/Projects/R/mcf.useful.R")
source("~/Projects/Abacus/ZENITH/mentalabacus/mtable-lme4.R")

d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")

## REGRESSION MODELS BY TASK
# only including tasks that we think are likely to have any appreciable class effect
tasks <- c("wiat","woodcock","arith","placeval",
           "spatialwm","verbalwm","mental.rot","math")

tnames <- c("WIAT","WJ-III","Arithmetic Task","Place Value Task",
            "Spatial Working Memory","Verbal Working Memory","Mental Rotation","Math Grades")

d$condition <- factor(d$condition, levels=c("control","abacus"))

### LINEAR
for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","class","condition","female","age"), measure.vars=t)
  
  m1 <- lmer(value ~ year * condition * class + (year | subnum),
             data=md)
  m2 <- lmer(value ~ year * condition + class + (year  | subnum),
             data=md)

  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
}




### QUADRATIC
for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","condition","class","female","age"), measure.vars=t)
  md$year2 <- md$year^2

  m1 <- lmer(value ~ year * condition * class + year2 * condition * class + 
                   (year + year2 | subnum),
                 data=md)
  m2 <- lmer(value ~ year * condition + year2 * condition + class + 
                   (year + year2 | subnum),
                 data=md)
  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
}
