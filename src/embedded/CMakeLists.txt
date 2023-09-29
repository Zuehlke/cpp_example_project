SET(TARGET test_arm_gcc)
FIND_PACKAGE(fmt REQUIRED)

ADD_EXECUTABLE(${TARGET} main.cpp)
TARGET_LINK_LIBRARIES(${TARGET} PRIVATE fmt::fmt-header-only)

SET_TARGET_PROPERTIES(${TARGET} PROPERTIES SUFFIX ".elf")
TARGET_LINK_OPTIONS(${TARGET}
                    PRIVATE
                    -T${CMAKE_CURRENT_SOURCE_DIR}/linkerScript.ld
                    -Wl,-Map=${TARGET}.map
                    )
ADD_CUSTOM_TARGET(${TARGET}.bin ALL
                  DEPENDS ${TARGET}
                  COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${TARGET}> $<TARGET_FILE_DIR:${TARGET}>/$<TARGET_FILE_BASE_NAME:${TARGET}>.bin
                  COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${TARGET}> $<TARGET_FILE_DIR:${TARGET}>/$<TARGET_FILE_BASE_NAME:${TARGET}>.hex
                  )
