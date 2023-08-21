FIND_PACKAGE(Threads)
FIND_PACKAGE(fmt REQUIRED)
FIND_PACKAGE(nlohmann_json REQUIRED)
FIND_PACKAGE(boost REQUIRED)

ADD_EXECUTABLE(test_boost_beast main.cpp)
TARGET_LINK_LIBRARIES(test_boost_beast PRIVATE ${CMAKE_THREAD_LIBS_INIT} boost::boost nlohmann_json::nlohmann_json fmt::fmt)
