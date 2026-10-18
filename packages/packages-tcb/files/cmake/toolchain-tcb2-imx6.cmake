#-----------------------------------------------------------------------------
#
# \brief  toolchain file for CMake to use TCB-Toolchain
#
#         to be used with
#              $ cmake -DCMAKE_TOOLCHAIN_FILE=... ...
#              $ cmake -DCMAKE_TOOLCHAIN_FILE= ../toolchain-tcb.cmake ..
#
#-----------------------------------------------------------------------------


SET(TCB_PLATFORM "imx6")
SET(TCB_ARCH "arm")
SET(LOCAL_TUNE "@@LOCAL_TUNE@@")
SET(TCB_RELEASE "@@TCB_RELEASE@@")
SET(TCB_TARGET "arm-linux-gnueabihf")
SET(TCB_CROSS_COMPILE "arm-linux-gnueabihf-")
SET(TCB_DIR "${CMAKE_CURRENT_LIST_DIR}/../../..")

SET(C_DEFINES "${C_DEFINES} -DTCB=TCB2")

SET(ENV{ARCH} "${TCB_ARCH}")
SET(ENV{CROSS_COMPILE} "${TCB_CROSS_COMPILE}")
SET(ENV{PATH} "$ENV{PATH}:${TCB_DIR}/bin:${TCB_DIR}/bin/${TCB_TARGET}/:${TCB_DIR}/bin")

SET(CMAKE_C_COMPILER "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc")
SET(CMAKE_CXX_COMPILER "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}g++")
SET(CMAKE_LINKER "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc")
SET(CMAKE_NM "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}nm" CACHE STRING "tcb")
SET(CMAKE_OBJCOPY "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}objcopy" CACHE STRING "tcb")
SET(CMAKE_OBJDUMP "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}objdump" CACHE STRING "tcb")
SET(CMAKE_AR "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc-ar" CACHE STRING "tcb")
SET(CMAKE_RANLIB "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc-ranlib" CACHE STRING "tcb")
SET(CMAKE_NM "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc-nm" CACHE STRING "tcb")

SET(CMAKE_SYSTEM_NAME GNU)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

include_directories("${TCB_DIR}/${TCB_TARGET}/usr/include")


SET(DEF_FLAGS "-Wall")
SET(C_DEFINES "${C_DEFINES} ${APP_MEM_DEFINES}")

# SET(LTO "")
SET(LTO "-flto")

SET(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} ${LTO} ${APP_MEM_LD_FLAGS}")
SET(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} ${LTO} ${MCU_FLAGS}" CACHE STRING "tcb")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${LTO} ${MCU_FLAGS} ${DEF_FLAGS} ${C_DEFINES}" CACHE STRING "tcb")
SET(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} ${LTO}" CACHE STRING "tcb")

SET(CMAKE_C_FLAGS_RELEASE "-Os -DNDEBUG" CACHE STRING "tcb")
# -Og works but eliminates (optimizes out) some vars.
SET(CMAKE_C_FLAGS_DEBUG  "-O0 -g3" CACHE STRING "tcb")

SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}" CACHE STRING "tcb")
SET(CMAKE_CXX_FLAGS_DEBUG  "${CMAKE_C_FLAGS_DEBUG}" CACHE STRING "tcb")

SET(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_LD_FLAGS}" CACHE STRING "tcb")

SET(CMAKE_SYSTEM_PROCESSOR arm)


#---fin-----------------------------------------------------------------------
