#!/usr/bin/env sh
set -evx
env | sort

mkdir build || true
mkdir build/$CMAKE_BUILD_TYPE || true
cd build/$CMAKE_BUILD_TYPE
cmake -Dgtest_build_samples=ON \
      -Dgmock_build_samples=ON \
      -Dgtest_build_tests=ON \
      -Dgmock_build_tests=ON \
      -DCMAKE_CXX_FLAGS=$CXX_FLAGS \
      ../../superbuild
make