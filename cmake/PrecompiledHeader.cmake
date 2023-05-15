FUNCTION(ENABLE_PCH)
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
ENDFUNCTION()
