CMAKE_MINIMUM_REQUIRED(VERSION 3.15)

# Set the project name to your project name, my project isn't very descriptive
PROJECT(myproject
        LANGUAGES CXX
        VERSION 0.0.1)

INCLUDE(cmake/StandardProjectSettings.cmake)
INCLUDE(cmake/PreventInSourceBuilds.cmake)
INCLUDE(cmake/CodeFormat.cmake)

EXECUTE_PROCESS(
        COMMAND git log -1 --format=%h
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        OUTPUT_VARIABLE GIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
)

CONFIGURE_FILE("templates/version.hpp.in" "${CMAKE_BINARY_DIR}/generated/include/version.hpp" ESCAPE_QUOTES)

# Link this 'library' to set the c++ standard / compile-time options requested
ADD_LIBRARY(project_options INTERFACE)
TARGET_COMPILE_FEATURES(project_options INTERFACE cxx_std_17)

IF(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    OPTION(ENABLE_BUILD_WITH_TIME_TRACE "Enable -ftime-trace to generate time tracing .json files on clang" OFF)
    IF(ENABLE_BUILD_WITH_TIME_TRACE)
        TARGET_COMPILE_OPTIONS(project_options INTERFACE -ftime-trace)
    ENDIF()
ENDIF()

# Link this 'library' to use the warnings specified in CompilerWarnings.cmake
ADD_LIBRARY(project_warnings INTERFACE)

# enable cache system
INCLUDE(cmake/Cache.cmake)

# standard compiler warnings
INCLUDE(cmake/CompilerWarnings.cmake)
SET_PROJECT_WARNINGS(project_warnings)

# sanitizer options if supported by compiler
INCLUDE(cmake/Sanitizers.cmake)
ENABLE_SANITIZERS(project_options)

# enable doxygen
INCLUDE(cmake/Doxygen.cmake)
ENABLE_DOXYGEN()

# allow for static analysis options
INCLUDE(cmake/StaticAnalyzers.cmake)

OPTION(BUILD_SHARED_LIBS "Enable compilation of shared libraries" OFF)
OPTION(ENABLE_TESTING "Enable Test Builds" ON)
OPTION(ENABLE_FUZZING "Enable Fuzzing Builds" OFF)

# Very basic PCH example
OPTION(ENABLE_PCH "Enable Precompiled Headers" OFF)
IF(ENABLE_PCH)
    # This sets a global PCH parameter, each project will build its own PCH, which is a good idea if any #define's change
    #
    # consider breaking this out per project as necessary
    TARGET_PRECOMPILE_HEADERS(
            project_options
            INTERFACE
            <vector>
            <string>
            <map>
            <utility>)
ENDIF()

# Set up some extra Conan dependencies based on our needs before loading Conan
SET(CONAN_EXTRA_REQUIRES "")
SET(CONAN_EXTRA_OPTIONS "")

INCLUDE(cmake/Conan.cmake)
RUN_CONAN()

IF(ENABLE_TESTING)
    ENABLE_TESTING()
    MESSAGE("Building Tests. Be sure to check out test/constexpr_tests for constexpr testing")
    ADD_SUBDIRECTORY(test)
ENDIF()

IF(ENABLE_FUZZING)
    MESSAGE("Building Fuzz Tests, using fuzzing sanitizer https://www.llvm.org/docs/LibFuzzer.html")
    ADD_SUBDIRECTORY(fuzz_test)
ENDIF()

ADD_SUBDIRECTORY(src)
