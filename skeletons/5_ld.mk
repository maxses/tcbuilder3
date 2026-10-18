#------------------------------------------------------------------------------
#
# \brief    Let packages use the own ld
#
#           Necessarry to use own created host libraries instead of liobaries 
#           of the host system
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20240516> file created
#
#------------------------------------------------------------------------------


useOwnLd.FLAGS             = \
            -Wl,--dynamic-linker=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/lib/ld-linux-x86-64.so.2 \
            -Wl,-L"$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/lib" \
            -Wl,-L"$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/usr/lib" \
            --sysroot=$(INSTALLROOT_HOST)$(TARGET_NONUSR_PREFIX)

# "-B" is needed to actually use the sysroot. Otherwise only header from sysroot are used but not 
# libraries.
useOwnLdNative.FLAGS             = \
            -Wl,--dynamic-linker=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/lib/ld-linux-x86-64.so.2 \
            -Wl,-L"$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/lib" \
            -B$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/lib \
            -Wl,-L"$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/usr/lib" \
            -B$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/usr/lib \
            --sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)

define useOwnLd

   $1.LDFLAGS_FOR_HOST			+= \
                     $(useOwnLd.FLAGS) \
                     -Wl,--sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)

   $1.CFLAGS_FOR_HOST      += \
                  --sysroot=$(INSTALLROOT_HOST)$(TARGET_NONUSR_PREFIX)

   $1.CXXFLAGS_FOR_HOST    += \
                  --sysroot=$(INSTALLROOT_HOST)$(TARGET_NONUSR_PREFIX)

$1.preconfigure: glibc_native.issue

endef

define useOwnLdTarget

   $1.LDFLAGS_FOR_BUILD			+= \
                     $(useOwnLd.FLAGS) \
                     -Wl,--sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) \
                     -Wl,-L/usr/lib/x86_64-linux-gnu

   $1.CFLAGS_FOR_BUILD			+= \
                     $(useOwnLd.FLAGS) \
                     -Wl,--sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) \
                     -Wl,-L/usr/lib/x86_64-linux-gnu
$1.preconfigure: glibc_native.issue

endef

define useOwnLdNative

   $1.LDFLAGS_FOR_HOST			+= \
                     $(useOwnLdNative.FLAGS) \
                     -Wl,--sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) \
                     -Wl,-L/xusr/lib/x86_64-linux-gnu

   $1.LDFLAGS			+= \
                  $(useOwnLdNative.FLAGS) \
                  -Wl,--sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) \
                  -Wl,-L/xusr/lib/x86_64-linux-gnu

   $1.CFLAGS_FOR_HOST      += \
                  --sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)

   $1.CFLAGS      += \
                  --sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)

   $1.CXXFLAGS_FOR_HOST    += \
                  --sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)

   $1.CXXFLAGS    += \
                  --sysroot=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)

$1.preconfigure: glibc_native.issue

endef


#---fin------------------------------------------------------------------------
