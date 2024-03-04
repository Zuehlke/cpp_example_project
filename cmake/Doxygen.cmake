FUNCTION(ENABLE_DOXYGEN)
    IF(ENABLE_DOXYGEN)
        # If not specified, use the top readme file as the first page
        IF((NOT DOXYGEN_USE_MDFILE_AS_MAINPAGE) AND EXISTS "${PROJECT_SOURCE_DIR}/README.md")
            SET(DOXYGEN_USE_MDFILE_AS_MAINPAGE "${PROJECT_SOURCE_DIR}/README.md")
        ENDIF()

        # set better defaults for doxygen
        IS_VERBOSE(_is_verbose)
        IF(NOT ${_is_verbose})
            SET(DOXYGEN_QUIET YES)
        ENDIF()
        SET(DOXYGEN_CALLER_GRAPH YES)
        SET(DOXYGEN_CALL_GRAPH YES)
        SET(DOXYGEN_EXTRACT_ALL YES)
        SET(DOXYGEN_GENERATE_TREEVIEW YES)
        # svg files are much smaller than jpeg and png, and yet they have higher quality
        SET(DOXYGEN_DOT_IMAGE_FORMAT svg)
        SET(DOXYGEN_DOT_TRANSPARENT YES)

        # If not specified, exclude the vcpkg files and the files CMake downloads under _deps (like project_options)
        IF(NOT DOXYGEN_EXCLUDE_PATTERNS)
            SET(DOXYGEN_EXCLUDE_PATTERNS "${CMAKE_CURRENT_BINARY_DIR}/vcpkg_installed/*" "${CMAKE_CURRENT_BINARY_DIR}/_deps/*")
        ENDIF()

        IF("${DOXYGEN_THEME}" STREQUAL "")
            SET(DOXYGEN_THEME "awesome-sidebar")
        ENDIF()

        IF("${DOXYGEN_THEME}" STREQUAL "awesome" OR "${DOXYGEN_THEME}" STREQUAL "awesome-sidebar")
            # use a modern doxygen theme
            # https://github.com/jothepro/doxygen-awesome-css v2.0.0
            FETCHCONTENT_DECLARE(_doxygen_theme
                                 URL https://github.com/jothepro/doxygen-awesome-css/archive/refs/tags/v2.2.0.zip)
            FETCHCONTENT_MAKEAVAILABLE(_doxygen_theme)
            IF("${DOXYGEN_THEME}" STREQUAL "awesome" OR "${DOXYGEN_THEME}" STREQUAL "awesome-sidebar")
                SET(DOXYGEN_HTML_EXTRA_STYLESHEET "${_doxygen_theme_SOURCE_DIR}/doxygen-awesome.css")
            ENDIF()
            IF("${DOXYGEN_THEME}" STREQUAL "awesome-sidebar")
                SET(DOXYGEN_HTML_EXTRA_STYLESHEET ${DOXYGEN_HTML_EXTRA_STYLESHEET}
                    "${_doxygen_theme_SOURCE_DIR}/doxygen-awesome-sidebar-only.css")
            ENDIF()
        ELSE()
            # use the original doxygen theme
        ENDIF()

        # find doxygen and dot if available
        FIND_PACKAGE(Doxygen REQUIRED OPTIONAL_COMPONENTS dot)

        # add doxygen-docs target
        MESSAGE(STATUS "Adding `doxygen-docs` target that builds the documentation.")
        DOXYGEN_ADD_DOCS(doxygen-docs ALL ${PROJECT_SOURCE_DIR}
                         COMMENT "Generating documentation - entry file: ${CMAKE_CURRENT_BINARY_DIR}/html/index.html")

    ENDIF()
ENDFUNCTION()
