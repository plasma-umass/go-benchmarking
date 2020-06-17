#!/bin/bash

pushd() { builtin pushd $1 > /dev/null; }
popd() { builtin popd > /dev/null; }

shopt -s expand_aliases
source ~/.bash_aliases

cd programs/

wd=$(pwd)
export GOPATH="$wd/go"

# Clean everything
rm -rf go/bin/*
rm -rf go/native/*
rm -rf go/wasm/*
rm -rf c/native/*
rm -rf c/wasm/*

# Make sure desination directories exist
mkdir -p go/native
mkdir -p go/wasm
mkdir -p c/native/O3
mkdir -p c/native/O0
mkdir -p c/wasm/O3
mkdir -p c/wasm/O0

# Pull in emcc
emsdk_setup > /dev/null

# Build Go->Native
echo "Building Go->Native"
pushd go/src
go install *
cp ../bin/* ../native/
popd
rm -rf go/bin/

# Build Go->Wasm
echo "Building Go->Wasm"
pushd go/src
GOOS=js GOARCH=wasm go install *
cp ../bin/js_wasm/* ../wasm/
popd
rm -rf go/bin/

# Build C->Native and C->Wasm (emcc)
echo "Building C->Native and C->Wasm"
pushd c
for p in src/*.c; do
    f=$(basename "$p" .c)
    clang "src/$f.c" -o "native/O3/$f" -O2 -fno-inline-functions
    clang "src/$f.c" -o "native/O0/$f" -O0 -fno-inline-functions
    emcc -g -o "wasm/O0/$f.js" -O0 -fno-inline-functions "src/$f.c"
    emcc -g -o "wasm/O3/$f.js" -O2 -fno-inline-functions "src/$f.c"
done
popd


# Build uthreads
# cd ../
# Scripts/uthreads/build_all.sh
