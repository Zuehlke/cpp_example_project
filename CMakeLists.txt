CMAKE_MINIMUM_REQUIRED(VERSION 3.16...3.23)

# strongly encouraged to enable this globally to avoid conflicts between
# -Wpedantic being enabled and -std=c++20 and -std=gnu++20 for example
# when compiling with PCH enabled
SET(CMAKE_CXX_EXTENSIONS OFF)

INCLUDE(cmake/Options.cmake)

# Set the project name to your project name, my project isn't very descriptive
PROJECT(myproject
        LANGUAGES CXX
        VERSION 0.0.1)

IF(NOT DEFINED CXX_STANDARD)
    SET(CXX_STANDARD 20)
ENDIF()

SET(CMAKE_CXX_STANDARD ${CXX_STANDARD})

GET_PROPERTY(BUILDING_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
IF(BUILDING_MULTI_CONFIG)
    IF(NOT CMAKE_BUILD_TYPE)
        # Make sure that all supported configuration types have their
        # associated conan packages available. You can reduce this
        # list to only the configuration types you use, but only if one
        # is not forced-set on the command line for VS
        MESSAGE(TRACE "Setting up multi-config build types")
        SET(CMAKE_CONFIGURATION_TYPES
            Debug
            Release
            RelWithDebInfo
            MinSizeRel
            CACHE STRING "Enabled build types" FORCE)
    ELSE()
        MESSAGE(TRACE "User chose a specific build type, so we are using that")
        SET(CMAKE_CONFIGURATION_TYPES
            ${CMAKE_BUILD_TYPE}
            CACHE STRING "Enabled build types" FORCE)
    ENDIF()
ENDIF()

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
TARGET_COMPILE_FEATURES(project_options INTERFACE cxx_std_${CXX_STANDARD})

IF(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
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

INCLUDE(cmake/Conan.cmake)
RUN_CONAN()

ADD_SUBDIRECTORY(src)

IF(CMAKE_CROSSCOMPILING)
    MESSAGE("Test are not built for GCC ARM toolchain!")
    RETURN()
ENDIF()

IF(ENABLE_TESTING)
    ENABLE_TESTING()
    MESSAGE("Building Tests. Be sure to check out test/constexpr_tests for constexpr testing")
    ADD_SUBDIRECTORY(test)
ENDIF()

IF(ENABLE_FUZZING)
    MESSAGE("Building Fuzz Tests, using fuzzing sanitizer https://www.llvm.org/docs/LibFuzzer.html")
    ADD_SUBDIRECTORY(fuzz_test)
ENDIF()
