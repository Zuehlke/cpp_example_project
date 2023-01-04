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
    catch2/3.2.1
    gtest/1.12.1
    docopt.cpp/0.6.3
    fmt/9.1.0
    spdlog/1.11.0
    sml/1.1.6
    nlohmann_json/3.11.2
    boost/1.80.0
    crowcpp-crow/1.0+3
    cppzmq/4.9.0
    protobuf/3.21.9
    OPTIONS
    ${CONAN_EXTRA_OPTIONS}
    gtest:build_gmock=True
    SETTINGS
    compiler.cppstd=${CXX_STANDARD}
    BASIC_SETUP
    CMAKE_TARGETS # individual targets to link to
    BUILD
    missing)
endmacro()
