cmake_minimum_required(VERSION 2.8)
project(IEGENLIB)

## Add a 'docs' target to build documentation.  (make docs)
add_subdirectory(doc)

#Tell cmake to look in Modules for custom modules
set(CMAKE_MODULE_PATH 
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules 
    ${CMAKE_MODULE_PATH})

## ensure that we are doing an out of source build
include(MacroOutOfSourceBuild)
macro_ensure_out_of_source_build(
    "${PROJECT_NAME} requires an out of source build.")

enable_testing()

include(GTest)

## add the includes and libaries that we depend on
find_package(Threads)

include_directories(${Threads_INCLUDE_DIR} ${GTEST_INCLUDE_DIR})
link_directories(${GTEST_LIB_DIR})

## gtest is added through lib (our source through src) 
add_subdirectory(src)

## set up the testing
add_custom_command(OUTPUT iegen_lib_gdbtest
    COMMAND IEGEN_HOME=. gdb src/iegenlib_t
    DEPENDS iegenlib_t
    COMMENT "Run iegenlib tests through gdb")
add_custom_target(gdbtest DEPENDS iegen_lib_gdbtest)

add_custom_command(OUTPUT iegen_lib_memtest
    COMMAND IEGEN_HOME=. valgrind --leak-check=full src/iegenlib_t
    DEPENDS iegenlib_t
    COMMENT "Run iegenlib tests through valgrind for memory error detection")
add_custom_target(mtest DEPENDS iegen_lib_memtest)

add_custom_command(OUTPUT iegen_lib_test
	          COMMAND IEGEN_HOME=. src/iegenlib_t 
                  DEPENDS iegenlib_t
                  COMMENT "Run iegenlib tests")
add_custom_target(rtest DEPENDS iegen_lib_test)

# Set flags for various builds. 
set(CMAKE_CXX_FLAGS "-std=c++11 -fPIC"     
    CACHE STRING "Flags used by the compiler during all build types." FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-std=c++11 -O3 -DNDEBUG"     
    CACHE STRING "Flags used by the compiler during release builds." FORCE)
set(CMAKE_CXX_FLAGS_DEBUG  "-std=c++11 -O0 -g"     
    CACHE STRING "Flags used by the compiler during debug builds." FORCE)
set(CMAKE_EXE_LINKER_FLAGS_DEBUG  "-std=c++11 -fPIC -O0 -g"     
    CACHE STRING "Flags used by the linker during debug builds." FORCE)
set( CMAKE_MODULE_LINKER_DEBUG_FLAGS "-std=c++11 -fPIC -O0 -g" CACHE STRING "" FORCE )
set( CMAKE_SHARED_LINKER_DEBUG_FLAGS "-std=c++11 -fPIC -O0 -g" CACHE STRING "" FORCE )
