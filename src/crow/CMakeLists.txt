FIND_PACKAGE(Crow REQUIRED)
FIND_PACKAGE(spdlog REQUIRED)

ADD_EXECUTABLE(test_crow main.cpp)
TARGET_LINK_LIBRARIES(test_crow PRIVATE Crow::Crow spdlog::spdlog)
