INCLUDE("${CMAKE_CURRENT_LIST_DIR}/Utilities.cmake")

MACRO(DETECT_ARCHITECTURE)
    # detect the architecture
    STRING(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" CMAKE_SYSTEM_PROCESSOR_LOWER)
    IF(CMAKE_SYSTEM_PROCESSOR_LOWER STREQUAL x86 OR CMAKE_SYSTEM_PROCESSOR_LOWER MATCHES "^i[3456]86$")
        SET(VCVARSALL_ARCH x86)
    ELSEIF(
            CMAKE_SYSTEM_PROCESSOR_LOWER STREQUAL x64
            OR CMAKE_SYSTEM_PROCESSOR_LOWER STREQUAL x86_64
            OR CMAKE_SYSTEM_PROCESSOR_LOWER STREQUAL amd64)
        SET(VCVARSALL_ARCH x64)
    ELSEIF(CMAKE_SYSTEM_PROCESSOR_LOWER STREQUAL arm)
        SET(VCVARSALL_ARCH arm)
    ELSEIF(CMAKE_SYSTEM_PROCESSOR_LOWER STREQUAL arm64 OR CMAKE_SYSTEM_PROCESSOR_LOWER STREQUAL aarch64)
        SET(VCVARSALL_ARCH arm64)
    ELSE()
        IF(CMAKE_HOST_SYSTEM_PROCESSOR)
            SET(VCVARSALL_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
        ELSE()
            SET(VCVARSALL_ARCH x64)
            MESSAGE(STATUS "Unkown architecture CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR_LOWER} - using x64")
        ENDIF()
    ENDIF()
ENDMACRO()

# Run vcvarsall.bat and set CMake environment variables
FUNCTION(RUN_VCVARSALL)
    # if MSVC but VSCMD_VER is not set, which means vcvarsall has not run
    IF(MSVC AND "$ENV{VSCMD_VER}" STREQUAL "")

        # find vcvarsall.bat
        GET_FILENAME_COMPONENT(MSVC_DIR ${CMAKE_CXX_COMPILER} DIRECTORY)
        FIND_FILE(
                VCVARSALL_FILE
                NAMES vcvarsall.bat
                PATHS "${MSVC_DIR}"
                "${MSVC_DIR}/.."
                "${MSVC_DIR}/../.."
                "${MSVC_DIR}/../../../../../../../.."
                "${MSVC_DIR}/../../../../../../.."
                PATH_SUFFIXES "VC/Auxiliary/Build" "Common7/Tools" "Tools")

        IF(EXISTS ${VCVARSALL_FILE})
            # detect the architecture
            DETECT_ARCHITECTURE()

            # run vcvarsall and print the environment variables
            MESSAGE(STATUS "Running `${VCVARSALL_FILE} ${VCVARSALL_ARCH}` to set up the MSVC environment")
            EXECUTE_PROCESS(
                    COMMAND
                    "cmd" "/c" ${VCVARSALL_FILE} ${VCVARSALL_ARCH} #
                    "&&" "call" "echo" "VCVARSALL_ENV_START" #
                    "&" "set" #
                    OUTPUT_VARIABLE VCVARSALL_OUTPUT
                    OUTPUT_STRIP_TRAILING_WHITESPACE)

            # parse the output and get the environment variables string
            FIND_SUBSTRING_BY_PREFIX(VCVARSALL_ENV "VCVARSALL_ENV_START" "${VCVARSALL_OUTPUT}")

            # set the environment variables
            SET_ENV_FROM_STRING("${VCVARSALL_ENV}")

        ELSE()
            MESSAGE(
                    WARNING
                    "Could not find `vcvarsall.bat` for automatic MSVC environment preparation. Please manually open the MSVC command prompt and rebuild the project.
      ")
        ENDIF()
    ENDIF()
ENDFUNCTION()
