IF(NOT MSVC)
    OPTION(ENABLE_BUILD_WITH_TIME_TRACE "Enable -ftime-trace to generate time tracing .json files on clang" OFF)
ENDIF()

# Very basic PCH example
OPTION(ENABLE_PCH "Enable Precompiled Headers" OFF)

# static analyzers
OPTION(ENABLE_CPPCHECK "Enable static analysis with cppcheck" OFF)
OPTION(ENABLE_CLANG_TIDY "Enable static analysis with clang-tidy" OFF)
OPTION(ENABLE_INCLUDE_WHAT_YOU_USE "Enable static analysis with include-what-you-use" OFF)

# tooling
OPTION(ENABLE_CACHE "Enable cache if available" ON)
OPTION(ENABLE_DOXYGEN "Enable doxygen doc builds of source" OFF)

# Sanitizers
OPTION(ENABLE_SANITIZER_UNDEFINED_BEHAVIOR "Enable undefined behavior sanitizer" OFF)
OPTION(ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
OPTION(ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
OPTION(ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
OPTION(ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)

# others
OPTION(ENABLE_COVERAGE "Enable coverage reporting for gcc/clang" OFF)
OPTION(ENABLE_IPO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)" OFF)
OPTION(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" ON)
OPTION(BUILD_SHARED_LIBS "Enable compilation of shared libraries" OFF)
OPTION(ENABLE_TESTING "Enable Test Builds" ON)
OPTION(ENABLE_FUZZING "Enable Fuzzing Builds" OFF)

# examples
OPTION(CPP_STARTER_USE_SML "Enable compilation of SML sample" OFF)
OPTION(CPP_STARTER_USE_BOOST_BEAST "Enable compilation of boost beast sample" OFF)
OPTION(CPP_STARTER_USE_CROW "Enable compilation of crow sample" OFF)
OPTION(CPP_STARTER_USE_CPPZMQ_PROTO "Enable compilation of protobuf and cppzmq sample" OFF)
OPTION(CPP_STARTER_USE_EMBEDDED_TOOLCHAIN "Enable compilation of an example cortex m4 project" OFF)
