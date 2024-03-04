FUNCTION(SETUP_MULTI_CONFIG)
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
ENDFUNCTION()
