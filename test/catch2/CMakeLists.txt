include(CTest)
include(Catch)

add_library(catch_main STATIC catch_main.cpp)
target_link_libraries(catch_main PUBLIC CONAN_PKG::catch2)
target_link_libraries(catch_main PRIVATE project_options)

add_executable(catch_tests tests.cpp)
target_link_libraries(catch_tests PRIVATE project_warnings project_options catch_main)

# automatically discover tests that are defined in catch based test files you can modify the unittests. Set TEST_PREFIX
# to whatever you want, or use different for different binaries
catch_discover_tests(
  catch_tests
  TEST_PREFIX
  "catch_unittests."
  REPORTER
  xml
  OUTPUT_DIR
  .
  OUTPUT_PREFIX
  "catch_unittests."
  OUTPUT_SUFFIX
  .xml)

# Add a file containing a set of constexpr tests
add_executable(catch_constexpr_tests constexpr_tests.cpp)
target_link_libraries(catch_constexpr_tests PRIVATE project_options project_warnings catch_main)

catch_discover_tests(
  catch_constexpr_tests
  TEST_PREFIX
  "catch_constexpr."
  REPORTER
  xml
  OUTPUT_DIR
  .
  OUTPUT_PREFIX
  "catch_constexpr."
  OUTPUT_SUFFIX
  .xml)

# Disable the constexpr portion of the test, and build again this allows us to have an executable that we can debug when
# things go wrong with the constexpr testing
add_executable(catch_relaxed_constexpr_tests constexpr_tests.cpp)
target_link_libraries(catch_relaxed_constexpr_tests PRIVATE project_options project_warnings catch_main)
target_compile_definitions(catch_relaxed_constexpr_tests PRIVATE -DCATCH_CONFIG_RUNTIME_STATIC_REQUIRE)

catch_discover_tests(
  catch_relaxed_constexpr_tests
  TEST_PREFIX
  "catch_relaxed_constexpr."
  REPORTER
  xml
  OUTPUT_DIR
  .
  OUTPUT_PREFIX
  "catch_relaxed_constexpr."
  OUTPUT_SUFFIX
  .xml)
