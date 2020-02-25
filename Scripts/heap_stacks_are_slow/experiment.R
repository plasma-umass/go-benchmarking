#!/usr/local/bin/Rscript

args <- commandArgs(trailingOnly=TRUE)
if(length(args) != 2) {
  stop("incorrect args")
}
bench <- args[1]
runtime <- args[2]

samples = 10

data <- read.csv('Results/heap_stacks_are_slow/results.csv', stringsAsFactors=FALSE)

rowIdxs <- intersect(
    which((data['Runtime'] == runtime) | (runtime == 'ALL')), 
    which((data['Benchmark'] == bench) | (bench == 'ALL')))
if (length(rowIdxs) < 1) {
  stop("Experiment not found")
}

#system('Scripts/make_all.sh')

for (rowIdx in rowIdxs) {
  execCommand <- data[rowIdx, 'Exec.command']
  timeCommand <- paste("Scripts/average.sh", samples, execCommand)
  
  print(paste("Running", data[rowIdx, 'Benchmark'], data[rowIdx, 'Runtime']))
  
  t <- system(timeCommand, intern=TRUE)
  data[rowIdx, 'Time'] <- t
}

write.csv(data, file='Results/heap_stacks_are_slow/results.csv', row.names=FALSE, quote=FALSE)
