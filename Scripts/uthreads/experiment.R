#!/usr/bin/env Rscript

num_terms_log2 <- 22
term_per_yield_log2 <- 0
samples <- 3  # 10


sys_dt <- function(cmd) {
  start_t <- Sys.time()
  system(cmd)
  end_t <- Sys.time()
  return(end_t - start_t)
}


tests <- sub('\\.c$', '', list.files("programs/uthreads/src/"))
impls <- c("NATIVE_SWAPCONTEXT", "NATIVE_PTHREAD", "WASMTIME_CONTS", "NATIVE_SERIAL", "WASMTIME_SERIAL")
df <- data.frame(
  "test"=character(), 
  "impl"=factor(character(), levels=impls), 
  "num_terms_log2"=numeric(), 
  "terms_per_yield_log2"=numeric(), 
  "time_mean"=numeric(), 
  "time_sd"=numeric(), 
  stringsAsFactors=FALSE
)

# Build all tests
system("Scripts/uthreads/build_all.sh")

for(test in tests) {
  for(impl in impls) {
    print(paste("Running ", test, "+", impl, " with yield every 2^", term_per_yield_log2, " iterations, ", samples, " samples", sep=""))
    dts <- rep(0, samples)
    for(s in 1:samples) {
      dts[s] <- sys_dt(paste('Scripts/uthreads/run_test.sh', test, impl, num_terms_log2, term_per_yield_log2))
    }
    df[nrow(df)+1,] <- list(test, impl, num_terms_log2, term_per_yield_log2, mean(dts), sd(dts))
  }
}

print(df)
save(df, file="Results/uthreads/results.rda")
