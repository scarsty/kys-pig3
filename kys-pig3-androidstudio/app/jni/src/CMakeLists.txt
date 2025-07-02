cmake_minimum_required(VERSION 3.6)

project(main)

find_library(SDL2 SDL2)

link_directories(. ../../lib/arm64-v8a)

add_library(main SHARED)

target_sources(main PRIVATE main.c)

target_link_libraries(main SDL2 kys_pig3 log m)


