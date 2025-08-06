cmake_minimum_required(VERSION 3.6)

project(simplecc)

set(CMAKE_CXX_FLAGS "-O2 -std=c++23 -pthread -DNDEBUG")

add_library(simplecc SHARED
        simplecc.cpp
        dllmain.cpp
)
target_link_libraries(simplecc)
