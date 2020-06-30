#!/usr/bin/env Rscript

require(dplyr)
require(ggplot2)
require(scales)

load("Results/c-ray_uthreads/results.rda")

# Rename columns
# df <- df %>% rename(Implemention =)

# Remove stormtroopers since we accidentally used 1 thread only
df <- df %>% filter(test != "input/stormtroopers.json")

# Rename things
df <- df %>% mutate(impl=recode(impl, serial="Serial", conts="Wasm/k", asyncify="Asyncify"))

# Bar plot yield_every
bar_yield_every <- 1024
df_bar <- df %>% filter(yield_every == bar_yield_every) %>% select(-yield_every)
df_bar_serial <- df_bar %>% filter(impl == "Serial")

# df_bar$time_rel_mean <- rep(0, nrow(df_bar))
# for (row in 1:nrow(df_bar)) {
#   time_mean <- df_bar$time_mean[row]
#   test <- df_bar$test[row]
#   df_bar$time_rel_mean[row] <- time_mean / df_bar_serial$time_mean[df_bar_serial$test == test]
# }

# df_bar$time_mean / df_bar[df_bar$test == ]

p<- df_bar %>% ggplot(aes(x=test, fill=impl, y=time_mean)) +
  geom_col(position=position_dodge()) +
  geom_errorbar(aes(ymin=time_mean-time_sd, ymax=time_mean+time_sd), 
                width=.1, position=position_dodge(.9)) +
  labs(y="Time (s)", x="Benchmark", fill="Implementation")

ggsave("Results/c-ray_uthreads/c-ray_uthreads_scenes.pdf", p)


# load("Results/c-ray_uthreads/results.rda")

df_line <- df %>% filter(test == "input/hdr.json")

p <- df %>% filter(test == "input/refraction.json") %>% ggplot(aes(y=time_mean, x=yield_every, group=impl)) + 
  geom_line(aes(color=impl)) +
  geom_point(aes(color=impl, shape=impl)) +
  # geom_errorbar(aes(ymin=Time-sd, ymax=Time+sd, color=Implementation)) +
  labs(y="Time (s)", x="Iterations/yield", color="Implementation", shape="Implementation") +
  # ylim(0, 10) +
  # xlim(2^4, 2^15) +
  scale_x_continuous(trans='log2', labels = trans_format("log2", math_format(2^.x)), breaks = trans_breaks("log2", function(x) 2^x))

  # theme(plot.margin=grid::unit(c(0,0,0,0), "mm")) +
  # scale_color_hue(labels=c("asyncify", "[INSERT NAME]")) +
  # coord_fixed(ratio=2/3); 

ggsave("Results/c-ray_uthreads/c-ray_uthreads.pdf", p)
