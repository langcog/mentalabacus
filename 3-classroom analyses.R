## class effect plots and models
rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

## CLASSROOM EFFECT PLOTS ----------------------------------------
tasks <- list()
tasks[[1]] <- c("arith","woodcock")
tasks[[2]] <- c("placeval","wiat")
tasks[[3]] <- c("spatialwm","verbalwm")
tasks[[4]] <- c("ans","mental.rot")

titles <- list()
titles[[1]] <- c("Arithmetic","Woodcock-Johnson III")
titles[[2]] <- c("Place Value","WIAT")
titles[[3]] <- c("Spatial WM","Verbal WM")
titles[[4]] <- c("Weber Fraction","Mental Rotation")

scales <- list()
scales[[1]] <- c(0,.5)
scales[[2]] <- c(0,1)
scales[[3]] <- c(2,5)
scales[[4]] <- c(0,1)

for (t in 1:4) {
  mmd <- reshape2::melt(d, id.vars=c("subnum","year","condition","class"), measure.vars=tasks[[t]])  
  mms <- mmd %>%
    group_by(variable,condition,year,class) %>%
    summarise(m = mean(value, na.rm=TRUE), 
               ci.l = ci.low(value), 
               ci.h = ci.high(value), 
               n = n.unique(subnum))
  
  levels(mms$variable) <- titles[[t]]
  
  p <- qplot(year, m, colour=interaction(condition,class), 
        group=interaction(condition,class),
        position=position_dodge(width=.1),
        ymin=m - ci.l, ymax=m + ci.h,
        ylim=scales[[t]],                  
        xlab="Year",ylab="Performance",
        geom=c("pointrange"),
        facets = . ~ variable, 
        data = subset(mms,
                      (condition=="abacus" & class=="A") | 
                        (class=="B") |
                        (condition=="control" & class=="C"))) + 
    geom_line() + 
    facet_grid(variable ~ ., scale="free_y") + 
    scale_colour_discrete(name="Condition/Class")
  print(p)
}

## REGRESSION MODELS BY TASK WITH CLASS ----------------------------------------
# only including tasks that we think are likely to have any appreciable class effect
tasks <- c("wiat","woodcock","arith","placeval",
           "spatialwm","verbalwm","mental.rot","math")

tnames <- c("WIAT","WJ-III","Arithmetic Task","Place Value Task",
            "Spatial Working Memory","Verbal Working Memory","Mental Rotation","Math Grades")

d$condition <- factor(d$condition, levels=c("control","abacus"))

### LINEAR
for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","class","condition","female","age"), measure.vars=t)
  
  m1 <- lmer(value ~ year * condition * class + (year | subnum),
             data=md)
  m2 <- lmer(value ~ year * condition + class + (year  | subnum),
             data=md)
  
  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
}

### QUADRATIC
for (t in tasks) {
  md <- melt(d, id.vars=c("subnum","year","condition","class","female","age"), measure.vars=t)
  md$year2 <- md$year^2
  
  m1 <- lmer(value ~ year * condition * class + year2 * condition * class + 
               (year + year2 | subnum),
             data=md)
  m2 <- lmer(value ~ year * condition + year2 * condition + class + 
               (year + year2 | subnum),
             data=md)
  print(paste("*********",t,"**********"))
  print(anova(m1,m2))
}


