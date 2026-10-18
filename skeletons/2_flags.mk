#------------------------------------------------------------------------------
#
# \brief    Default Flags for compiling
#
#           Also some usefull variables.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


CPUS                          :=$(shell let a=$$(cat /proc/cpuinfo  | grep processor | wc -l); echo $$a)
THREADS                       :=$(shell let a=$$(cat /proc/cpuinfo  | grep processor | wc -l)*20/10; echo $$a)

##############
#--- $(MAKE) uses them:
# MAKEFLAGS                       := -j$(THREADS)
#SUB_MAKEFLAGS                        = -j$(THREADS)
#############

LOCAL_TUNE_STAGE1   ="$(shell gcc $(BUILD_ARCHFLAGS) -E -v - </dev/null 2>&1 | grep cc1)"
LOCAL_TUNE_STAGE2   =$(shell line=$(LOCAL_TUNE_STAGE1); line=$${line##*-march=}; line=$${line%% *}; echo $$line)
LOCAL_TUNE_STAGE3   =$(LOCAL_TUNE_STAGE2)
LOCAL_TUNE          =$(subst -,_,$(LOCAL_TUNE_STAGE3))
LOCAL_TUNE          =x86_64

### Thats what added to the prefix, e.g. /opt/tcb2-stm32-x86_64
### LOCAL_TUNE has to be included since it wont run on other machines.
### TCB_TARGET_PLATFORM is optional since multiple targets can be included in one sysroot
TCB_TAG             =-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)

#############
# -D__GLIBC__ needed for mesa
# -fPIC: some projects wont link against libraries that are not compiled with -fPIC.
# CPPFLAGS_FOR_TARGET                +=$(TARGET_ARCHFLAGS) -D__ARM_PCS_VFP -DJB_PC -DJB_SP
# CXXFLAGS_FOR_TARGET                +=$(TARGET_ARCHFLAGS) -fPIC
########

############
# -fPIC
# CPPFLAGS_FOR_TARGET                 += -I$(TARGET_PATH)/include -I$(TARGET_PATH)/include/linux
# CXXFLAGS_FOR_TARGET                 += -nostdinc++ -I$(TARGET_PATH)/include -I$(TARGET_PATH)/include/linux
# CFLAGS_FOR_TARGET                   += -nostdinc -I$(TARGET_PATH)/include -I$(TARGET_PATH)/include/linux

CPPFLAGS_FOR_TARGET                 +=
CXXFLAGS_FOR_TARGET                 +=
CFLAGS_FOR_TARGET                   +=
CPPFLAGS                            +=
LDFLAGS_FOR_TARGET                  +=
LDFLAGS                             +=
DEFAULT_ARCHFLAGS                   +=

### The target ARCHFLAGS might be a little bit special; debug/size/etc.
### We use "DEFAULT_NONTARGET_ARCHFLAGS" to specify flags only for the toolchain
### itself. The toolchain does not need debug information but should be fast.
### -O3 does not work on openocd; efford of O3 is not clear

# DEFAULT_NONTARGET_ARCHFLAGS     +=-g0 -O2

CFLAGS_FOR_HOST                  += $(DEFAULT_ARCHFLAGS) $(DEFAULT_NONTARGET_ARCHFLAGS) $(HOST_ARCHFLAGS)
CXXFLAGS_FOR_HOST                += $(DEFAULT_ARCHFLAGS) $(DEFAULT_NONTARGET_ARCHFLAGS) $(HOST_ARCHFLAGS)
LDFLAGS_FOR_HOST                 += $(DEFAULT_ARCH_LDFLAGS) $(DEFAULT_NONTARGET_ARCHFLAGS) $(ARCH_LDFLAGS)

# -Wl,-L$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/lib64 \
#                                     -Wl,-w

CFLAGS_FOR_TARGET                += $(DEFAULT_ARCHFLAGS) $(TARGET_ARCHFLAGS)
CXXFLAGS_FOR_TARGET              += $(DEFAULT_ARCHFLAGS) $(TARGET_ARCHFLAGS)
LDFLAGS_FOR_TARGET               += $(DEFAULT_ARCH_LDFLAGS) $(TARGET_ARCH_LDFLAGS)

CFLAGS_FOR_BUILD                += $(DEFAULT_ARCHFLAGS) $(DEFAULT_NONTARGET_ARCHFLAGS) $(BUILD_ARCHFLAGS)
CXXFLAGS_FOR_BUILD              += $(DEFAULT_ARCHFLAGS) $(DEFAULT_NONTARGET_ARCHFLAGS) $(BUILD_ARCHFLAGS)
LDFLAGS_FOR_BUILD               += $(DEFAULT_ARCH_LDFLAGS) $(DEFAULT_NONTARGET_ARCHFLAGS) $(BUILD_ARCH_LDFLAGS)


### It works to let you run $(CXX_FOR_TARGET) in a target:
# PATH                            :=$(PATH):$(PREFIX)/binXYZ

REDIRECTION_STATEMENT            =&>
redirect                        = > $(1) 2>&1
LOG_FILE                        = "$(LOG_PATH)/$@.log"
LOG_REDIRECT                    = > "$(LOG_FILE)" 2>&1
ADD_LOG_REDIRECT                = >> "$(LOG_FILE)" 2>&1

### XGCC_FLAGS_FOR_TARGET uses FLAGS_FOR_TARGET in gccs Makefile.in
FLAGS_FOR_TARGET                =$(CFLAGS_FOR_TARGET)

ifndef DEBUG
   DEBUG                        = 0
endif

define DBG_PRINT
   @if [ "$(DEBUG)" -gt "0" ]; then echo "### Target: $@; $<"; fi
endef


#---fin------------------------------------------------------------------------
