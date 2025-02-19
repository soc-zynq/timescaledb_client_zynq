cmake_minimum_required(VERSION 3.10)

# Set the project name
project(timescaledb_client_zynq)

# Set output paths
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/out/bin)
set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/out/lib)

# Add include directories
include_directories(include)

# Add subdirectories
add_subdirectory(src/app)
add_subdirectory(src/lib)
add_subdirectory(src/test)
add_subdirectory(src/unit_test)

# Enable testing
enable_testing()

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Add compiler warnings
if (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()
