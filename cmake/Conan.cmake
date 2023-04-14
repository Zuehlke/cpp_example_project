MACRO(RUN_CONAN)
    # Download automatically, you can also just copy the conan.cmake file
    IF(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
        MESSAGE(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
        FILE(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/develop/conan.cmake" "${CMAKE_BINARY_DIR}/conan.cmake" TLS_VERIFY ON)
    ENDIF()

    SET(ENV{CONAN_REVISIONS_ENABLED} 1)
    LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})
    LIST(APPEND CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR})

    INCLUDE(${CMAKE_BINARY_DIR}/conan.cmake)

    # Add (or remove) remotes as needed
    # conan_add_remote(NAME conan-center URL https://center.conan.io)
    CONAN_ADD_REMOTE(
            NAME
            conancenter
            URL
            https://center.conan.io
            INDEX
            0)

    IF(NOT CONAN_EXPORTED)
        # For multi configuration generators, like VS and XCode
        IF(NOT CMAKE_CONFIGURATION_TYPES)
            MESSAGE(STATUS "Single configuration build!")
            SET(LIST_OF_BUILD_TYPES ${CMAKE_BUILD_TYPE})
        ELSE()
            MESSAGE(STATUS "Multi-configuration build: '${CMAKE_CONFIGURATION_TYPES}'!")
            SET(LIST_OF_BUILD_TYPES ${CMAKE_CONFIGURATION_TYPES})
        ENDIF()

        FOREACH(TYPE ${LIST_OF_BUILD_TYPES})
            MESSAGE(STATUS "Running Conan for build type '${TYPE}'")

            IF("${ProjectOptions_CONAN_PROFILE}" STREQUAL "")
                # Detects current build settings to pass into conan
                CONAN_CMAKE_AUTODETECT(settings BUILD_TYPE ${TYPE})
                SET(CONAN_SETTINGS SETTINGS ${settings})
                SET(CONAN_ENV ENV "CC=${CMAKE_C_COMPILER}" "CXX=${CMAKE_CXX_COMPILER}")
            ELSE()
                # Derive all conan settings from a conan profile
                SET(CONAN_SETTINGS
                    PROFILE
                    ${ProjectOptions_CONAN_PROFILE}
                    SETTINGS
                    "build_type=${TYPE}")
                # CONAN_ENV should be redundant, since the profile can set CC & CXX
            ENDIF()

            IF("${ProjectOptions_CONAN_PROFILE}" STREQUAL "")
                SET(CONAN_DEFAULT_PROFILE "default")
            ELSE()
                SET(CONAN_DEFAULT_PROFILE ${ProjectOptions_CONAN_PROFILE})
            ENDIF()
            IF("${ProjectOptions_CONAN_BUILD_PROFILE}" STREQUAL "")
                SET(CONAN_BUILD_PROFILE ${CONAN_DEFAULT_PROFILE})
            ELSE()
                SET(CONAN_BUILD_PROFILE ${ProjectOptions_CONAN_BUILD_PROFILE})
            ENDIF()

            IF("${ProjectOptions_CONAN_HOST_PROFILE}" STREQUAL "")
                SET(CONAN_HOST_PROFILE ${CONAN_DEFAULT_PROFILE})
            ELSE()
                SET(CONAN_HOST_PROFILE ${ProjectOptions_CONAN_HOST_PROFILE})
            ENDIF()

            # PATH_OR_REFERENCE ${CMAKE_SOURCE_DIR} is used to tell conan to process
            # the external "conanfile.py" provided with the project
            # Alternatively a conanfile.txt could be used
            CONAN_CMAKE_INSTALL(
                    PATH_OR_REFERENCE
                    ${CMAKE_SOURCE_DIR}
                    BUILD
                    missing
                    # Pass compile-time configured options into conan
                    OPTIONS
                    ${ProjectOptions_CONAN_OPTIONS}
                    # Pass CMake compilers to Conan
                    ${CONAN_ENV}
                    PROFILE_HOST
                    ${CONAN_HOST_PROFILE}
                    PROFILE_BUILD
                    ${CONAN_BUILD_PROFILE}
                    # Pass either autodetected settings or a conan profile
                    ${CONAN_SETTINGS}
                    ${OUTPUT_QUIET})
        ENDFOREACH()

    ENDIF()
    # standard conan installation, in which deps will be defined in conanfile. It is not necessary to call conan again, as it is already running.
    IF(EXISTS "${CMAKE_BINARY_DIR}/conanbuildinfo.cmake")
        INCLUDE(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    ELSE()
        MESSAGE(FATAL_ERROR "Could not set up conan because \"${CMAKE_BINARY_DIR}/conanbuildinfo.cmake\" does not exist")
    ENDIF()
    CONAN_BASIC_SETUP(TARGETS)
ENDMACRO()
