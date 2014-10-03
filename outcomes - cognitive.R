## MATH OUTCOMES ANALYSES
rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

tasks <- c("spatialwm","verbalwm","ans","mental.rot")
titles <-  c("Spatial WM","Verbal WM","Approximate Number","Mental Rotation")

mmd <- melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
mms$n <- aggregate(subnum ~ variable + condition + year, mmd, n.unique)$subnum

levels(mms$variable) <- titles
levels(mms$condition) <- c("MA","Control")

pdf("figures/cognitive outcomes.pdf",
    width=7,height=6)
p <- qplot(year, value, colour=condition, 
      group=condition,label=condition,
      position=position_dodge(width=.05),
      ymin=value-ci.l, ymax=value+ci.h,
      xlab="Year",ylab="Proportion Correct",
      geom=c("pointrange"),
      data = mms) + 
  geom_line() + 
  facet_wrap(~ variable , scales="free") +
  scale_colour_manual(name="Condition",values=c("#bdbdbd","#636363")) + 
  guides(colour=FALSE, label=FALSE) +
  geom_text(data=subset(mms,year==2), aes(x=year,y=value*c(1.1,.9),
                                          label=condition)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        strip.background = element_rect(fill = "white", colour="white"), 
        strip.text = element_text(size=12), 
        axis.line = element_line(size = .5, colour = "black"), 
        panel.border = element_rect(colour="white"))

# change the y axis labels manually
g <- ggplotGrob(p)
yax <- which(g$layout$name=="ylab")

# define y-axis labels
g[["grobs"]][[yax]]$label <- c("Mean Items","Mean Items", "Weber Fraction", "Proportion Correct")

# position of labels (ive just manually specified)
g[["grobs"]][[yax]]$y <- grid::unit(c(.75,.75,.25,.25),"npc")
g[["grobs"]][[yax]]$x <- grid::unit(c(.5,.5,.5,.5),"npc")

grid::grid.draw(g)

dev.off()

## t-tests for Raven's
t.test(d$ravens[d$year==0 & d$abacus==0],
       d$ravens[d$year==0 & d$abacus==1])

t.test(d$ravens[d$year==1 & d$abacus==0],
       d$ravens[d$year==1 & d$abacus==1])

t.test(d$ravens[d$year==2 & d$abacus==0],
       d$ravens[d$year==2 & d$abacus==1])

t.test(d$ravens[d$year==3 & d$abacus==0],
       d$ravens[d$year==3 & d$abacus==1])