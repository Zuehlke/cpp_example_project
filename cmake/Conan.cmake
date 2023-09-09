# Download automatically, you can also just copy the conan.cmake file
IF(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    MESSAGE(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    FILE(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/develop2/conan_provider.cmake" "${CMAKE_BINARY_DIR}/conan.cmake" TLS_VERIFY ON)
ENDIF()

LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})
SET(CMAKE_PROJECT_TOP_LEVEL_INCLUDES "${CMAKE_BINARY_DIR}/conan.cmake")
