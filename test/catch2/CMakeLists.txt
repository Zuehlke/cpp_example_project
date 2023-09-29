FIND_PACKAGE(Catch2 REQUIRED)

INCLUDE(CTest)
INCLUDE(Catch)

ADD_EXECUTABLE(catch_tests tests.cpp)
TARGET_LINK_LIBRARIES(catch_tests PRIVATE project_warnings project_options Catch2::Catch2WithMain)

# automatically discover tests that are defined in catch based test files you can modify the unittests. Set TEST_PREFIX
# to whatever you want, or use different for different binaries
CATCH_DISCOVER_TESTS(
        catch_tests
        TEST_PREFIX
        "catch_unittests."
        REPORTER
        JUnit
        OUTPUT_DIR
        .
        OUTPUT_PREFIX
        "catch_unittests."
        OUTPUT_SUFFIX
        .xml)

# Add a file containing a set of constexpr tests
ADD_EXECUTABLE(catch_constexpr_tests constexpr_tests.cpp)
TARGET_LINK_LIBRARIES(catch_constexpr_tests PRIVATE project_options project_warnings Catch2::Catch2WithMain)

CATCH_DISCOVER_TESTS(
        catch_constexpr_tests
        TEST_PREFIX
        "catch_constexpr."
        REPORTER
        JUnit
        OUTPUT_DIR
        .
        OUTPUT_PREFIX
        "catch_constexpr."
        OUTPUT_SUFFIX
        .xml)

# Disable the constexpr portion of the test, and build again this allows us to have an executable that we can debug when
# things go wrong with the constexpr testing
ADD_EXECUTABLE(catch_relaxed_constexpr_tests constexpr_tests.cpp)
TARGET_LINK_LIBRARIES(catch_relaxed_constexpr_tests PRIVATE project_options project_warnings Catch2::Catch2WithMain)
TARGET_COMPILE_DEFINITIONS(catch_relaxed_constexpr_tests PRIVATE -DCATCH_CONFIG_RUNTIME_STATIC_REQUIRE)

CATCH_DISCOVER_TESTS(
        catch_relaxed_constexpr_tests
        TEST_PREFIX
        "catch_relaxed_constexpr."
        REPORTER
        JUnit
        OUTPUT_DIR
        .
        OUTPUT_PREFIX
        "catch_relaxed_constexpr."
        OUTPUT_SUFFIX
        .xml)
