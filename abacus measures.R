rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")
d <- subset(d,abacus==TRUE)

## MERGE IN ALL THE ABACUS DATA
a1 <- read.csv("data/abacus/2011_AbacusOnlypaperTask.csv")
a1$year <- a1$year - 2010
a2 <- read.csv("data/abacus/2012_AbacusOnlypaperTask.csv")
a2$year <- a2$year - 2010
a3 <- read.csv("data/abacus/2013_AbacusOnlypaperTask.csv")
a3$year <- a3$year - 2010

d <- merge(d, rbind(a1,a2,a3),
           by.x=c("subnum","year"),
           by.y=c("subnum","year"),
           all.x=TRUE, all.y=FALSE)

## NOW DO INTERVENTION PLOT SPLIT
split.var <- "spatialwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,split.var] > median(subset(d,year==0)[,split.var],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

tasks <- c("abacus.sums","abacus.flashcards","abacus.arith")

mmd <- melt(d, id.vars=c("subnum","year","condition","hi.split"), measure.vars=tasks)  
mms <- ddply(mmd, .(variable, condition, year, hi.split), summarise, 
                    mean = mean(value,na.rm=TRUE),
                    ci.l = ci.low(value),
                    ci.h = ci.high(value))

mms$swm <- factor(c("low SWM","high SWM")[as.numeric(mms$hi.split)+1])
mms$task <- factor(c("Physical Abacus Arithmetic","Physical Abacus Decoding",
                     "Physical Abacus Sums")[as.numeric(mms$variable)])

pdf("figures/abacus uptake.pdf",
    width=8,height=3)
qplot(year, mean, lty=swm,
      position=position_dodge(width=.05),
      ymin=mean-ci.l, ymax=mean+ci.h,
      xlab="Year",ylab="Performance",
      geom=c("line","pointrange"),
      data = subset(mms,year>0)) + 
  ylim(c(0,1)) +
  facet_wrap(~ task, scales="free") + 
  scale_colour_manual(name="Condition",values=c("#bdbdbd","#636363")) + 
  guides(colour=FALSE, label=FALSE, linetype=FALSE) +
  geom_text(data=subset(mms,year==2), aes(x=year,y=mean*c(.9,1.1),
                                          label=swm)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        strip.background = element_rect(fill = "white", colour="white"), 
        strip.text = element_text(size=12), 
        axis.line = element_line(size = .5, colour = "black"), 
        panel.border = element_rect(colour="white"))
dev.off()



## NOW CHECK FOR CLASS EFFECTS
mmd <- melt(d, id.vars=c("subnum","year","condition","class"), 
            measure.vars=c("abacus.sums","abacus.flashcards","abacus.arith"))  
mms <- ddply(subset(mmd, !is.na(class) & year>0), 
             .(variable,condition,year,class), 
             summarise,
             m = mean(value, na.rm=TRUE), 
             ci.l = ci.low(value), 
             ci.h = ci.high(value), 
             n = n.unique(subnum))

qplot(factor(year), m, lty=class, col="red",
      position=position_dodge(width=.1),
      ymin=m-ci.l, ymax=m+ci.h,
      xlab="Year",ylab="Performance",
      geom=c("pointrange"),
      data = mms) + 
  geom_line(aes(group=class)) +
  facet_grid(variable ~ ., scale="free_y") + 
  scale_colour_discrete(guide="none") 

# test for differences
summary(lmer(abacus.flashcards ~ year * class + (year | subnum), data=d))
summary(lmer(abacus.flashcards ~ year * class + I(year^2) * class + (year + year^2 | subnum), data=d))


## PHYSICAL ABACUS MEDIATING OUTCOMES
tasks <- c("arith","woodcock","wiat","placeval")
splits <- c("abacus.flashcards","abacus.sums")

cor.test(subset(d, year==1 & condition=="abacus")$abacus.flashcards,
         subset(d, year==1 & condition=="abacus")$arith)
cor.test(subset(d, year==2 & condition=="abacus")$abacus.flashcards,
         subset(d, year==2 & condition=="abacus")$arith)
cor.test(subset(d, year==3 & condition=="abacus")$abacus.flashcards,
         subset(d, year==3 & condition=="abacus")$arith)

cor.test(subset(d, year==1 & condition=="abacus")$abacus.sums,
         subset(d, year==1 & condition=="abacus")$arith)
cor.test(subset(d, year==2 & condition=="abacus")$abacus.sums,
         subset(d, year==2 & condition=="abacus")$arith)
cor.test(subset(d, year==3 & condition=="abacus")$abacus.sums,
         subset(d, year==3 & condition=="abacus")$arith)


### MA uptake as a mediator of longitudinal growth

md <- melt(d, 
           id.vars=c("subnum","year","condition","female","age"), 
           measure.vars=c("placeval","abacus.flashcards"))


m1 <- lmer(value ~ year * condition + (year | subnum),
           data=subset(md, year > 0))
m2 <- lmer(value ~ year + condition + (year  | subnum),
           data=subset(md, year > 0))

cor.test(subset(d, year==1 & condition=="abacus")$abacus.sums,
         subset(d, year==1 & condition=="abacus")$wiat)
cor.test(subset(d, year==2 & condition=="abacus")$abacus.sums,
         subset(d, year==2 & condition=="abacus")$wiat)
cor.test(subset(d, year==3 & condition=="abacus")$abacus.sums,
         subset(d, year==3 & condition=="abacus")$wiat)

cor.test(subset(d, year==1 & condition=="abacus")$abacus.sums,
         subset(d, year==1 & condition=="abacus")$woodcock)
cor.test(subset(d, year==2 & condition=="abacus")$abacus.sums,
         subset(d, year==2 & condition=="abacus")$woodcock)
cor.test(subset(d, year==3 & condition=="abacus")$abacus.sums,
         subset(d, year==3 & condition=="abacus")$woodcock)
