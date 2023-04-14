# To exclude directories from the format check, add corresponding clang-format config files into those directories.

ADD_CUSTOM_TARGET(format-check
                  USES_TERMINAL
                  COMMAND ${CMAKE_SOURCE_DIR}/scripts/run-clang-format.py -warnings-as-errors
                  )

ADD_CUSTOM_TARGET(format-check-fix
                  USES_TERMINAL
                  COMMAND ${CMAKE_SOURCE_DIR}/scripts/run-clang-format.py -fix
                  )
