cmake_minimum_required(VERSION 3.5)

project(apg)

find_package(raylib REQUIRED)

file(GLOB SOURCES "src/*.cpp")

add_executable(apg ${SOURCES})
target_include_directories(apg PRIVATE src)
target_link_libraries(apg PRIVATE raylib)
