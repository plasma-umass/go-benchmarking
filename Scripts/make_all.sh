#!/bin/bash

pushd() { builtin pushd $1 > /dev/null; }
popd() { builtin popd > /dev/null; }

cd programs/

wd=$(pwd)
export GOPATH="$wd/go"

# Clean everything
rm -rf go/bin/*
rm -rf go/native/*
rm -rf go/wasm/*
rm -rf c/native/*
rm -rf c/wasm/*
rm -rf toy/wasm/
rm -rf toy/wasm_heap_stack

# Make sure desination directories exist
mkdir -p go/native
mkdir -p go/wasm
mkdir -p c/native/O3
mkdir -p c/native/O0
mkdir -p c/wasm/O3
mkdir -p c/wasm/O0
mkdir -p toy/wasm/O
mkdir -p toy/wasm/O0
mkdir -p toy/wasm_heap_stack/O
mkdir -p toy/wasm_heap_stack/O0


# Pull in emcc
source ~/random_deps/emsdk/emsdk_env.sh > /dev/null

# Build toyc
pushd ../../toy-wasm
idris --build toy.ipkg
export PATH=$PATH:$(pwd)
popd


# Build Go->Native
pushd go/src
go install *
cp ../bin/* ../native/
popd
rm -rf go/bin/

# Build Go->Wasm
pushd go/src
GOOS=js GOARCH=wasm go install *
cp ../bin/js_wasm/* ../wasm/
popd
rm -rf go/bin/

# Build C->Native and C->Wasm (emcc)
pushd c
for p in src/*.c; do
    f=$(basename "$p" .c)
    clang "src/$f.c" -o "native/O3/$f" -O3
    clang "src/$f.c" -o "native/O0/$f" -O0
    emcc -o "wasm/O0/$f.js" -O0 "src/$f.c"
    emcc -o "wasm/O3/$f.js" -O3 "src/$f.c"
done
popd

# Build Toy->Wasm (toyc)
pushd toy
for p in src/*.toy; do
    f=$(basename "$p" .toy)
    toyc "src/$f.toy" -o "wasm/O0/$f"
    toyc "src/$f.toy" -o "wasm/O/$f" -O
    toyc "src/$f.toy" -o "wasm_heap_stack/O0/$f" --heap-stack
    toyc "src/$f.toy" -o "wasm_heap_stack/O/$f" --heap-stack -O
done
popd
