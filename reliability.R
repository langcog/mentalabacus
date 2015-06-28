rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")

ans <- read.csv("data/arith_reana/wgarith_2013_answers.csv")
responses <- read.csv("data/arith_reana/wgarith_2013.csv")

melt.responses <- melt(responses, id.vars=c("subnum","abacus"), variable.name="problem", value.name="response")
d <- merge(melt.responses, ans)

# now score responses
d$correct <- d$response == d$answer

split.cor <- function (x) {
  xs <- as.numeric(x[!is.na(x)])
  print(xs)
  r <- cor(xs[seq(1,length(xs),2),
              seq(2,length(xs),2)],
           method="spearman")
  return(r)}

rs <- ddply(d, .(subnum), summarise, 
            r = split.cor(correct))