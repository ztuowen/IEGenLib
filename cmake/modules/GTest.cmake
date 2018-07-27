add_custom_target(UnitTests)

include(ExternalProject)
ExternalProject_Add(googletest
    URL https://github.com/google/googletest/archive/release-1.8.0.zip
    URL_MD5 "adfafc8512ab65fd3cf7955ef0100ff5"
    CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/gtest;-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}"
    LOG_CONFIGURE 1
    LOG_INSTALL 1
)

set(GTEST_ROOT ${CMAKE_BINARY_DIR}/gtest)
set(GTEST_INCLUDE_DIR ${GTEST_ROOT}/include)
set(GTEST_LIB_DIR ${GTEST_ROOT}/lib)

set_target_properties(googletest PROPERTIES EXCLUDE_FROM_ALL TRUE)
add_library(gtest STATIC IMPORTED GLOBAL)
set_target_properties(gtest PROPERTIES IMPORTED_LOCATION "${GTEST_LIB_DIR}/libgtest.a")
add_dependencies(gtest googletest)

