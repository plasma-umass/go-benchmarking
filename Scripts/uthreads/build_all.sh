#!/bin/bash

rm -f programs/uthreads/wasm/*
rm -f programs/uthreads/native/*

for p in programs/uthreads/src/*.c; do
    f=$(basename "$p" .c)
    Scripts/uthreads/build_thread_test.sh CONTS "programs/uthreads/src/$f.c" "programs/uthreads/wasm/$f"
    Scripts/uthreads/build_thread_test.sh SWAPCONTEXT "programs/uthreads/src/$f.c" "programs/uthreads/native/$f"
done
