#!/usr/bin/env sh
set -evx
env | sort

pwd
ls
mkdir build || true
mkdir build/$CMAKE_BUILD_TYPE || true
cd build/$CMAKE_BUILD_TYPE
cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE ../../superbuild
make
