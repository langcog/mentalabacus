## median splits - see bottom for arbitrary split models
rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

### FIGURE FOR SPATIAL WM ------------------------------------------------------
t <- "spatialwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,t] > median(subset(d,year==0)[,t],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

md <- reshape2::melt(d, id.vars=c("subnum","year","condition","hi.split"), 
           measure.vars="arith") 
ms <- md %>% 
  group_by(variable, condition, year, hi.split) %>%
  summarise(m.value = mean(value, na.rm=TRUE), 
            ci.l = ci.low(value), 
            ci.h = ci.high(value), 
            n = n.unique(value))

ms$hi.split <- factor(c("Low","High")[as.numeric(ms$hi.split)+1],
                     levels=c("Low","High"))

levels(ms$condition) <- c("MA","Control")

qplot(year, m.value, colour=condition,linetype=hi.split, 
           position=position_dodge(width=.1),
           ymin=m.value-ci.l, ymax=m.value+ci.h,
           xlab="Year",ylab="Arithmetic Performance",
           geom=c("pointrange"),
           data = ms) + 
  geom_line() +
  scale_linetype_discrete(name="Spatial WM") + 
  scale_colour_discrete(name="Condition") 

### FIGURE FOR VERBAL WM / ARITH------------------------------------------------------
t <- "verbalwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,t] > median(subset(d,year==0)[,t],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

md <- reshape2::melt(d, id.vars=c("subnum","year","condition","hi.split"), 
                     measure.vars="arith") 
ms <- md %>% 
  group_by(variable, condition, year, hi.split) %>%
  summarise(m.value = mean(value, na.rm=TRUE), 
            ci.l = ci.low(value), 
            ci.h = ci.high(value), 
            n = n.unique(value))

ms$hi.split <- factor(c("Low","High")[as.numeric(ms$hi.split)+1],
                      levels=c("Low","High"))

levels(ms$condition) <- c("MA","Control")

qplot(year, m.value, colour=condition,linetype=hi.split, 
      position=position_dodge(width=.1),
      ymin=m.value-ci.l, ymax=m.value+ci.h,
      xlab="Year",ylab="Arithmetic Performance",
      geom=c("pointrange"),
      data = ms) + 
  geom_line() +
  scale_linetype_discrete(name="Verbal WM") + 
  scale_colour_discrete(name="Condition") 

### FIGURE FOR SPATIAL WM / WJ-III  ------------------------------------------------------
t <- "spatialwm"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,t] > median(subset(d,year==0)[,t],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

md <- reshape2::melt(d, id.vars=c("subnum","year","condition","hi.split"), measure.vars="woodcock") 
ms <- aggregate(value ~ variable + condition + year + hi.split, md, mean)

ms$ci.l <- aggregate(value ~ variable + condition + year + hi.split, 
                     md, ci.low)$value
ms$ci.h <- aggregate(value ~ variable + condition + year + hi.split, 
                     md, ci.high)$value
ms$n <- aggregate(value ~ variable + condition + year + hi.split, 
                  md, n.unique)$value
ms$hi.split <- factor(c("Low","High")[as.numeric(ms$hi.split)+1],
                      levels=c("Low","High"))
levels(ms$condition) <- c("MA","Control")

qplot(year, value, colour=condition,linetype=hi.split, 
      position=position_dodge(width=.1),
      ymin=value-ci.l, ymax=value+ci.h,
      xlab="Year",ylab="WJ-III Performance",
      geom=c("pointrange"),
      data = ms) + 
  geom_line() +
  scale_linetype_discrete(name="Spatial WM") + 
  scale_colour_discrete(name="Condition") 

### FIGURE FOR ANS / WJ-III ------------------------------------------------------
t <- "ans"
hi.subs <- subset(unique(d$subnum),
                  subset(d,year==0)[,t] > median(subset(d,year==0)[,t],na.rm=TRUE))
d$hi.split <- d$subnum %in% hi.subs

md <- reshape2::melt(d, id.vars=c("subnum","year","condition","hi.split"), measure.vars="woodcock") 
ms <- aggregate(value ~ variable + condition + year + hi.split, md, mean)

ms$ci.l <- aggregate(value ~ variable + condition + year + hi.split, 
                     md, ci.low)$value
ms$ci.h <- aggregate(value ~ variable + condition + year + hi.split, 
                     md, ci.high)$value
ms$n <- aggregate(value ~ variable + condition + year + hi.split, 
                  md, n.unique)$value
ms$hi.split <- factor(c("Low","High")[as.numeric(ms$hi.split)+1],
                      levels=c("Low","High"))
levels(ms$condition) <- c("MA","Control")

qplot(year, value, colour=condition,linetype=hi.split, 
      position=position_dodge(width=.1),
      ymin=value-ci.l, ymax=value+ci.h,
      xlab="Year",ylab="WJ-III Performance",
      geom=c("pointrange"),
      data = ms) + 
  geom_line() +
  scale_linetype_discrete(name="Weber Fraction") + 
  scale_colour_discrete(name="Condition") 

### ARBITRARY TASK SPLITS ------------------------------------------------------
tasks <- c("arith","woodcock","wiat","placeval")
splits <- c("spatialwm","verbalwm","ans","mental.rot")

for (t in tasks) {  
  # models
  for (s in splits) {
    md <- reshape2::melt(d, id.vars=c("subnum","year","condition",splits), 
                         measure.vars=t) 
    
    split.measure <- subset(md,year==0)[,s]
    hi.splits <- subset(md,year==0)$subnum[split.measure > median(split.measure,na.rm=TRUE)]
    md$hi.split <- md$subnum %in% hi.splits
    year0 <- subset(md,year==0)[,c("subnum",s)]
    names(year0) <- c("subnum","split.var")
    md <- merge(md,year0,by.x="subnum",by.y="subnum")
    
    ## linear
    m1 <- lmer(value ~ year * condition * hi.split +
                 (year | subnum),
               data=md)
    m2 <- lmer(value ~ (year * condition * hi.split) - year:condition:hi.split + 
                 (year | subnum),
               data=md)
    print(paste("*********",t,s,"linear median **********"))
    print(anova(m1,m2))
    
    ## quadratic
    md$year2 <- md$year^2
    m1 <- lmer(value ~ year * condition * hi.split + year2 * condition * hi.split + 
                 (year + year2 | subnum),
               data=md)
    m2 <- lmer(value ~ year * condition * hi.split + year2 * condition * hi.split -
                 year:condition:hi.split - year2:condition:hi.split +
                 (year + year2 | subnum),
               data=md)
    print(paste("*********",t,s,"quadratic median **********"))
    print(anova(m1,m2))
  }
}
