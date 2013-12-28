rm(list=ls())
library(memisc)
library(texreg)
source("~/Projects/R/mcf.useful.R")
source("~/Projects/India Abacus/ZENITH/mentalabacus/mtable-lme4.R")

d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

## REGRESSION MODELS BY TASK
tasks <- c("wiat","woodcock","arith","placeval",
           "ravens","ans","spatialwm","verbalwm","mental.rot",
           "math","science","english","computer")

tnames <- c("WIAT","WJ-III","Arithmetic Task","Place Value Task",
           "Raven's Progressive Matrices","Number Comparison",
            "Spatial Working Memory","Verbal Working Memory","Mental Rotation",
           "Math Grades","Science Grades","English Grades","Computer Grades")

### LINEAR
for (i in 1:length(tasks)) {
  md <- melt(d, id.vars=c("subnum","year","condition","female","age"), measure.vars=tasks[i])
  
  m1 <- lmer(value ~ year * condition + (year | subnum),
             data=md)
  m2 <- lmer(value ~ year + condition + (year  | subnum),
             data=md)
        
  print(xtable(summary(m2)$coef,
        caption=paste("Linear mixed effects model coefficients for a linear growth model with no year * condition interaction term for ",tnames[i],".",sep="")))
  print(xtable(summary(m1)$coef,
        caption=paste("Linear mixed effects model coefficients for a linear growth model with year * condition interaction term for ",tnames[i],".",sep="")))
  print(xtable(anova(m1,m2),
        caption="Likelihood comparison for the preceding linear models."))
}



### QUADRATIC
for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","condition","female","age"), measure.vars=t)
  md$year2 <- md$year^2

  m1 <- lmer(value ~ year * condition + year2 * condition + 
                   (year + year2 | subnum),
                 data=md)
  m2 <- lmer(value ~ year + year2 + condition +
                   (year + year2 | subnum),
                 data=md)
  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
}

### YEAR AS FACTOR
for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","condition","female","age"), measure.vars=t)
  md$fyear <- factor(md$year)
  
  m1 <- lmer(value ~ fyear * condition + (fyear | subnum),
             data=md)
  m2 <- lmer(value ~ fyear + condition + (fyear  | subnum),
             data=md)
  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
}

