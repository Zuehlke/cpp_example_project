FIND_PACKAGE(Threads)

ADD_EXECUTABLE(test_boost_beast main.cpp)
TARGET_LINK_LIBRARIES(test_boost_beast PRIVATE ${CMAKE_THREAD_LIBS_INIT} CONAN_PKG::boost CONAN_PKG::nlohmann_json CONAN_PKG::fmt)
