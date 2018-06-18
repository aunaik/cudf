# Download and unpack googletest at configure time
configure_file(${CMAKE_SOURCE_DIR}/cmake/CMakeLists.GoogleTest.cmake ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/googletest-download/CMakeLists.txt)

execute_process(
    COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/googletest-download/
)

if(result)
    message(FATAL_ERROR "CMake step for googletest failed: ${result}")
endif()

execute_process(
    COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/googletest-download/
)

if(result)
    message(FATAL_ERROR "Build step for googletest failed: ${result}")
endif()

# Prevent overriding the parent project's compiler/linker
# settings on Windows
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# Prevent overriding the parent project's compiler/linker
# settings on Windows
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# Locate the Google Test package.
# Requires that you build with:
#   -DGTEST_ROOT:PATH=/path/to/googletest_install_dir
set(GTEST_ROOT ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/thirdparty/googletest-install/)
message(STATUS "GTEST_ROOT: " ${GTEST_ROOT})

#pass the dependency libraries as optional arguments using ${ARGN}
#NOTE the order of libraries matter, so try to link first with the most high level lib
function(configure_test TEST_NAME Tests_SRCS)
    message(STATUS "${TEST_NAME} will link against: gdf arrow")

    cuda_add_executable(${TEST_NAME} ${Tests_SRCS})
    target_link_libraries(${TEST_NAME} gdf arrow GTest::GTest ${GTEST_ROOT}/lib/libgmock.a ${GTEST_ROOT}/lib/libgmock_main.a)

    #register the target as CMake test so we can use ctest for this executable
    add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
endfunction()
