ADD_EXECUTABLE(test_crow main.cpp)
TARGET_LINK_LIBRARIES(test_crow PRIVATE CONAN_PKG::crowcpp-crow CONAN_PKG::spdlog)
