set(FORMAT_CHECK_EXCLUDED_DIRS CACHE STRING "")

add_custom_target(format-check
                  USES_TERMINAL
                  COMMAND ${CMAKE_SOURCE_DIR}/scripts/run-clang-format.py -warnings-as-errors -exclude-dir ${FORMAT_CHECK_EXCLUDED_DIRS}
)

add_custom_target(format-check-fix
                  USES_TERMINAL
                  COMMAND ${CMAKE_SOURCE_DIR}/scripts/run-clang-format.py -fix -exclude-dir ${FORMAT_CHECK_EXCLUDED_DIRS}
)
