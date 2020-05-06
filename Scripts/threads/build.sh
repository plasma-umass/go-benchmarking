#!/bin/bash

p=$(realpath "$1")
o=$(pwd)/a.wat
pushd /Users/donaldpinckney/UMass/research/WasmContinuations/emcc_control/
./emcc++_control "$p" "$o"
popd
