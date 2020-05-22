#!/bin/bash
f=$1
impl=$2
shift 2
args=$@

if [ "$impl" = "CONTS" ]; then
    wasmtime programs/uthreads/CONTS/$f.wat $args
elif [ "$impl" = "ASYNCIFY" ]; then
    echo "NOT YET IMPLEMENTED"
elif [ "$impl" = "SWAPCONTEXT" ]; then
    programs/uthreads/SWAPCONTEXT/$f.out $args
fi
