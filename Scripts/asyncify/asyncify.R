#!/usr/bin/env Rscript

library(ggplot2)
library(reshape2)
library(scales)

load('Results/asyncify/results.rda') # loads it to a variable: data

mean_data <- apply(data, c(1,3), mean)
sd_data <- apply(data, c(1,3), sd)

mean_data <- melt(mean_data)
sd_data <- melt(sd_data)
names(mean_data) <- c("yield", "Implementation", "Time")
mean_data$yield <- sapply(mean_data$yield, FUN=function(yi) { 2^(yi-1) })
mean_data$sd <- sd_data$value

levels(mean_data$Implementation) <- c("Asyncify", "[INSERT NAME]")

p <- ggplot(mean_data, aes(y=Time, x=yield, group=Implementation)) + 
  geom_line(aes(color=Implementation)) +
  geom_point(aes(color=Implementation, shape=Implementation)) +
  # geom_errorbar(aes(ymin=Time-sd, ymax=Time+sd, color=Implementation)) +
  labs(y="Time (s)", x="Iterations/yield") + 
  ylim(0, 25) +
  scale_x_continuous(trans='log2', 
                    breaks = trans_breaks("log2", function(x) 2^x),
                    labels = trans_format("log2", math_format(2^.x))
                    ) +
  # theme(plot.margin=grid::unit(c(0,0,0,0), "mm")) +
  # scale_color_hue(labels=c("asyncify", "[INSERT NAME]")) +
  coord_fixed(ratio=2/3); 

ggsave("Results/asyncify/plot.pdf", p)

