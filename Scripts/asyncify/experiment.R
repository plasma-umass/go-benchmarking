#!/usr/local/bin/Rscript

max_n <- 22    # 22
samples <- 10  # 10


sys_dt <- function(cmd) {
  start_t <- Sys.time()
  system(cmd)
  end_t <- Sys.time()
  return(end_t - start_t)
}



data <- array(0, dim=c(max_n+1, samples, 2), dimnames=list(NULL, NULL, list('asyncify', 'conts')))

# Want to include n = 0, ..., 22
for(n in 0:max_n) {
  
  system(paste('python3 Scripts/asyncify/prepare_wat.py programs/wasm/asyncify_thread2.watt', n, "> asyncify2_sub.wat"))
  system('wasm-opt asyncify2_sub.wat -O --asyncify --print > asyncify2_runnable.wat')
  system(paste('python3 Scripts/asyncify/prepare_wat.py programs/wasm/conts_thread.watt', n, "> conts_runnable.wat"))
  
  print(paste("Running with yield every 2^", n, " iterations, ", samples, " samples", sep=""))
  for(s in 1:samples) {
    conts_dt <- sys_dt('/Users/donaldpinckney/.cargo/bin/wasmtime conts_runnable.wat --invoke the_main')
    asyncify_dt <- sys_dt('/Users/donaldpinckney/.cargo/bin/wasmtime asyncify2_runnable.wat --invoke runtime')
    
    data[n+1,s,'asyncify'] <- asyncify_dt
    data[n+1,s,'conts'] <- conts_dt
  }
}

print(data)
save(data, file="Results/asyncify/results.rda")
