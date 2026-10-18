#------------------------------------------------------------------------------
#
# \brief    Variables for spezialy for crosscompiling
#
#           mostly configure arguments and environment variables.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


# default: "x86_64-unknown-linux-gnu"
# BUILD                      = x86_64
# HOST                       = x86_64


#BUILD                      =x86_64-pc-linux-gnu
#HOST                       =x86_64-pc-linux-gnu

# Thats /lib tripplet
# $(uname -m)-$(uname -s)-
BUILD                      =x86_64-linux-gnu
HOST                       =x86_64-linux-gnu

# Debian uses triplet, GCC internally uses 4 parts.
# Emdebian: either arm-none-eabi or arm-linux-gnueabi
# armel is only used in package name, not in tripplets

# TARGET                     =$(tcb.TARGET_CPU)-$(tcb.TARGET_SYSTEM)-$(tcb.TARGET_KERNEL)-$(tcb.TARGET_OS)
TARGET                     =$(tcb.TARGET_CPU)-$(tcb.TARGET_KERNEL)-$(tcb.TARGET_OS)

# Verified for arm-none-eabi:
# TARGET                     =$(tcb.TARGET_CPU)-$(tcb.TARGET_KERNEL)-$(tcb.TARGET_OS)


SIMPLE_TARGET              =$(tcb.TARGET_CPU)
#--- How the abi is called in debian
TARGET_ABI                 =$(tcb.TARGET_ABI)

### Relocatable toolchain: sysroot must be a subpath of prefix

CROSS_COMPILE              =$(TARGET)-

default.CONFIGUREFLAGS		= --build=$(BUILD) --host=$(HOST) --target=$(TARGET)
                              --with-local-prefix=$(SYSROOT)/LOCAL_PREFIX


#                              --with-sysroot=$(SYSROOT)


### pure local compiles. At least "gmp" does not want "--target".
# --cache-file=$(BUILD_PATH)/tcb-config-host.cache
host.CONFIGUREFLAGS  =  \
										\
										--build=$(BUILD) --host=$(HOST) --target=$(HOST) \
                              --prefix=$(HOST_PREFIX) \
                              --libexecdir=$(HOST_PREFIX)/lib \
                              --includedir=$(HOST_PREFIX)/include \
			      --with-libtool-sysroot=$(SYSROOT_HOST) \
                              --with-sysroot=$(SYSROOT_HOST) \
                              --with-gmp=$(SYSROOT_HOST)$(HOST_PREFIX) \
                              --with-mpfr=$(SYSROOT_HOST)$(HOST_PREFIX) \
			    --with-mpc=$(SYSROOT_HOST)$(HOST_PREFIX) \
			    --enable-relocatable

# 			      --program-prefix=x86_64-
# --enable-relocatable: at least bison has this. Otherwise yacc can not find bison eexecutable (or uses hosts one if prefixes do match).


### host has to be $(TARGET) or libraries are compiled for $(HOST)
# --cache-file=$(BUILD_PATH)/tcb-config-target.cache
target.CONFIGUREFLAGS		= \
										-q \
                              --build=$(BUILD) \
                              --host=$(TARGET) \
                              --target=$(TARGET) \
                              --enable-malloc0returnsnull \
                              --prefix=$(TARGET_PREFIX) \
                              --with-sysroot=$(SYSROOT_TARGET) \
                              --with-build-sysroot=$(SYSROOT_TARGET)

#                              --libdir=$(OPT_PATH)/$(TARGET)/usr/lib \
#                              --libexecdir=$(OPT_PATH)/$(TARGET)/usr/lib
#
#                              --with-libtool-sysroot=$(HOST_NONUSR_PREFIX) \
#

# --cache-file=$(BUILD_PATH)/tcb-config-cross.cache
cross.CONFIGUREFLAGS		= \
										-q \
										--build=$(BUILD) --host=$(BUILD) --target=$(TARGET) \
                              --enable-malloc0returnsnull \
                              --prefix=$(TARGET_PREFIX) \
                              --exec_prefix=$(HOST_PREFIX)/lib \
                              --bindir=$(CROSSTOOLS_BIN_PREFIX) \
                              --sbindir=$(CROSSTOOLS_BIN_PREFIX) \
                              --libdir=$(HOST_PREFIX)/lib/$(TARGET) \
                              --libexecdir=$(HOST_PREFIX)/lib/$(TARGET) \
                              --datadir=$(TARGET_PREFIX)/share \
                              --includedir=$(TARGET_PREFIX)/include \
                              --oldincludedir=$(TARGET_PREFIX)/include \
                              --program-prefix=$(CROSS_COMPILE) \
                              --with-sysroot=$(SYSROOT_TARGET) \
                              --with-build-sysroot=$(SYSROOT_TARGET) \
                              --with-gmp=$(SYSROOT_HOST)/$(HOST_PREFIX) \
                              --with-mpfr=$(SYSROOT_HOST)/$(HOST_PREFIX) \
                              --with-mpc=$(SYSROOT_HOST)/$(HOST_PREFIX)


