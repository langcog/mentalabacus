mentalabacus
============

Analyses and data for mental abacus longitudinal study. Relates to Barner et al. (submitted), Learning mathematics in a visuospatial format: A randomized, controlled trial of mental abacus instruction.

This repository contains all of the analysis scripts for the entire project, including some exploratory visualizations and control analyses that did not make it into the final paper. 

To recreate our dataset, start with `0-preprocessing.R` and then run `1-preprocessing exclusions.R`. Scripts beginning with `2-` are main-text analyses for the most part; those beginning with `3-` are analyses that are in the supplemental information (though some computations in SI are also in the `2-` analyses (e.g., the academic outcomes are in `2-outcome plots.R`. In the directory `other analysis`, you can find other explorations - use at your own risk (some may be broken).

This code was written over a 3+ year period. in the beginning, `reshape`,`reshape2`, and `plyr` packages were used; at the end, `tidyr` and `dplyr`. The idiom also migrates around a bit (`aggregate` was a favorite before I discovered the `*plyr` family). I have worked to decrease inconsistency, but I haven't rewritten all of the code, so there could be some package conflicts if you try to execute all the scripts one after another (especially the `4-`s). 