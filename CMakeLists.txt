CMAKE_MINIMUM_REQUIRED(VERSION 3.21)

INCLUDE(cmake/Conan.cmake)

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

INCLUDE(cmake/BuildingConfig.cmake)
SETUP_MULTI_CONFIG()

INCLUDE(cmake/StandardProjectSettings.cmake)
INCLUDE(cmake/PreventInSourceBuilds.cmake)
INCLUDE(cmake/CodeFormat.cmake)
INCLUDE(cmake/InterproceduralOptimization.cmake)
ENABLE_IPO()

# fetch git hash information for configure version template file
INCLUDE(cmake/GitInformation.cmake)
GET_GIT_HASH()

CONFIGURE_FILE("templates/version.hpp.in" "${CMAKE_BINARY_DIR}/generated/include/version.hpp" ESCAPE_QUOTES)

# Link this 'library' to set the c++ standard / compile-time options requested
ADD_LIBRARY(project_options INTERFACE)
TARGET_COMPILE_FEATURES(project_options INTERFACE cxx_std_${CXX_STANDARD})

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

# enabled precompiled headers
INCLUDE(cmake/PrecompiledHeader.cmake)
ENABLE_PCH()

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
