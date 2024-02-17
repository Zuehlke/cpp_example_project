# Set a default build type if none was specified
IF(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    MESSAGE(STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
    SET(CMAKE_BUILD_TYPE
        RelWithDebInfo
        CACHE STRING "Choose the type of build." FORCE)
    # Set the possible values of build type for cmake-gui, ccmake
    SET_PROPERTY(
            CACHE CMAKE_BUILD_TYPE
            PROPERTY STRINGS
            "Debug"
            "Release"
            "MinSizeRel"
            "RelWithDebInfo")
ENDIF()

# Generate compile_commands.json to make it easier to work with clang based tools
SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Enhance error reporting and compiler messages
IF(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    IF(ENABLE_BUILD_WITH_TIME_TRACE)
        TARGET_COMPILE_OPTIONS(project_options INTERFACE -ftime-trace)
    ENDIF()

    IF(WIN32)
        # On Windows cuda nvcc uses cl and not clang
        ADD_COMPILE_OPTIONS($<$<COMPILE_LANGUAGE:C>:-fcolor-diagnostics> $<$<COMPILE_LANGUAGE:CXX>:-fcolor-diagnostics>)
    ELSE()
        ADD_COMPILE_OPTIONS(-fcolor-diagnostics -stdlib=libc++)
    ENDIF()
ELSEIF(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    IF(WIN32)
        # On Windows cuda nvcc uses cl and not gcc
        ADD_COMPILE_OPTIONS($<$<COMPILE_LANGUAGE:C>:-fdiagnostics-color=always>
                            $<$<COMPILE_LANGUAGE:CXX>:-fdiagnostics-color=always>)
    ELSE()
        ADD_COMPILE_OPTIONS(-fdiagnostics-color=always)
    ENDIF()
ELSEIF(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" AND MSVC_VERSION GREATER 1900)
    ADD_COMPILE_OPTIONS(/diagnostics:column)
ELSE()
    MESSAGE(STATUS "No colored compiler diagnostic set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
ENDIF()

# run vcvarsall when msvc is used
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/VCEnvironment.cmake")
RUN_VCVARSALL()