#                               --with-as=$(CROSSTOOLS_BIN_PREFIX)/$(AS_FOR_TARGET) \
#                              --with-libtool-sysroot=$(HOST_NONUSR_PREFIX)


# glibc even needs ranlib
# DLLTOOL and NM are for mingw
# Quotation makrs aroung CFLAGS etc are quite important
# PATH-enhancement: at least neccessary for libgcrypt to find gpg-error-config

# PKG_CONFIG_SYSROOT_DIR=$(HOST_NONUSR_PREFIX) \
# PKG_CONFIG_DIR=$(HOST_NONUSR_PREFIX)/bin \

### There are no ASFLAGS!
### TARGET_BIN_PREFIX: Sometimes libraries (e.g. libgpg-error) installs config
### scripts.
### ACLOCAL_PATH: Neccessary when pkg-config is not installed on the host for
### example. It is relevant for autogen scripts.
target.ENVIRONMENT   = \
                              CROSS_COMPILE=$(CROSS_COMPILE) \
										PATH="$($*.PREPATH):$(HOSTTOOLS_BIN_PATH):$(CROSSTOOLS_BIN_PATH):$($*.PATH):${PATH}" \
                              CPPFLAGS="$(CPPFLAGS_FOR_TARGET) $($*.CPPFLAGS_FOR_TARGET)" \
                              CFLAGS="$(CFLAGS_FOR_TARGET) $($*.CFLAGS_FOR_TARGET)" \
                              CXXFLAGS="$(CXXFLAGS_FOR_TARGET) $($*.CXXFLAGS_FOR_TARGET)" \
                              LDFLAGS="$(LDFLAGS_FOR_TARGET) $($*.LDFLAGS_FOR_TARGET)" \
                              \
                              CFLAGS_FOR_TARGET="$(CFLAGS_FOR_TARGET) $($*.CFLAGS_FOR_TARGET)" \
                              CXXFLAGS_FOR_TARGET="$(CXXFLAGS_FOR_TARGET) $($*.CXXFLAGS_FOR_TARGET)" \
                              LDFLAGS_FOR_TARGET="$(LDFLAGS_FOR_TARGET) $($*.LDFLAGS_FOR_TARGET)" \
                              \
                              PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
                              PKG_CONFIG=$(TARGET_PKG_CONFIG_RUNTIME) \
                              PKG_CONFIG_SYSROOT_DIR=$(SYSROOT_TARGET) \
                              ACLOCAL_PATH=$(INSTALLROOT_TARGET)$(TARGET_PREFIX)/share/aclocal \
                              PATH="$(HOSTTOOLS_BIN_PATH):${PATH}"
                              
target.DESTDIR    =           "$(INSTALLROOT_TARGET)"

# newlib-nano does not want this in "target.ENVIRONMENT"
revert=                              PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
                              PKG_CONFIG=$(TARGET_PKG_CONFIG_RUNTIME) \
                              ACLOCAL_PATH=$(HOST_NONUSR_PREFIX)/share/aclocal \
                              CC=$(CROSS_COMPILE)gcc \
                              CPP=$(CROSS_COMPILE)cpp \
                              AS=$(CROSS_COMPILE)as \
                              CXX=$(CROSS_COMPILE)g++ \
                              GCC=$(CROSS_COMPILE)gcc \
                              AR=$(CROSS_COMPILE)ar \
                              AS=$(CROSS_COMPILE)as \
                              LD=$(CROSS_COMPILE)ld \
                              STRIP=$(CROSS_COMPILE)strip \
                              OBJCOPY=$(CROSS_COMPILE)objcopy \
                              RANLIB=$(CROSS_COMPILE)ranlib \
                              OBJDUMP=$(CROSS_COMPILE)objdump \
                              DLLTOOL=$(CROSS_COMPILE)dlltool \
                              NM=$(CROSS_COMPILE)nm

target.manual_applications.ENVIRONMENT   = \
                              CC=$(CROSS_COMPILE)gcc \
                              CXX=$(CROSS_COMPILE)g++ \
                              GCC=$(CROSS_COMPILE)gcc \
                              AR=$(CROSS_COMPILE)gcc-ar \
                              AS=$(CROSS_COMPILE)as \
                              LD=$(CROSS_COMPILE)ld \
                              STRIP=$(CROSS_COMPILE)strip \
                              OBJCOPY=$(CROSS_COMPILE)objcopy \
                              RANLIB=$(CROSS_COMPILE)gcc-ranlib \
                              OBJDUMP=$(CROSS_COMPILE)objdump \
                              DLLTOOL=$(CROSS_COMPILE)dlltool \
                              NM=$(CROSS_COMPILE)nm


