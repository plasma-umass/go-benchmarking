#!/usr/local/bin/Rscript

library(ggplot2)
library(reshape2)

load('Results/asyncify/results.rda') # loads it to a variable data

mean_data <- apply(data, c(1,3), mean)
sd_data <- apply(data, c(1,3), sd)

mean_data <- melt(mean_data)
sd_data <- melt(sd_data)
names(mean_data) <- c("yield", "Implementation", "Time")
mean_data$yield <- sapply(mean_data$yield, FUN=function(yi) { 2^(yi-1) })
mean_data$sd <- sd_data$value

p <- ggplot(mean_data, aes(y=Time, x=yield, group=Implementation)) + 
  geom_line(aes(color=Implementation)) +
  geom_point(aes(color=Implementation)) +
  # geom_errorbar(aes(ymin=Time-sd, ymax=Time+sd), width=.1) +
  labs(y="Time (s)", x="Iterations/yield") + 
  ggtitle('User-threaded approximation of pi')

ggsave("Results/asyncify/plot.pdf", p)
