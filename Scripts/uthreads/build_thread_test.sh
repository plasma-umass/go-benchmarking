#!/bin/bash

impl=$1
in_f=$2
out_f=$3

in_files="-I../emcc_control/tests/libs/libuthread/ $in_f ../emcc_control/tests/libs/libuthread/uthread.c ../emcc_control/tests/libs/libuthread/queue.c ../emcc_control/tests/libs/libuthread/context.c"

if [ "$impl" = "WASMTIME_CONTS" ]; then
    extra_args="../emcc_control/libs/continuations.c -DCONTEXT_IMPL=WASMTIME_CONTS"
    emcc_control $in_files $extra_args $out_f.wat
elif [ "$impl" = "WASMTIME_ASYNCIFY" ]; then
    echo "NOT YET IMPLEMENTED"
elif [ "$impl" = "NATIVE_SWAPCONTEXT" ]; then
    extra_args="-DCONTEXT_IMPL=NATIVE_SWAPCONTEXT -D_XOPEN_SOURCE -Wno-deprecated-declarations -O3"
    clang $in_files $extra_args -o $out_f.out
elif [ "$impl" = "NATIVE_PTHREAD" ]; then
    extra_args="-DCONTEXT_IMPL=NATIVE_PTHREAD -lpthread -O3"
    clang $in_files $extra_args -o $out_f.out
elif [ "$impl" = "NATIVE_SERIAL" ]; then
    extra_args="-DCONTEXT_IMPL=NATIVE_SERIAL -O3"
    clang $in_files $extra_args -o $out_f.out
elif [ "$impl" = "WASMTIME_SERIAL" ]; then
    extra_args="-DCONTEXT_IMPL=WASMTIME_SERIAL"
    emcc_control $in_files $extra_args $out_f.wat
fi