cross.ENVIRONMENT            =PATH="$(HOSTTOOLS_BIN_PATH):$(CROSSTOOLS_BIN_PATH):${PATH}:$($*.PATH)" \
                              CPPFLAGS="$(CPPFLAGS) $($*.CPPFLAGS)" \
                              CFLAGS="$(CFLAGS_FOR_HOST) $($*.CFLAGS_FOR_HOST)" \
                              CXXFLAGS="$(CXXFLAGS_FOR_HOST) $($*.CXXFLAGS_FOR_HOST)" \
                              LDFLAGS="$(LDFLAGS_FOR_HOST) $($*.LDFLAGS_FOR_HOST)" \
                              \
                              CFLAGS_FOR_TARGET="$(CFLAGS_FOR_TARGET) $($*.CFLAGS_FOR_TARGET)" \
                              FLAGS_FOR_TARGET="$(FLAGS_FOR_TARGET)" \
                              CXXFLAGS_FOR_TARGET="$(CXXFLAGS_FOR_TARGET) $($*.CXXFLAGS_FOR_TARGET)" \
                              CPPFLAGS_FOR_TARGET="$(CPPFLAGS_FOR_TARGET) $($*.CPPFLAGS_FOR_TARGET)" \
                              LDFLAGS_FOR_TARGET="$(LDFLAGS_FOR_TARGET) $($*.LDFLAGS_FOR_TARGET)" \
                              XGCC_FLAGS_FOR_TARGET="$(XGCC_FLAGS_FOR_TARGET) $($*.XGCC_FLAGS_FOR_TARGET)" \
                              \
                              CFLAGS_FOR_BUILD="$(CFLAGS_FOR_BUILD) $($*.CFLAGS_FOR_BUILD)" \
                              CXXFLAGS_FOR_BUILD="$(CXXFLAGS_FOR_BUILD)  $($*.CXXFLAGS_FOR_BUILD)" \
                              CPPFLAGS_FOR_BUILD="$(CPPFLAGS_FOR_BUILD)  $($*.CPPFLAGS_FOR_BUILD)" \
                              LDFLAGS_FOR_BUILD="$(LDFLAGS_FOR_BUILD)  $($*.LDFLAGS_FOR_BUILD)" \
                              \
                              TCB_PACKAGE=$* \
                              ACLOCAL_PATH=$(INSTALLROOT_HOST)$(HOST_PREFIX)/share/aclocal

cross.DESTDIR                 ="$(INSTALLROOT_HOST)"

#                              PATH="$($*.PATH):${PATH}:$(HOST_PREFIX)/bin/$(TARGET)"
#
# $(TARGET_PATH):
#                               PATH="$(TARGET_PATH):$(LOCAL_PATH):$($*.PATH):${PATH}"

host.GCC_VERSION_POSTFIX   =    -5

host.ENVIRONMENT   += \
                              CC="gcc$(localcompile.GCC_VERSION_POSTFIX)" \
                              CXX="g++$(localcompile.GCC_VERSION_POSTFIX)" \
                              GCC="gcc$(localcompile.GCC_VERSION_POSTFIX)" \
                              CPPFLAGS="$(CPPFLAGS) $($*.CPPFLAGS) $(CPPFLAGS_FOR_HOST) $($*.CPPFLAGS_FOR_HOST)" \
                              CFLAGS="$(CFLAGS_FOR_HOST) $($*.CFLAGS_FOR_HOST)" \
                              CXXFLAGS="$(CXXFLAGS_FOR_HOST) $($*.CXXFLAGS_FOR_HOST)" \
                              LDFLAGS="$(LDFLAGS_FOR_HOST) $($*.LDFLAGS_FOR_HOST)" \
                              \
                              CFLAGS_FOR_TARGET="$(CFLAGS_FOR_TARGET) $($*.CFLAGS_FOR_TARGET)" \
                              FLAGS_FOR_TARGET="$(FLAGS_FOR_TARGET)" \
                              CXXFLAGS_FOR_TARGET="$(CXXFLAGS_FOR_TARGET) $($*.CXXFLAGS_FOR_TARGET)" \
                              CPPFLAGS_FOR_TARGET="$(CPPFLAGS_FOR_TARGET) $($*.CPPFLAGS_FOR_TARGET)" \
                              LDFLAGS_FOR_TARGET="$(LDFLAGS_FOR_TARGET) $($*.LDFLAGS_FOR_TARGET)" \
                              XGCC_FLAGS_FOR_TARGET="$(XGCC_FLAGS_FOR_TARGET) $($*.XGCC_FLAGS_FOR_TARGET)" \
                              \
                              CFLAGS_FOR_BUILD="$(CFLAGS_FOR_BUILD) $($*.CFLAGS_FOR_BUILD)" \
                              CXXFLAGS_FOR_BUILD="$(CXXFLAGS_FOR_BUILD)  $($*.CXXFLAGS_FOR_BUILD)" \
                              CPPFLAGS_FOR_BUILD="$(CPPFLAGS_FOR_BUILD)  $($*.CPPFLAGS_FOR_BUILD)" \
                              LDFLAGS_FOR_BUILD="$(LDFLAGS_FOR_BUILD)  $($*.LDFLAGS_FOR_BUILD)" \
                              PATH="$(HOSTTOOLS_BIN_PATH):${PATH}:$(LOCAL_PATH):$($*.PATH)" \
                              TCB_PACKAGE=$* \
                              XLD_LIBRARY_PATH="$(HOST_PREFIX)/lib" \
                              XPKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
                              XPKG_CONFIG=$(TARGET_PKG_CONFIG_RUNTIME) \
										XPKG_CONFIG_SYSROOT_DIR=$(SYSROOT_HOST)
                              
