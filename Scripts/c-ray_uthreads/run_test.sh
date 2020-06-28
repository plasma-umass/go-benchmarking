#!/bin/bash
impl="$1"
yield_every="$2"
yield_us="$3"
shift 3
args=$@

cd ../c-ray/
wasmtime --dir=. --env=YIELD_EVERY="$yield_every" --env=YIELD_US="$yield_us" builds/$impl/c-ray.wat $args

