#!/usr/bin/env Rscript

# terms_per_yield_log2 <- c(0, 1, 2, 3, 16)
yield_every <- c(1024)
samples <- 6  # 10


sys_dt <- function(cmd) {
  # print(cmd)
  # return(0)

  start_t <- Sys.time()
  system(cmd)
  end_t <- Sys.time()
  return(end_t - start_t)
}


tests <- c('input/scene.json', 'input/refraction.json', 'input/fence.json')

impls <- c("serial", "conts", "asyncify")
df <- data.frame(
  "test"=character(), 
  "impl"=factor(character(), levels=impls), 
  "yield_every"=numeric(), 
  "time_mean"=numeric(), 
  "time_sd"=numeric(), 
  stringsAsFactors=FALSE
)

# Build all tests
# system("Scripts/uthreads/build_all.sh")

for(test in tests) {

  for(impl in impls) {
    for(ye in yield_every) {
      print(paste("Running ", test, "+", impl, " with yield every ", ye, " calls, ", samples, " samples", sep=""))
      dts <- rep(0, samples)
      for(s in 1:samples) {
        dts[s] <- sys_dt(paste('Scripts/c-ray_uthreads/run_test.sh', impl, ye, 0, test))
      }
      df[nrow(df)+1,] <- list(test, impl, ye, mean(dts), sd(dts))
    }
  }
}

print(df)
save(df, file="Results/c-ray_uthreads/scenes_results.rda")
