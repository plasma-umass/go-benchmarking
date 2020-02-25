# Go Benchmarking Experiments

## Setup

- Make sure `toy-wasm` is cloned in a sibling directory to this directory.
- Make sure emscripten is installed
- Add the following line to `~/.bashrc`: `alias emsdk_setup="source /path/to/emsdk_env.sh"`

## Running Experiments

Running an experiment is a 3 step process:

1. Build all of the code to be benchmarked, across all configurations: `Scripts/make_all.sh`
2. Run the experiment: `Scripts/heap_stacks_are_slow/experiment.R ALL ALL`. After this, `Results/heap_stacks_are_slow/results.csv` will automatically be updated
3. Plot the results: `Scripts/heap_stacks_are_slow/plot.R`. The plot is in `Results/heap_stacks_are_slow/plot.pdf`.
