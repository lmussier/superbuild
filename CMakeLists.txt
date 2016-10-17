cmake_minimum_required(VERSION 3.0)
set(CMP0048 NEW)

#Disable in source compilation
if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
    message( FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there. You may need to remove CMakeCache.txt." )
endif()

if(NOT DEFINED CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE STREQUAL "")
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type")
endif()

project(superbuild)

include(ExternalProject)

#Setting some handy variables
set(BUILD_HOME ${CMAKE_CURRENT_LIST_DIR})

set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install_folder)

#Where to put external stuff like, curl and iot sdk
set(EXTERNAL_DIR ${BUILD_HOME}/externals)

ExternalProject_Add(
    gtest
    PREFIX gtest-build-folder
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG release-1.8.0
    DOWNLOAD_DIR ${EXTERNAL_DIR}
    CMAKE_ARGS -Dgtest_disable_pthreads=ON -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    LOG_DOWNLOAD OFF
    LOG_UPDATE OFF
    LOG_CONFIGURE OFF
    LOG_BUILD OFF
    LOG_TEST OFF
    LOG_INSTALL OFF
)

ExternalProject_Add(
    myLib
    DEPENDS gtest
    PREFIX myLib-build-folder
    GIT_REPOSITORY https://github.com/lmussier/myLib
    GIT_TAG master
    DOWNLOAD_DIR ${EXTERNAL_DIR}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DGTEST_ROOT_DIR=${CMAKE_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    TEST_COMMAND ctest -VV
    LOG_DOWNLOAD OFF
    LOG_UPDATE OFF
    LOG_CONFIGURE OFF
    LOG_BUILD OFF
    LOG_TEST OFF
    LOG_INSTALL OFF
)

ExternalProject_Add(
    myApp
    DEPENDS myLib gtest
    PREFIX myApp-build-folder
    GIT_REPOSITORY https://github.com/lmussier/myApp
    GIT_TAG master
    DOWNLOAD_DIR ${EXTERNAL_DIR}
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DGTEST_ROOT_DIR=${CMAKE_INSTALL_PREFIX} -DMYLIB_ROOT_DIR=${CMAKE_INSTALL_PREFIX}
    TEST_COMMAND ctest -VV
    LOG_DOWNLOAD OFF
    LOG_UPDATE OFF
    LOG_CONFIGURE OFF
    LOG_BUILD OFF
    LOG_TEST OFF
    LOG_INSTALL OFF
)
