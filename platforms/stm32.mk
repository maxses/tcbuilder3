#------------------------------------------------------------------------------
#
#  \brief   STM32 microcontroller platform recipe for tcbuilder3
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#-------------------.----------------------------------------------------------


#---Documentation-------------------------------
#
# The STM32F4Discovery-Board has a STM32F407VG MCU:
#    Cortex M4 + DSP + FPU single precision
#    192Kb Ram, 1024kb Flash, 168Mhz
# The ARM Cortex M4 is a:
#    ARMv7-ME, (optional) Floatpoint FPv4-SP (IEEE-754 kompatibel)
#
# According to mikrocontroller.net for M4F we ca use:
#    -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb 
#    -ffunction-sections -fdata-sections -g -fno-rtti -fno-exceptions
#
# "Only Thumb and Thumb-2 instructions [...] are supported in Cortex-M
# architectures; the legacy 32-bit ARM instruction set is not supported."
#
# fpu: fpv4-sp-d16
# arch: armv7-m (armv7e-m)
# cpu: cortex-m4
#
# The default libc setting for newlibs without multilib are:
#   "-mfloat-abi=soft -msoft-float -mcpu=cortex-m3 -nostdlib -nostartfiles -mthumb"
#
# We only compile a static Version of newlib(libc). Thats totally sufficient.
#
#-----------------------------------------------


#------Platform---------------------------------

tcb.TARGET_CPU              = arm
# stm32 or unknown, not used anywhere
#tcb.TARGET_SYSTEM           = stm32
tcb.TARGET_SYSTEM           = unknown
tcb.TARGET_OS               = eabi
tcb.TARGET_KERNEL           = none
tcb.TARGET_ABI              = armhf

MAKEFILE_DIR_stm32 := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

### We want target stuff as small as possible.
### "-fno-rtti" does not work here because gcc would not compile
TARGET_ARCHFLAGS             += -fno-exceptions -Os -g0
#BUILD_ARCHFLAGS              += -O2 -g0
#HOST_ARCHFLAGS               += -O2 -g0
# openocd fails with -O3 because of too much "maybe uninitialized" variables
openocd.CFLAGS_FOR_HOST                += -O2

#libgloss.CFLAGS_FOR_TARGET          += -flto
#newlib.CFLAGS_FOR_TARGET          += -flto

### Must not use C(XX)FLAGS_FOR_TARGET; would waste our multilib packages
# -marm is not supported by cpu. See documentation block above.

#CONCRETE_CFLAGS_FOR_TARGET    +=-march=armv7e-m -mcpu=cortex-m4 \
#                                -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb
#CONCRETE_CXXFLAGS_FOR_TARGET  +=-march=armv7e-m -mcpu=cortex-m4 \
#                                -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb

### See issue "#254
ifeq ("$(gcc.VERSION)", "6.1.0")
   gcc.VERSION                      =	5.4.0
endif


#------Flags------------------------------------

### Warning: --with-arch overrides --with-cpu=cortex-m4
### warning: switch -mcpu=cortex-m4 conflicts with -march=armv7-m switch [enabled by default]

# more complete multilib-list: armv6-m,armv7-m,armv7e-m,armv7-r
MULTILIB_LIST			= armv6-m,armv7-m,armv7e-m

# For debugging: support only one instruction set to speed up build times
# MULTILIB_LIST			=armv7-m

gcc.MULTILIB                +=   --enable-multilib \
                                 --disable-interwork \
                                 --with-multilib-list=rmprofile
# --with-multilib-list=$(MULTILIB_LIST)
                                
# gcc.BLACKLIST                 ="'8.0.x'"

gcc.CONFIGUREFLAGS          +=   --with-newlib=yes \
                                 --enable-target-optspace

# Store stm32 archives and campo to downloads
stm32_checks.ENVIRONMENT    = $(host.ENVIRONMENT) \
                              BUILD_PATH=$(BUILD_PATH) \
                              SOURCE_PATH=$(SOURCE_PATH) \
                              ARCHIVE_PATH=$(DOWNLOADS_PATH)

LIBC_PROVIDER               = picolib
picolib.CREATE_NANO          = yes
# Just inform hello-world/meta how to compile
NOSTDLIB                    = yes

# LIBC_PROVIDER               = newlib
# newlibE_NANO          = yes

#------Rules------------------------------------

toolchain.issue: openocd.issue
stm32.issue: toolchain.issue meta.issue stm32_checks.issue cmake_host.issue
	$(done)


%.stm32_checks.issue: toolchain.issue meta.issue cmake_host.issue
	$(call lHint,Performing compile test for STM32 toolchain: campo)
	@$(do_export) $(MAKEFILE_DIR_stm32)/files/stm32_verify.sh $(LOG_REDIRECT) \
		|| $(call dumpAndFail,Could not make,"$(LOG_FILE)");
	$(done)


stm32_checks.issue: stm32_checks.stm32_checks.issue
	$(done)


#---fin------------------------------------------------------------------------
