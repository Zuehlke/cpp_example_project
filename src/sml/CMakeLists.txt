ADD_EXECUTABLE(test_sml main.cpp logger.h states.h events.h plantumlDump.h)
TARGET_LINK_LIBRARIES(test_sml PRIVATE CONAN_PKG::sml CONAN_PKG::spdlog)
