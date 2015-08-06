### propensity score matching
rm(list=ls())
source("helper/useful.R")
d <- read.csv("data/zenith all data complete cases.csv")

library(broom)
library(dplyr)
library(tidyr)
library(Matching)

# select y0 data
y0 <- filter(d, year == 0) %>% 
  dplyr::select(subnum, condition, wiat, arith, woodcock, placeval) %>%
  mutate(abacus = condition == "abacus") %>%
  filter(complete.cases(.))

# create the propensity model, predicting intervention
mod <- glm(abacus ~ arith + wiat + woodcock + placeval, data = y0)
f.mod <- fitted(mod) # propensity scores
Y <- y0$arith
Tr <- y0$abacus

resamps <- data.frame()

for (s in 1:1000) {
  # create the matching groups
  rr <- Match(Y=Y, Tr=Tr, X=f.mod, M=1, 
              replace = TRUE, ties = FALSE)
  summary(rr) 
  
  # now reconstruct full dataset
  abacus <- y0$subnum[rr$index.treated]
  cntl <- y0$subnum[rr$index.control]
  
  d.new <- data.frame()
  
  for (y in 0:3) {
    ty <- filter(d, year == y)
    abacus.inds <- sapply(abacus, function(x) {which(ty$subnum==x)})
    cntl.inds <- sapply(cntl, function(x) {which(ty$subnum==x)})
    ny <- ty[c(abacus.inds, cntl.inds), ] 
    d.new <- bind_rows(d.new, ny)
  }
  
  lps <- d.new %>%
    dplyr::select(wiat, woodcock, arith, placeval, year, condition, subnum) %>%
    gather(measure, value, wiat, woodcock, arith, placeval) %>%
    group_by(measure) %>%
    do(data.frame(p = anova(lmer(value ~ year * condition + (year | subnum),
                                 data=.),
                            lmer(value ~ year + condition + (year  | subnum),
                                 data=.))$"Pr(>Chisq)"[2])) %>%
    mutate(sample = s, 
           method = "lmer")
  
  tps <- d.new %>%
    dplyr::select(wiat, woodcock, arith, placeval, year, condition, subnum) %>%
    gather(measure, value, wiat, woodcock, arith, placeval) %>%
    group_by(measure) %>%
    filter(year == 3) %>%
    do(data.frame(p = t.test(.$value[.$condition == "abacus"],
                             .$value[.$condition == "control"])$p.val)) %>%
    mutate(sample = s, 
           method = "t.test")
  
  resamps <- bind_rows(resamps, lps, tps)
}

## summarize
resamps %>% 
  group_by(measure, method) %>%
  summarise(p = mean(p))

