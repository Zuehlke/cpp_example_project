# find a subtring from a string by a given prefix such as VCVARSALL_ENV_START
FUNCTION(
        find_substring_by_prefix
        output
        prefix
        input)
    # find the prefix
    STRING(FIND "${input}" "${prefix}" prefix_index)
    IF("${prefix_index}" STREQUAL "-1")
        MESSAGE(SEND_ERROR "Could not find ${prefix} in ${input}")
    ENDIF()
    # find the start index
    STRING(LENGTH "${prefix}" prefix_length)
    MATH(EXPR start_index "${prefix_index} + ${prefix_length}")

    STRING(
            SUBSTRING "${input}"
            "${start_index}"
            "-1"
            _output)
    SET("${output}"
        "${_output}"
        PARENT_SCOPE)
ENDFUNCTION()

# A function to set environment variables of CMake from the output of `cmd /c set`
FUNCTION(SET_ENV_FROM_STRING env_string)
    # replace ; in paths with __sep__ so we can split on ;
    STRING(
            REGEX
            REPLACE ";"
            "__sep__"
            env_string_sep_added
            "${env_string}")

    # the variables are separated by \r?\n
    STRING(
            REGEX
            REPLACE "\r?\n"
            ";"
            env_list
            "${env_string_sep_added}")

    FOREACH(env_var ${env_list})
        # split by =
        STRING(
                REGEX
                REPLACE "="
                ";"
                env_parts
                "${env_var}")

        LIST(LENGTH env_parts env_parts_length)
        IF("${env_parts_length}" EQUAL "2")
            # get the variable name and value
            LIST(
                    GET
                    env_parts
                    0
                    env_name)
            LIST(
                    GET
                    env_parts
                    1
                    env_value)

            # recover ; in paths
            STRING(
                    REGEX
                    REPLACE "__sep__"
                    ";"
                    env_value
                    "${env_value}")

            # set env_name to env_value
            SET(ENV{${env_name}} "${env_value}")

            # update cmake program path
            IF("${env_name}" EQUAL "PATH")
                LIST(APPEND CMAKE_PROGRAM_PATH ${env_value})
            ENDIF()
        ENDIF()
    ENDFOREACH()
ENDFUNCTION()

FUNCTION(GET_ALL_TARGETS var)
    SET(targets)
    GET_ALL_TARGETS_RECURSIVE(targets ${CMAKE_CURRENT_SOURCE_DIR})
    SET(${var}
        ${targets}
        PARENT_SCOPE)
ENDFUNCTION()

FUNCTION(GET_ALL_INSTALLABLE_TARGETS var)
    SET(targets)
    GET_ALL_TARGETS(targets)
    FOREACH(_target ${targets})
        GET_TARGET_PROPERTY(_target_type ${_target} TYPE)
        IF(NOT
           ${_target_type}
           MATCHES
           ".*LIBRARY|EXECUTABLE")
            LIST(REMOVE_ITEM targets ${_target})
        ENDIF()
    ENDFOREACH()
    SET(${var}
        ${targets}
        PARENT_SCOPE)
ENDFUNCTION()

MACRO(GET_ALL_TARGETS_RECURSIVE targets dir)
    GET_PROPERTY(
            subdirectories
            DIRECTORY ${dir}
            PROPERTY SUBDIRECTORIES)
    FOREACH(subdir ${subdirectories})
        GET_ALL_TARGETS_RECURSIVE(${targets} ${subdir})
    ENDFOREACH()

    GET_PROPERTY(
            current_targets
            DIRECTORY ${dir}
            PROPERTY BUILDSYSTEM_TARGETS)
    LIST(APPEND ${targets} ${current_targets})
ENDMACRO()

FUNCTION(IS_VERBOSE var)
    IF("CMAKE_MESSAGE_LOG_LEVEL" STREQUAL "VERBOSE"
       OR "CMAKE_MESSAGE_LOG_LEVEL" STREQUAL "DEBUG"
       OR "CMAKE_MESSAGE_LOG_LEVEL" STREQUAL "TRACE")
        SET(${var}
            ON
            PARENT_SCOPE)
    ELSE()
        SET(${var}
            OFF
            PARENT_SCOPE)
    ENDIF()
ENDFUNCTION()
