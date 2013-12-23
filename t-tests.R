rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

## T-TESTS BY TASK
tasks <- c("wiat","woodcock","arith","placeval",
           "ravens","ans","spatialwm","verbalwm","mental.rot",
           "math","science","english","computer","art","music")

for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","condition","female","age"), measure.vars=t)
  
 
  print(paste("*********",t,"**********"))
  print(t.test(subset(md,condition=="abacus" & year==1)$value,
               subset(md,condition=="control" & year==1)$value,var.equal=TRUE))
  print(t.test(subset(md,condition=="abacus" & year==2)$value,
               subset(md,condition=="control" & year==2)$value,var.equal=TRUE))
  print(t.test(subset(md,condition=="abacus" & year==3)$value,
               subset(md,condition=="control" & year==3)$value,var.equal=TRUE))
}
