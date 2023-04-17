SET(TARGET test_arm_gcc)

ADD_EXECUTABLE(${TARGET} main.cpp)
TARGET_LINK_LIBRARIES(${TARGET} ${CONAN_LIBS})

SET_TARGET_PROPERTIES(${TARGET} PROPERTIES SUFFIX ".elf")
TARGET_LINK_OPTIONS(${TARGET}
                    PRIVATE
                    -T${CMAKE_CURRENT_SOURCE_DIR}/linkerScript.ld
                    -Wl,-Map=${TARGET}.map
                    )
ADD_CUSTOM_TARGET(${TARGET}.bin ALL
                  DEPENDS ${TARGET}
                  COMMAND ${CMAKE_OBJCOPY} -Obinary ${CMAKE_BINARY_DIR}/bin/${TARGET}.elf ${CMAKE_BINARY_DIR}/bin/${TARGET}.bin
                  COMMAND ${CMAKE_OBJCOPY} -Oihex ${CMAKE_BINARY_DIR}/bin/${TARGET}.elf ${CMAKE_BINARY_DIR}/bin/${TARGET}.hex
                  )
