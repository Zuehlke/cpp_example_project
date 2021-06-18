OPTION(CPP_STARTER_USE_SML "Enable compilation of SML sample" OFF)

# Nana
IF(CPP_STARTER_USE_SML)
    MESSAGE("Using SML")
    ADD_SUBDIRECTORY(sml)
ENDIF()

# Generic test that uses conan libs
ADD_EXECUTABLE(intro main.cpp)
TARGET_LINK_LIBRARIES(
        intro
        PRIVATE project_options
        project_warnings
        CONAN_PKG::docopt.cpp
        CONAN_PKG::fmt
        CONAN_PKG::spdlog)

