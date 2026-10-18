#-----------------------------------------------------------------------------
#
# \brief  toolchain file for CMake to use TCB-Toolchain
#
#         to be used with
#              $ cmake -DCMAKE_TOOLCHAIN_FILE=... ...
#              $ cmake -DCMAKE_TOOLCHAIN_FILE= ../toolchain-tcb.cmake ..
#
#-----------------------------------------------------------------------------


# INCLUDE(CMakeForceCompiler)

SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_PROCESSOR arm)
SET(CMAKE_CROSSCOMPILING 1)

SET(TCB_PLATFORM "stm32")
SET(TCB_ARCH "arm")
SET(LOCAL_TUNE "@@LOCAL_TUNE@@")
SET(TCB_RELEASE "@@TCB_RELEASE@@")
SET(TCB_TARGET "arm-none-eabi")
SET(TCB_CROSS_COMPILE "arm-none-eabi-")
SET(TCB_DIR "${CMAKE_CURRENT_LIST_DIR}/../../..")

SET(DEFAULT_C_DEFINES "${DEFAULT_C_DEFINES} -DTCB=TCB2")

SET(ENV{ARCH} "${TCB_ARCH}")
SET(ENV{CROSS_COMPILE} "${TCB_CROSS_COMPILE}")
SET(ENV{PATH} "$ENV{PATH}:${TCB_DIR}/bin:${TCB_DIR}/bin/${TCB_TARGET}/:${TCB_DIR}/bin")

SET(CMAKE_C_COMPILER "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc")
SET(CMAKE_CXX_COMPILER "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}g++")

# Default linker script may not work because picolibc (crt0) needs some symbols
SET( CMAKE_C_COMPILER_WORKS 1 )
SET( CMAKE_CXX_COMPILER_WORKS 1 )

SET(CMAKE_GDB_COMPILER "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gdb" )
SET(CMAKE_LINKER "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}ld" )
SET(CMAKE_NM "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}nm" )
SET(CMAKE_OBJCOPY "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}objcopy" )
SET(CMAKE_OBJDUMP "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}objdump" )
SET(CMAKE_AR "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc-ar" )
SET(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> qcs <TARGET> <LINK_FLAGS> <OBJECTS>" )
SET(CMAKE_C_ARCHIVE_FINISH   true )
SET(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> qcs <TARGET> <LINK_FLAGS> <OBJECTS>" )
SET(CMAKE_CXX_ARCHIVE_FINISH   true )
SET(CMAKE_RANLIB "${TCB_DIR}/bin/${TCB_TARGET}/${TCB_CROSS_COMPILE}gcc-ranlib" )
SET(CMAKE_SYSROOT "${TCB_DIR}/../${TCB_TARGET}-${TCB_PLATFORM}")

add_compile_options(
		$<$<COMPILE_LANG_AND_ID:CXX,GNU>:-flto=auto>
		$<$<COMPILE_LANG_AND_ID:CXX,GNU>:-fno-rtti>
		$<$<COMPILE_LANG_AND_ID:C,GNU>:-flto=auto>
		-fno-exceptions
		-Wall
)

# Default settings use "-O3" which produce larger sizes

set ( CMAKE_CXX_FLAGS_RELWITHDEBINFO "-Os -g -DNDEBUG" )
set ( CMAKE_C_FLAGS_RELWITHDEBINFO "-Os -g -DNDEBUG" )

set ( CMAKE_CXX_FLAGS_RELEASE "-Os -g0 -DNDEBUG" )
set ( CMAKE_C_FLAGS_RELEASE "-Os -g0 -DNDEBUG" )

set ( CMAKE_CXX_FLAGS_DEBUG "-Og -g ${FULL_ASSERT}" )
set ( CMAKE_C_FLAGS_DEBUG "-Og -g ${FULL_ASSERT}" )

include( "$ENV{HOME}/.tcbuilder3.cmake" OPTIONAL )


#---fin-----------------------------------------------------------------------
