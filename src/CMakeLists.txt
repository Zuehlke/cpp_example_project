# SML
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

# Generic test that uses conan libs
ADD_EXECUTABLE(intro main.cpp)
TARGET_LINK_LIBRARIES(
        intro
        PRIVATE project_options
        project_warnings
        CONAN_PKG::docopt.cpp
        CONAN_PKG::fmt
        CONAN_PKG::spdlog)

TARGET_INCLUDE_DIRECTORIES(intro PRIVATE ${CMAKE_BINARY_DIR}/generated)
