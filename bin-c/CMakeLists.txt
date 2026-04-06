cmake_minimum_required(VERSION 3.16)
project(kys_pig3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# vcpkg 工具链 (如有)
# set(CMAKE_TOOLCHAIN_FILE "C:/project/vcpkg/scripts/buildsystems/vcpkg.cmake")

# mlcc 基础库路径
set(MLCC_PATH "C:/project/mlcc")

# --- 源文件 ---
add_executable(kys_pig3
    main.cpp
    kys_type.cpp
    kys_engine.cpp
    kys_draw.cpp
    kys_main.cpp
    kys_event.cpp
    kys_battle.cpp
    kys_script.cpp
)

# mlcc 头文件
target_include_directories(kys_pig3 PRIVATE ${MLCC_PATH})

# --- 依赖库查找 ---
find_package(SDL3 REQUIRED)
find_package(SDL3_ttf REQUIRED)
find_package(SDL3_mixer REQUIRED)
find_package(SDL3_image REQUIRED)
find_package(Lua REQUIRED)

target_include_directories(kys_pig3 PRIVATE ${LUA_INCLUDE_DIR})

target_link_libraries(kys_pig3 PRIVATE
    SDL3::SDL3
    SDL3_ttf::SDL3_ttf
    SDL3_mixer::SDL3_mixer
    SDL3_image::SDL3_image
    ${LUA_LIBRARIES}
)

# simplecc 动态加载 (SDL_LoadObject), 不需要静态链接

if(WIN32)
    # set_target_properties(kys_pig3 PROPERTIES WIN32_EXECUTABLE TRUE)
    target_compile_definitions(kys_pig3 PRIVATE _CRT_SECURE_NO_WARNINGS NOMINMAX)
endif()
