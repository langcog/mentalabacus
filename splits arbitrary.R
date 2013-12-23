rm(list=ls())
source("~/Projects/R/mcf.useful.R")
d <- read.csv("~/Projects/India Abacus/ZENITH/zenith full analysis/data/zenith all data complete cases.csv")

tasks <- c("arith","woodcock","wiat","placeval")
splits <- c("spatialwm","verbalwm","ans","mental.rot")

for (t in tasks) {  
  # models
  for (s in splits) {
    md <- melt(d, id.vars=c("subnum","year","condition",splits), measure.vars=t) 
    
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
