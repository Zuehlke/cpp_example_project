# SML
IF(CMAKE_CROSSCOMPILING)
    IF(CPP_STARTER_USE_EMBEDDED_TOOLCHAIN)
        MESSAGE("Using Embedded Toolchain")
        ADD_SUBDIRECTORY(embedded)
    ENDIF()
    RETURN()
ENDIF()

IF(CPP_STARTER_USE_SML)
    MESSAGE("Using SML")
    ADD_SUBDIRECTORY(sml)
ENDIF()

# Boost Beast
IF(CPP_STARTER_USE_BOOST_BEAST)
    MESSAGE("Using Boost Beast")
    ADD_SUBDIRECTORY(boost.beast)
ENDIF()

# Crow
IF(CPP_STARTER_USE_CROW)
    MESSAGE("Using Crow")
    ADD_SUBDIRECTORY(crow)
ENDIF()

# CPPZMQ & Protobuf
IF(CPP_STARTER_USE_CPPZMQ_PROTO)
    MESSAGE("Using CPPZMQ & Protobuf")
    ADD_SUBDIRECTORY(protobuf.cppzmq)
ENDIF()

# QT example
IF(CPP_STARTER_USE_QT)
    MESSAGE("Using QT")
    ADD_SUBDIRECTORY(qt)
ENDIF()


FIND_PACKAGE(docopt REQUIRED)
FIND_PACKAGE(spdlog REQUIRED)
FIND_PACKAGE(fmt REQUIRED)
# Generic test that uses conan libs
ADD_EXECUTABLE(intro main.cpp)
TARGET_LINK_LIBRARIES(
        intro
        PRIVATE project_options
        project_warnings
        docopt_s
        fmt::fmt-header-only
        spdlog::spdlog_header_only)

TARGET_INCLUDE_DIRECTORIES(intro PRIVATE ${CMAKE_BINARY_DIR}/generated)
