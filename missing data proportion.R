library(dplyr)
library(tidyr)
rm(list=ls())

d <- read.csv("~/Projects/Abacus/ZENITH/mentalabacus/data/zenith all data complete cases.csv")

d %>% 
  select(-english, -math, science, -computer, -music, 
         -art, -phys.ed, -attendance, -completed, -wholegroupsums, -class) %>%
  gather(measure, value, placeval, wiat, woodcock, arith, 
         ravens, verbalwm, spatialwm, ans, mental.rot)