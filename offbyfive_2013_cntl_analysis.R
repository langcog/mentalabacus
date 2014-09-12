rm(list=ls())
source("~/Projects/R/Ranalysis/useful.R")

ans <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/arith_reana/wgarith_2013_answers.csv")
responses <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/arith_reana/wgarith_2013.csv")

melt.responses <- melt(responses, id.vars=c("subnum","abacus"), variable.name="problem", value.name="response")
d <- merge(md, ans)

# now score responses
d$correct <- d$response == d$answer

off.by.five <- function (x,y) {
  ## in case of NAs
  if (is.na(x)) { 
    return(NA) 
  }
  
  ## otherwise
  if (abs(x - y) == 5 |
        abs(x - y) == 50 |
      abs(x - y) == 500 | 
        abs(x - y) == 5000) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

d$off.by.five <- mapply(off.by.five, d$response, d$answer)
