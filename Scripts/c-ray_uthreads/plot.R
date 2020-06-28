#!/usr/bin/env Rscript

require(dplyr)
require(ggplot2)
require(scales)

load("Results/c-ray_uthreads/results.rda")

p <- df %>% ggplot(aes(x=test, fill=impl, y=time_mean)) +
  geom_col(position=position_dodge()) +
  geom_errorbar(aes(ymin=time_mean-time_sd, ymax=time_mean+time_sd), 
                width=.1, position=position_dodge(.9)) +
  labs(y="Time (s)", x="Benchmark") +
  facet_wrap(~yield_every, ncol=3, scales="free")

ggsave("Results/c-ray_uthreads/c-ray_uthreads.pdf", p)


p <- df %>% ggplot(aes(y=time_mean, x=yield_every, group=impl)) + 
  geom_line(aes(color=impl)) +
  geom_point(aes(color=impl, shape=impl)) +
  # geom_errorbar(aes(ymin=Time-sd, ymax=Time+sd, color=Implementation)) +
  labs(y="Time (s)", x="Iterations/yield") +
  # ylim(0, 10) +
  xlim(2^4, 2^15) +
  scale_x_continuous(trans='log2', labels = trans_format("log2", math_format(2^.x)), breaks = trans_breaks("log2", function(x) 2^x))

  # theme(plot.margin=grid::unit(c(0,0,0,0), "mm")) +
  # scale_color_hue(labels=c("asyncify", "[INSERT NAME]")) +
  # coord_fixed(ratio=2/3); 

ggsave("Results/c-ray_uthreads/c-ray_uthreads2.pdf", p)
