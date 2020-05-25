#!/bin/bash
f=$1
impl=$2
shift 2
args=$@

if [[ "$impl" == *"WASMTIME"* ]]; then
    wasmtime programs/uthreads/$impl/$f.wat $args
else
    programs/uthreads/$impl/$f.out $args
fi

