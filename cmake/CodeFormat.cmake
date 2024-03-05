FIND_PACKAGE(Python COMPONENTS Interpreter REQUIRED)

# To exclude directories from the format check, add corresponding clang-format config files into those directories.
ADD_CUSTOM_TARGET(clang-format-check
                  USES_TERMINAL
                  COMMAND ${Python_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/run-clang-format.py -warnings-as-errors
)

ADD_CUSTOM_TARGET(clang-format-check-fix
                  USES_TERMINAL
                  COMMAND ${Python_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/run-clang-format.py -fix
)

ADD_CUSTOM_TARGET(clang-tidy-check
                  USES_TERMINAL
                  COMMAND ${Python_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/run-clang-tidy.py
)

ADD_CUSTOM_TARGET(clang-tidy-diff-check
                  USES_TERMINAL
                  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                  COMMAND git diff -U0 HEAD --no-prefix | ${Python_EXECUTABLE} ${CMAKE_SOURCE_DIR}/scripts/run-clang-tidy-diff.py -path ${CMAKE_BINARY_DIR}
)
