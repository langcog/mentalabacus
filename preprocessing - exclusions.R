rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data.csv")

######## COMPUTE COMPLETE CASES (EG NO DROPOUT) ########
# policy: use only complete cases (some data for all years)
d$completed <- !is.na(d$ravens) | !is.na(d$wiat) | !is.na(d$verbalwm) | !is.na(d$arith)
dropouts <- ddply(d, .(year, abacus), summarise, 
                  complete=sum(completed))

# more kids leave in the abacus group
qplot(year,complete,colour=factor(abacus),data=dropouts,
      geom="line",group=abacus) + ylim(c(0,104))

completed.cases <- ddply(d, .(subnum), summarise, 
                         completed = sum(completed))
complete.subnums <- completed.cases$subnum[completed.cases$completed==4]
d <- subset(d,subnum %in% complete.subnums)

## exclusions on computer/2AFC tasks for those kids who didn't understand
### ANS ###
# policy: exclude 3 sds above the full population mean
d$ans[d$ans > mean(d$ans,na.rm=T) + 3*sd(d$ans,na.rm=T)] <- NA

### MENTAL ROTATION ###
# check the sum scoring compared with the non-sum
## SUM wins hands down
mrot.corrs <- data.frame(year=factor(rep(c("0-1","1-2","2-3"),4)),
                         measure=factor(c(rep("shapes",6),rep("letters",6))),
                         method=factor(rep(c(rep("unpenalized",3),rep("penalized",3)),2)),
                         corrs=c(cor.test(d$mental.rot.shapes.prop[d$year==0],d$mental.rot.shapes.prop[d$year==1])$estimate,
                                 cor.test(d$mental.rot.shapes.prop[d$year==1],d$mental.rot.shapes.prop[d$year==2])$estimate,
                                 cor.test(d$mental.rot.shapes.prop[d$year==2],d$mental.rot.shapes.prop[d$year==3])$estimate,
                                 #vs
                                 cor.test(d$mental.rot.shapes.sum[d$year==0],d$mental.rot.shapes.sum[d$year==1])$estimate,
                                 cor.test(d$mental.rot.shapes.sum[d$year==1],d$mental.rot.shapes.sum[d$year==2])$estimate,
                                 cor.test(d$mental.rot.shapes.sum[d$year==2],d$mental.rot.shapes.sum[d$year==3])$estimate,
                                 #letters
                                 cor.test(d$mental.rot.letters.prop[d$year==0],d$mental.rot.letters.prop[d$year==1])$estimate,
                                 cor.test(d$mental.rot.letters.prop[d$year==1],d$mental.rot.letters.prop[d$year==2])$estimate,
                                 cor.test(d$mental.rot.letters.prop[d$year==2],d$mental.rot.letters.prop[d$year==3])$estimate,
                                 #vs
                                 cor.test(d$mental.rot.letters.sum[d$year==0],d$mental.rot.letters.sum[d$year==1])$estimate,
                                 cor.test(d$mental.rot.letters.sum[d$year==1],d$mental.rot.letters.sum[d$year==2])$estimate,
                                 cor.test(d$mental.rot.letters.sum[d$year==2],d$mental.rot.letters.sum[d$year==3])$estimate))

quartz()
qplot(year,corrs,colour=measure,linetype=method,
      group=measure:method,
      geom=c("point","line"),
      data=mrot.corrs) + ylim(c(0,1)) + 
  xlab("Year pair") + ylab("Correlation coefficient")

# policy: if you're significantly below chance, exclude
x <- rbinom(100000,48,.5)
score <- x - (48 - x)
d$mental.rot.letters.sum[d$mental.rot.letters.sum < quantile(score,c(.05))] <- NA
d$mental.rot.shapes.sum[d$mental.rot.shapes.sum < quantile(score,c(.05))] <- NA

d$mental.rot <- (d$mental.rot.letters.sum + d$mental.rot.shapes.sum)/96

d <- d[,!names(d) %in% c("mental.rot.letters.prop","mental.rot.letters.sum",
           "mental.rot.shapes.prop","mental.rot.shapes.sum")]

# commutativity 
# check sum
commute.corrs <- data.frame(year=factor(rep(c("0-1","1-2","2-3"),2)),                      
                            method=factor(c(rep("unpenalized",3),rep("penalized",3))),
                            corrs=c(cor.test(d$commute.prop[d$year==0],d$commute.prop[d$year==1])$estimate,
                                    cor.test(d$commute.prop[d$year==1],d$commute.prop[d$year==2])$estimate,
                                    cor.test(d$commute.prop[d$year==2],d$commute.prop[d$year==3])$estimate,
                                    #vs
                                    cor.test(d$commute.sum[d$year==0],d$commute.sum[d$year==1])$estimate,
                                    cor.test(d$commute.sum[d$year==1],d$commute.sum[d$year==2])$estimate,
                                    cor.test(d$commute.sum[d$year==2],d$commute.sum[d$year==3])$estimate))

# policy: exclude if you don't have two questions right (first two are check questions)#d$commute[d$commute < 3/26] <- NA
# done by hand via Jess
# also, this measure is not useful
d <- d[,!names(d) %in% c("commute.sum","commute.prop")]

# ravens
# policy: exclude if you got not a single question correct
d$ravens[d$ravens == 0] <- NA

# WIAT
# policy: exclude if you got not a single question correct
d$wiat[d$wiat == 0] <- NA

# PLACE VAL - reliability computation
pv.corrs <- data.frame(year=factor(c("0-1","1-2","2-3")),
                         corrs=c(cor.test(d$placeval[d$year==0],d$placeval[d$year==1])$estimate,
                                 cor.test(d$placeval[d$year==1],d$placeval[d$year==2])$estimate,
                                 cor.test(d$placeval[d$year==2],d$placeval[d$year==3])$estimate))


## write out
write.csv(d,"~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv",row.names=FALSE)