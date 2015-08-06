## outcomes figures
rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

plot_style <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        strip.background = element_rect(fill = "white", colour="white"), 
        strip.text = element_text(size=12), 
        axis.line = element_line(size = .5, colour = "black"), 
        panel.border = element_rect(colour="white"))

# math ----------------------------------------------------------------------
tasks <- c("arith","placeval","woodcock","wiat")
titles <- c("Arithmetic","Place Value","Woodcock-Johnson III", "WIAT")

mmd <- reshape2::melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
mms$n <- aggregate(subnum ~ variable + condition + year, mmd, n.unique)$subnum

levels(mms$variable) <- titles
levels(mms$condition) <- c("MA","Control")

qplot(year, value, colour=condition, 
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
                                         label=condition))+ 
  plot_style


# cognitive ----------------------------------------------------------------------
tasks <- c("spatialwm","verbalwm","ans","mental.rot")
titles <-  c("Spatial WM","Verbal WM","Approximate Number","Mental Rotation")

mmd <- reshape2::melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
mms$n <- aggregate(subnum ~ variable + condition + year, mmd, n.unique)$subnum

levels(mms$variable) <- titles
levels(mms$condition) <- c("MA","Control")

# some fanciness here because of different y axes
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
  plot_style

# change the y axis labels manually
g <- ggplotGrob(p)
yax <- which(g$layout$name=="ylab")

# define y-axis labels
g[["grobs"]][[yax]]$label <- c("Mean Items","Mean Items", "Weber Fraction", "Proportion Correct")

# position of labels (ive just manually specified)
g[["grobs"]][[yax]]$y <- grid::unit(c(.75,.75,.25,.25),"npc")
g[["grobs"]][[yax]]$x <- grid::unit(c(.5,.5,.5,.5),"npc")

grid::grid.draw(g)

# academic ----------------------------------------------------------------------
tasks <- c("math","science","english","computer")
titles <-  c("Math","Science","English","Computer")

mmd <- reshape2::melt(d, id.vars=c("subnum","year","condition"), measure.vars=tasks)  
mms <- aggregate(value ~ variable + condition + year, mmd, mean)
mms$ci.l <- aggregate(value ~ variable + condition + year, mmd, ci.low)$value
mms$ci.h <- aggregate(value ~ variable + condition + year, mmd, ci.high)$value
mms$n <- aggregate(subnum ~ variable + condition + year, mmd, n.unique)$subnum

levels(mms$variable) <- titles
levels(mms$condition) <- c("MA","Control")

qplot(year, value, colour=condition, 
      group=condition,label=condition,
      position=position_dodge(width=.05),
      ymin=value-ci.l, ymax=value+ci.h,
      #       xlim=c(-0.05,3.5),
      xlab="Year",ylab="Numeric Grade",
      geom=c("pointrange"),
      ylim=c(50,100),
      data = mms) + 
  geom_line() + 
  facet_wrap(~ variable) +
  scale_colour_manual(name="Condition",values=c("#bdbdbd","#636363")) + 
  plot_style