#!/usr/bin/env Rscript

require(dplyr)
require(ggplot2)

load("Results/uthreads/results.rda")

p <- df %>% filter(!(impl %in% c("NATIVE_SWAPCONTEXT"))) %>% ggplot(aes(x=test, fill=impl, y=time_mean)) +
  geom_col(position=position_dodge()) +
  geom_errorbar(aes(ymin=time_mean-time_sd, ymax=time_mean+time_sd), 
                width=.1, position=position_dodge(.9)) +
  labs(y="Time (s)", x="Benchmark") +
  facet_wrap(~terms_per_yield_log2, ncol=3, scales="free")

ggsave("Results/uthreads/uthreads.pdf", p)
