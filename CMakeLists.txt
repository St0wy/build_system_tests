cmake_minimum_required(VERSION 3.27)

# Name of the solution
project("BuildSystemTests" VERSION 0.1.0)

if(NOT CMAKE_BUILD_TYPE)
  message("Build Type not set, defaulting to Debug...")
  set(CMAKE_BUILD_TYPE Debug)
endif()

add_subdirectory("stowy_physics_engine")

add_subdirectory("testbed")
