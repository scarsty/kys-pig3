cmake_minimum_required(VERSION 3.16)
project(kys_pig3_c LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- 路径配置 ---
set(BIN_C_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../bin-c")
set(MLCC_PATH "C:/project/mlcc")
set(VCPKG_INSTALLED "D:/project/vcpkg/installed/arm64-android-dynamic")
set(PREBUILT_LIB_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../lib/${ANDROID_ABI}")

# --- 游戏源文件 ---
set(GAME_SOURCES
    ${BIN_C_PATH}/main.cpp
    ${BIN_C_PATH}/kys_type.cpp
    ${BIN_C_PATH}/kys_engine.cpp
    ${BIN_C_PATH}/kys_draw.cpp
    ${BIN_C_PATH}/kys_main.cpp
    ${BIN_C_PATH}/kys_event.cpp
    ${BIN_C_PATH}/kys_battle.cpp
    ${BIN_C_PATH}/kys_script.cpp
)

# --- mlcc 基础库源文件 (strcvt仅Windows, 不参与Android编译) ---
set(MLCC_SOURCES
    ${MLCC_PATH}/filefunc.cpp
    ${MLCC_PATH}/strfunc.cpp
    ${MLCC_PATH}/ZipFile.cpp
    ${MLCC_PATH}/SimpleCC.cpp
)

# --- 构建共享库 ---
add_library(kys_pig3_c SHARED ${GAME_SOURCES} ${MLCC_SOURCES})

target_include_directories(kys_pig3_c PRIVATE
    ${BIN_C_PATH}
    ${MLCC_PATH}
)
target_include_directories(kys_pig3_c SYSTEM PRIVATE
    ${VCPKG_INSTALLED}/include
)

# Android不播放影片
target_compile_definitions(kys_pig3_c PRIVATE KYS_NO_MOVIE)

# --- 预编译依赖库 (IMPORTED) ---

# SDL3
add_library(SDL3 SHARED IMPORTED)
set_target_properties(SDL3 PROPERTIES IMPORTED_LOCATION ${PREBUILT_LIB_PATH}/libSDL3.so)

# SDL3_mixer
add_library(SDL3_mixer SHARED IMPORTED)
set_target_properties(SDL3_mixer PROPERTIES IMPORTED_LOCATION ${PREBUILT_LIB_PATH}/libSDL3_mixer.so)

# SDL3_ttf
add_library(SDL3_ttf SHARED IMPORTED)
set_target_properties(SDL3_ttf PROPERTIES IMPORTED_LOCATION ${PREBUILT_LIB_PATH}/libSDL3_ttf.so)

# Lua
add_library(lua SHARED IMPORTED)
set_target_properties(lua PROPERTIES IMPORTED_LOCATION ${PREBUILT_LIB_PATH}/liblua.so)

# libzip
add_library(zip_lib SHARED IMPORTED)
set_target_properties(zip_lib PROPERTIES IMPORTED_LOCATION ${PREBUILT_LIB_PATH}/libzip.so)

# zlib
add_library(z_lib SHARED IMPORTED)
set_target_properties(z_lib PROPERTIES IMPORTED_LOCATION ${PREBUILT_LIB_PATH}/libz.so)

# simplecc: 源码直接编译, 不链接预编译so
# smallpot: Android不播放影片, 不需要

# --- 链接 ---
target_link_libraries(kys_pig3_c PRIVATE
    SDL3
    SDL3_mixer
    SDL3_ttf
    lua
    zip_lib
    z_lib
    android
    log
)

