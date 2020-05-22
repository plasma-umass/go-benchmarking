#!/bin/bash

impl=$1
in_f=$2
out_f=$3

in_files="-I../emcc_control/tests/libs/libuthread/ $in_f ../emcc_control/tests/libs/libuthread/uthread.c ../emcc_control/tests/libs/libuthread/queue.c ../emcc_control/tests/libs/libuthread/context.c"

if [ "$impl" = "CONTS" ]; then
    extra_args="../emcc_control/libs/continuations.c -DCONTEXT_IMPL=CONTS"
    emcc_control $in_files $extra_args "$out_f.wat"
elif [ "$impl" = "ASYNCIFY" ]; then
    echo "NOT YET IMPLEMENTED"
elif [ "$impl" = "SWAPCONTEXT" ]; then
    extra_args="-DCONTEXT_IMPL=SWAPCONTEXT -D_XOPEN_SOURCE -Wno-deprecated-declarations -O3"
    clang $in_files $extra_args -o $out_f.out
fi