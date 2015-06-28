rm(list=ls())
library(MBESS)

source("~/Projects/R/Ranalysis/useful_dplyr.R")
d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")

## T-TESTS BY TASK
tasks <- c("wiat","woodcock","arith","placeval",
           "ravens","ans","spatialwm","verbalwm","mental.rot")
ids <- c("subnum","year","condition","female","age")

for (t in tasks) {
  md <- melt(d, id.vars=ids, measure.vars=t)
 
  print(paste("*********",t,"**********"))
  x1 <- subset(md, condition=="abacus" & year==0)$value
  x2 <- subset(md, condition=="control" & year==0)$value
  n1 <- sum(!is.na(x1))
  n2 <- sum(!is.na(x2))
  m1 <- mean(x1,na.rm=TRUE)
  m2 <- mean(x2,na.rm=TRUE)        
  s1 <- sd(x1, na.rm=TRUE)
  s2 <- sd(x2, na.rm=TRUE)        
  print(t.test(x1, x2, var.equal=TRUE))
  
  sd.pooled = sqrt(((n1-1) * s1^2 + (n2-1) * s2^2) / (n1+n2-2))
  
  es <- (m1 - m2) / sd.pooled
  ci <- ci.smd(smd=es,n.1=n1,n.2=n2)
  print(es)
  print(ci)
}

### GETTING YEAR 0 PAIRWISE TESTS ###
library(broom)
library(tidyr)
d %>% 
  select(one_of(c(ids, tasks))) %>%
  gather_("measure", "value", tasks) %>%
  group_by(measure) %>%
  do(tidy(t.test(.$value[.$year==0 & .$condition == "abacus"],
                 .$value[.$year==0 & .$condition == "control"],
                 var.equal = TRUE))) %>% 
  xtable
