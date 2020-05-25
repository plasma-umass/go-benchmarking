#!/bin/bash
f=$1
impl=$2
shift 2
args=$@

if [ "$impl" = "WASMTIME_CONTS" ]; then
    wasmtime programs/uthreads/WASMTIME_CONTS/$f.wat $args
elif [ "$impl" = "WASMTIME_ASYNCIFY" ]; then
    echo "NOT YET IMPLEMENTED"
elif [ "$impl" = "NATIVE_SWAPCONTEXT" ]; then
    programs/uthreads/NATIVE_SWAPCONTEXT/$f.out $args
elif [ "$impl" = "NATIVE_PTHREAD" ]; then
    programs/uthreads/NATIVE_PTHREAD/$f.out $args
fi
