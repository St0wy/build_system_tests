cmake_minimum_required (VERSION 3.27)

project("Testbed")

set (CMAKE_CXX_STANDARD 20)
set (CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(Testbed 
	src/main.cpp
)

target_include_directories(Testbed PRIVATE src/)

target_link_libraries(Testbed PUBLIC StowyPhysicsEngine)
