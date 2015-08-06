rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

ans <- read.csv("data/arith_reana/wgarith_2013_answers.csv")
responses <- read.csv("data/arith_reana/wgarith_2013.csv")

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
