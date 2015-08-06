## a variety of descriptive statistics and effect sizes
rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

## effect sizes --------------------------------
library(MBESS)
library(reshape2)
library(xtable)
library(Hmisc)

tasks <- c("arith","woodcock","placeval","wiat","spatialwm","verbalwm","ans","mental.rot","ravens")
titles <- c("Arithmetic","Woodcock-Johnson III","Place Value","WIAT","Spatial WM","Verbal WM","Weber Fraction","Mental Rotation","Raven's")

mmd <- reshape::melt(d, id.vars=c("subnum","year","condition"), 
                     measure.vars=tasks)  

# function
get_es <- function(x) {
  n1 <- sum(x$condition=="abacus")
  n2 <- sum(x$condition=="control")
  m1 <- mean(x$value[x$condition=="abacus"],na.rm=TRUE)
  m2 <- mean(x$value[x$condition=="control"],na.rm=TRUE)        
  s1 <- sd(x$value[x$condition=="abacus"],na.rm=TRUE)
  s2 <- sd(x$value[x$condition=="control"],na.rm=TRUE)        
  sd.pooled = sqrt(((n1-1) * s1^2 + (n2-1) * s2^2) / (n1+n2-2))
  
  d <- (m1 - m2) / sd.pooled
  ci <- ci.smd(smd=d,n.1=n1,n.2=n2)
  return(data.frame(year=x$year[1],
                    task=x$variable[1],
                    d=d,
                    ci.l=ci$Lower.Conf.Limit.smd,
                    ci.h=ci$Upper.Conf.Limit.smd))
}

### NOTE: ES is the dataframe reported in the ms.
es <- mmd %>% 
  group_by(variable,year) %>%
  do(get_es(.))

## differences of effect sizes
nes <- es %>% 
  group_by(task) %>% 
  mutate(d.diff = d - d[year==0])

md <- nes %>% 
  filter(year>0) %>%
  group_by(task) %>%
  summarise(dm= mean(d))

md[sort(md$dm,decreasing=TRUE,index.return=TRUE)$ix,]

qplot(year,d,colour=task,group=task,
      geom="line",
      data=nes)

## compute variability of measures --------------------------

vars <- mmd %>% 
  filter(variable=="arith" | variable=="woodcock" | variable=="wiat") %>%
  group_by(variable, year) %>%
  summarise(sd = sd(value,na.rm=TRUE),
            min = min(value,na.rm=TRUE),
            max = max(value,na.rm=TRUE))

vars$task <- plyr::revalue(vars$variable, 
                           c("arith"="Arithmetic",
                             "woodcock"="WJ-III",
                             "wiat"="WIAT"))

qplot(year, sd, col=task, data=vars, geom="line") + 
  xlab("Year") + 
  ylab("Standard Deviation") + 
  ylim(c(0,.2))

## mediation
arith <- subset(d,year==3)[,c("subnum","arith","condition")]
swm0 <- subset(d,year==0)[,c("subnum","spatialwm","condition")]
med <- merge(arith,swm0)

summary(lm(arith ~ condition, data = med))
summary(lm(arith ~ spatialwm, data = med))
summary(lm(arith ~ condition * spatialwm, data = med))

## some basic correlations ------------------------------------
library(Hmisc)

for (y in 0:3) {
  print(rcorr(cbind(d$ans[d$year==y],
                    d$arith[d$year==y],
                    d$wiat[d$year==y])))
}



wiat <- rcorr(cbind(d$wiat[d$year==0],
                  d$wiat[d$year==1],
                  d$wiat[d$year==2],
                  d$wiat[d$year==3]))

arith <- rcorr(cbind(d$arith[d$year==0],
                  d$arith[d$year==1],
                  d$arith[d$year==2],
                  d$arith[d$year==3]))

wj <- rcorr(cbind(d$woodcock[d$year==0],
                  d$woodcock[d$year==1],
                  d$woodcock[d$year==2],
                  d$woodcock[d$year==3]))
mean(wiat$r[wiat$r!=1])
mean(wj$r[wj$r!=1])
mean(arith$r[arith$r!=1])

### pretty print ----------------------------
tasks <- c("arith","placeval","wiat","woodcock",
           "spatialwm","verbalwm","mental.rot","ans")

for (t in tasks) {
  summaries <- data.frame(row.names=NULL)
  for (y in 0:3) {
    summaries <- rbind(summaries,
                       data.frame(year=y,
                                  mean_control=na.mean(d[d$year==y&d$abacus==0,t]),
                                  mean_MA=na.mean(d[d$year==y&d$abacus==1,t]),
                                  median_control=na.median(d[d$year==y&d$abacus==0,t]),
                                  median_MA=na.median(d[d$year==y&d$abacus==1,t]),
                                  SD_control=na.sd(d[d$year==y&d$abacus==0,t]),
                                  SD_MA=na.sd(d[d$year==y&d$abacus==1,t])))
  }
  print(xtable(summaries,
               caption=paste("Descriptive statistics for",t),
               label=paste("tab:",t,sep="")),        
        include.rownames=FALSE)
}
                                
xtable(xtabs(arith ~ year + abacus,data=d))
      