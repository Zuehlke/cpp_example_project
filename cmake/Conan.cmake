macro(run_conan)
  # Download automatically, you can also just copy the conan.cmake file
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/0.18.1/conan.cmake" "${CMAKE_BINARY_DIR}/conan.cmake" TLS_VERIFY ON)
  endif()

  include(${CMAKE_BINARY_DIR}/conan.cmake)

  conan_cmake_run(
    REQUIRES
    ${CONAN_EXTRA_REQUIRES}
    catch2/2.13.7
    gtest/cci.20210126
    docopt.cpp/0.6.3
    fmt/8.0.1
    spdlog/1.9.2
    sml/1.1.4
    OPTIONS
    ${CONAN_EXTRA_OPTIONS}
    gtest:build_gmock=True
    BASIC_SETUP
    CMAKE_TARGETS # individual targets to link to
    BUILD
    missing)
endmacro()
