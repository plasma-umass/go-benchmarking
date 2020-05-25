#!/bin/bash

rm -f programs/uthreads/WASMTIME_CONTS/*
rm -f programs/uthreads/NATIVE_SWAPCONTEXT/*
rm -f programs/uthreads/NATIVE_PTHREAD/*

mkdir -p programs/uthreads/WASMTIME_CONTS/
mkdir -p programs/uthreads/NATIVE_SWAPCONTEXT/
mkdir -p programs/uthreads/NATIVE_PTHREAD/

for p in programs/uthreads/src/*.c; do
    f=$(basename "$p" .c)
    Scripts/uthreads/build_thread_test.sh WASMTIME_CONTS "programs/uthreads/src/$f.c" "programs/uthreads/WASMTIME_CONTS/$f"
    Scripts/uthreads/build_thread_test.sh NATIVE_SWAPCONTEXT "programs/uthreads/src/$f.c" "programs/uthreads/NATIVE_SWAPCONTEXT/$f"
    Scripts/uthreads/build_thread_test.sh NATIVE_PTHREAD "programs/uthreads/src/$f.c" "programs/uthreads/NATIVE_PTHREAD/$f"
done
