rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

## REGRESSION MODELS BY TASK
tasks <- c("wiat","woodcock","arith","placeval",
           "ravens","ans","spatialwm","verbalwm","mental.rot",
           "math","science","english","computer")

### LINEAR
for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","condition","female","age"), measure.vars=t)
  
  m1 <- lmer(value ~ year * condition + (year | subnum),
             data=md)
  m2 <- lmer(value ~ year + condition + (year  | subnum),
             data=md)
  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
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

