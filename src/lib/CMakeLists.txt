# Create a library called "timescaledb_client_zynq"
add_library(timescaledb_client_zynq_lib timescaledb_client_zynq.cpp)

# Specify include directories for the library
target_include_directories(timescaledb_client_zynq_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../../include)
