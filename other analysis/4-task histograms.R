rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

## PLOT OF TASK DATA
#tasks <- c("wiat","woodcock","ans","arith","placeval","commute","spatialwm","verbalwm","ravens","mentalrot.letters","mentalrot.shapes")
tasks <- c("ans","commute","mentalrot.letters","mentalrot.shapes")

for (t in tasks) {
  sd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=t)
  msd <- aggregate(value ~ year + condition, data=sd, mean)
  
  pdf(paste("~/Projects/India Abacus/ZENITH/full analysis/plots/tasks/",
            t,"_hist_trimmed.pdf",sep=""))
  
  v <- qplot(value,facets= year ~ variable, fill=condition,
             geom="histogram",
             binaxis="x",stackdir="up",stackgroups=TRUE,
             data=sd) + 
    geom_vline(data=msd, aes(xintercept=value, colour=condition),lty=2) 
  print(v)
  dev.off()
}
