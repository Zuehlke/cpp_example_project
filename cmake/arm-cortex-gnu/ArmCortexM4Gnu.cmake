SET(MCPU_FLAGS "-mthumb -mcpu=cortex-m4")
SET(VFP_FLAGS "-mfloat-abi=hard -mfpu=fpv4-sp-d16")

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/ArmCortexGnuToolchain.cmake)
