rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")
library(xtable)

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
  md <- reshape2::melt(d, id.vars=c("subnum","year","condition","female","age"), measure.vars=tasks[i])
  
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
  md <- reshape2::melt(d, id.vars=c("subnum","year","condition","female","age"), 
                       measure.vars=t)
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
  md <- reshape2::melt(d, id.vars=c("subnum","year","condition","female","age"), 
                       measure.vars=t)
  md$fyear <- factor(md$year)
  
  m1 <- lmer(value ~ fyear * condition + (fyear | subnum),
             data=md)
  m2 <- lmer(value ~ fyear + condition + (fyear  | subnum),
             data=md)
  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
}


#### FOLLOWUP FOR PLACEVALUE ####
md <- reshape2::melt(d, 
           id.vars=c("subnum","year","condition","female","age"), 
           measure.vars="placeval")

m1 <- lmer(value ~ year * condition + (year | subnum),
           data=subset(md, year > 0))
m2 <- lmer(value ~ year + condition + (year  | subnum),
           data=subset(md, year > 0))

anova(m1,m2)

# note that quadratic models don't converge without year 0
md$fyear <- factor(md$year)

m1 <- lmer(value ~ fyear * condition + (1 | subnum),
           data=subset(md, year > 0))
m2 <- lmer(value ~ fyear + condition + (1 | subnum),
           data=subset(md, year > 0))

anova(m1,m2)