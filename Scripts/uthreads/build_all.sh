#!/bin/bash

Scripts/uthreads/build_thread_test.sh CONTS programs/uthreads/src/pi.c programs/uthreads/wasm/pi
Scripts/uthreads/build_thread_test.sh SWAPCONTEXT programs/uthreads/src/pi.c programs/uthreads/native/pi