host.DESTDIR                  ="$(INSTALLROOT_HOST)"

# $(error PERL $(host.ENVIRONMENT_PERL) )

# LIBTOOL=$(HOSTTOOLS_BIN_PATH)/libtool
#										ACLOCAL_PATH=$(INSTALLROOT_HOST)$(HOST_PREFIX)/share/aclocal \
#										AC_ARG_VAR=fsdfsdfsdf \
#										AC_PATH="lkjlkjlkj" \
#										AUTOM4TE=$(LOCAL_PATH)/autom4te \
#										AUTOM4TE_DEBUG=yes \
#										M4FLAGS="--prepend-include=/usr" \
#										PERL5LIB=$(HOST_PATH)/share/texinfo:$(HOST_PATH)/share/texinfo/lib/libintl-perl/lib:$(HOST_PATH)/share/texinfo/lib/Unicode-EastAsianWidth/lib
#

### DUMMY: Don't print environment if environment is empty
do_export                   = \
                                export $($*.ENVIRONMENT) DUMMY=DUMMY;

implicit_export             = \
										  $($*.ENVIRONMENT) DUMMY=DUMMY

### with sysroot: stm32 works
###               cubie gcc: cannot find /home/mase/wp/obj/tcbuilder3-0.4.7/rootfs-cubie-x86_64/opt/tcb-0.4.7-cubie-x86_64/arm-linux-gnueabihf/lib/libc.so.6 inside /home/mase/wp/obj/tcbuilder3-0.4.7/rootfs-cubie-x86_64/opt/tcb-0.4.7-cubie-x86_64/arm-linux-gnueabihf
### without sysroot: stm32: fatal error: errno.h: No such file or directory
###               cubie: fatal error: linux/limits.h: No such file or directory


# /neccessary for libgcc looking for bintools
LOCAL_PATH		= $(HOST_PATH)$(PREFIX)/bin
# TARGET_PATH		= $(INSTALLROOT)$(PREFIX)/lib/$(TARGET)/bin

### Actually results in PATH environment variable. But because concatenation
### results in an added space character it is quite non-reliable.
### Use %.ENVIRONMENT for reliable environment setting
#PATH                          +=:$(LOCAL_PATH):$(TARGET_PATH)


AS_FOR_TARGET                 =$(TARGET)-as
AR_FOR_TARGET                 =$(TARGET)-ar
LD_FOR_TARGET                 =$(TARGET)-ld
C_FOR_TARGET                  =$(TARGET)-gcc
CC_FOR_TARGET                 =$(TARGET)-gcc
GCC_FOR_TARGET                =$(CROSSTOOLS_BIN_PATH)/$(TARGET)-gcc
CXX_FOR_TARGET                =$(TARGET)-g++
# CXX_FOR_TARGET                =$(TARGET)-gcc
CPP_FOR_TARGET                =$(TARGET)-cpp
NM_FOR_TARGET                 =$(TARGET)-nm
STRIP_FOR_TARGET              =$(TARGET)-strip
OBJCOPY_FOR_TARGET            =$(TARGET)-objcopy
RANLIB_FOR_TARGET             =$(TARGET)-ranlib
OBJDUMP_FOR_TARGET            =$(TARGET)-objdump
DLLTOOL_FOR_TARGET            =$(TARGET)-dlltool
READELF_FOR_TARGET            =$(TARGET)-readelf


#---fin------------------------------------------------------------------------
