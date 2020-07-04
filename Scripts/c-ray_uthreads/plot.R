#!/usr/bin/env Rscript

require(dplyr)
require(ggplot2)
require(scales)

gmean <- function(x) { exp(mean(log(x))) }
combine_sd <- function(x) { sqrt(sum(x*x)) }

load("Results/c-ray_uthreads/results.rda")

# Remove stormtroopers since we accidentally used 1 thread only
df <- df %>% filter(test != "input/stormtroopers.json")

# Rename things
df <- df %>% mutate(impl=recode(impl, serial="Serial", conts="Wasm/k", asyncify="Asyncify"))

# Compute baseline mean
df_baseline <- df %>% filter(impl=="Serial") %>% group_by(test) %>% summarize(baseline=mean(time_mean))

get_baseline <- function(ts) {
  bs <- lapply(ts, function(t) {
    df_baseline %>% filter(test == t) %>% select(baseline)
  })
  return(unlist(bs))
}

df <- df %>% group_by(test) %>% mutate(baseline_relative_mean=time_mean / get_baseline(test),
                                       baseline_relative_sd=time_sd / get_baseline(test))
df <- df %>% filter(impl != "Serial")

# Bar plot yield_every
bar_yield_every <- 1024
df_bar <- df %>% filter(yield_every == bar_yield_every)
df_bar <- df_bar %>% select(-c(yield_every,time_mean,time_sd))
df_bar_gmean <- df_bar %>% group_by(impl) %>% summarize(baseline_relative_sd=combine_sd(baseline_relative_sd), test="Geom Mean", baseline_relative_mean = gmean(baseline_relative_mean))
asyncify_1024_slowdown <- df_bar_gmean %>% filter(impl=="Asyncify") %>% select(baseline_relative_mean) /
  df_bar_gmean %>% filter(impl=="Wasm/k") %>% select(baseline_relative_mean)
print(paste("At a yield rate of 1024, Asyncify is ", asyncify_1024_slowdown, "x slower than Wasm/k"))
df_bar <- bind_rows(df_bar, df_bar_gmean)
p <- df_bar %>% ggplot(aes(x=test, fill=impl, y=baseline_relative_mean)) +
  geom_col(position=position_dodge()) +
  geom_errorbar(aes(ymin=baseline_relative_mean-baseline_relative_sd, ymax=baseline_relative_mean+baseline_relative_sd), 
                width=.1, position=position_dodge(.9)) +
  labs(y="Relative Time (Serial = 1.0)", x="Benchmark", fill="Implementation") +
  geom_hline(yintercept=1) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 30, hjust=1),
    legend.position = "top") +
  scale_fill_manual(values=c("#ff9966", "#6699ff")) +
  ylim(0, 1.5)
print(p)

ggsave("Results/c-ray_uthreads/c-ray_uthreads_scenes.pdf", width=3.5, height=4)

df_line <- df %>% group_by(impl, yield_every) %>% summarize(
  baseline_relative_sd=combine_sd(baseline_relative_sd), 
  baseline_relative_mean = gmean(baseline_relative_mean))

ticks <- c(df_line %>% ungroup() %>% select(yield_every) %>% distinct())$yield_every
p <- df_line %>% ggplot(aes(
    y=baseline_relative_mean, 
    x=yield_every, 
    group=impl, 
    color=impl, 
    shape=impl)) + 
  geom_line() +
  geom_point() +
  geom_hline(yintercept=1) +
  # geom_ribbon(aes(
  #   ymin=baseline_relative_mean-10*baseline_relative_sd, 
  #   ymax=baseline_relative_mean+10*baseline_relative_sd, 
  #   fill=impl, alpha=0.2)) +
  labs(y="Relative Time Geom Mean (Serial = 1.0)", x="Iterations/yield", color="Implementation", shape="Implementation") +
  scale_x_continuous(
    trans='log2',
    labels = trans_format("log2", math_format(2^.x)),
    breaks = ticks) +
    # breaks = trans_breaks("log2", function(x) 2^x)) +
  ylim(0, 3.5) +
  theme_bw() +
  theme(legend.position = "top") +
  scale_fill_manual(values=c("#ff9966", "#6699ff")) +
  scale_color_manual(values=c("#ff9966", "#6699ff"))

print(p)

ggsave("Results/c-ray_uthreads/c-ray_uthreads.pdf", p, width=3.5, height=4)
