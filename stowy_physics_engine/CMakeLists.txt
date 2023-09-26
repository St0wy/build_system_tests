cmake_minimum_required (VERSION 3.27)

project("StowyPhysicsEngine"
    VERSION 0.1.0
    DESCRIPTION "A basic physics engine in c++"
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_library(StowyPhysicsEngine)

set(public_headers
    src/Transform.hpp
    src/collision/BroadPhaseGrid.hpp
    src/collision/Collider.hpp
    src/collision/Collision.hpp
    src/collision/CollisionBody.hpp
    src/collision/CollisionWorld.hpp
    src/collision/Edge.hpp
    src/collision/Manifold.hpp
    src/collision/ManifoldFactory.hpp
    src/collision/Projection.hpp
    src/collision/Simplex.hpp
    src/dynamics/Solver.hpp
    src/dynamics/DynamicsWorld.hpp
    src/dynamics/Rigidbody.hpp
    src/math/Vector2.hpp
)

target_sources(StowyPhysicsEngine
    PRIVATE
    "src/collision/BroadPhaseGrid.cpp"
    "src/collision/Collider.cpp"
    "src/collision/CollisionBody.cpp"
    "src/collision/CollisionWorld.cpp"
    "src/collision/Edge.cpp"
    "src/collision/Manifold.cpp"
    "src/collision/ManifoldFactory.cpp"
    "src/collision/Projection.cpp"
    "src/collision/Simplex.cpp"
    "src/dynamics/DynamicsWorld.cpp"
    "src/dynamics/Rigidbody.cpp"
    "src/dynamics/Solver.cpp"
    "src/math/Vector2.cpp"
    ${public_headers}
)

target_include_directories(StowyPhysicsEngine PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src/)
target_compile_definitions(StowyPhysicsEngine PUBLIC STWCMAKE)
