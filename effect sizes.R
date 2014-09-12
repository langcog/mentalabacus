rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

library(MBESS)
library(reshape2)

tasks <- c("arith","woodcock","placeval","wiat","spatialwm","verbalwm","ans","mental.rot","ravens")
titles <- c("Arithmetic","Woodcock-Johnson III","Place Value","WIAT","Spatial WM","Verbal WM","Weber Fraction","Mental Rotation","Raven's")

mmd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks,
            value.name="score",variable.name="task")  

es <- ddply(mmd, .(task,year), 
            function(x) {
              n1 <- sum(x$condition=="abacus")
              n2 <- sum(x$condition=="control")
              m1 <- mean(x$score[x$condition=="abacus"],na.rm=TRUE)
              m2 <- mean(x$score[x$condition=="control"],na.rm=TRUE)        
              s1 <- sd(x$score[x$condition=="abacus"],na.rm=TRUE)
              s2 <- sd(x$score[x$condition=="control"],na.rm=TRUE)        
              sd.pooled = sqrt(((n1-1) * s1^2 + (n2-1) * s2^2) / (n1+n2-2))
              
              d <- (m1 - m2) / sd.pooled
              ci <- ci.smd(smd=d,n.1=n1,n.2=n2)
              return(data.frame(year=x$year[1],
                                task=x$task[1],
                                d=d,
                                ci.l=ci$Lower.Conf.Limit.smd,
                                ci.h=ci$Upper.Conf.Limit.smd))
            })

nes <- ddply(es, .(task), 
             function(x) {
               x$d <- x$d - x$d[x$year==0]
               return(x)
             }
)

md <- ddply(nes[nes$year>0,], .(task), summarise, 
            dm= mean(d))

md[sort(md$dm,decreasing=TRUE,index.return=TRUE)$ix,]

qplot(year,d,colour=task,group=task,
      geom="line",
      data=nes)

## compute variability of measures

vars <- ddply(subset(mmd,task=="arith"|task=="woodcock"|task=="wiat"), 
      .(task,year), summarise, 
      sd = sd(score,na.rm=TRUE))
        
vars$task <- revalue(vars$task, c("arith"="Arithmetic","woodcock"="WJ-III",
                                  "wiat"="WIAT"))

quartz()
qplot(year, sd, col=task, data=vars, geom="line") + 
  xlab("Year") + 
  ylab("Standard Deviation") + 
  ylim(c(0,.2))
