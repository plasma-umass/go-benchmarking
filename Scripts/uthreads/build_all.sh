#!/bin/bash

rm -f programs/uthreads/CONTS/*
rm -f programs/uthreads/SWAPCONTEXT/*
rm -f programs/uthreads/PTHREAD/*

for p in programs/uthreads/src/*.c; do
    f=$(basename "$p" .c)
    Scripts/uthreads/build_thread_test.sh CONTS "programs/uthreads/src/$f.c" "programs/uthreads/CONTS/$f"
    Scripts/uthreads/build_thread_test.sh SWAPCONTEXT "programs/uthreads/src/$f.c" "programs/uthreads/SWAPCONTEXT/$f"
    Scripts/uthreads/build_thread_test.sh PTHREAD "programs/uthreads/src/$f.c" "programs/uthreads/PTHREAD/$f"
done
