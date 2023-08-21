FIND_PACKAGE(sml REQUIRED)
FIND_PACKAGE(spdlog REQUIRED)

ADD_EXECUTABLE(test_sml main.cpp logger.h states.h events.h plantumlDump.h actions.h)
TARGET_LINK_LIBRARIES(test_sml PRIVATE sml::sml spdlog::spdlog)
