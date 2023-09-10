# A fuzz test runs until it finds an error. This particular one is going to rely on libFuzzer.
#

ADD_EXECUTABLE(fuzz_tester fuzz_tester.cpp)
TARGET_LINK_LIBRARIES(
        fuzz_tester
        PRIVATE project_options
        project_warnings
        fmt::fmt-header-only
        -coverage
        -fsanitize=fuzzer,undefined,address)
TARGET_COMPILE_OPTIONS(fuzz_tester PRIVATE -fsanitize=fuzzer,undefined,address)

# Allow short runs during automated testing to see if something new breaks
SET(FUZZ_RUNTIME
        10
        CACHE STRING "Number of seconds to run fuzz tests during ctest run") # Default of 10 seconds

ADD_TEST(NAME fuzz_tester_run COMMAND fuzz_tester -max_total_time=${FUZZ_RUNTIME})
