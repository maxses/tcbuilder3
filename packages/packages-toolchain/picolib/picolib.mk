#------------------------------------------------------------------------------
#
#  \brief   Picolibc recipe tcbuilder
#
#           URL: https://github.com/picolibc/picolibc/releases/
#
#           Picolib is a libc for embedded systems (e.g. microcontroller)
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


#------Info-------------------------------------
#
# crt0.o is providen by picolib-libgloss-nano.
# picolib-libgloss-nano is not build whith "--with-picolib-libgloss-nano".
#
#-----------------------------------------------


picolib.SCM_TOOL                    := git
picolib.SCM_URL                     := https://github.com/picolibc/picolibc.git
picolib.VERSION                     := 1.8.12
picolib.SOURCE_PATH                 := picolib-mainline

picolib-libgloss-nano.VERSION       :=$(picolib.VERSION)
picolib-libgloss-nano.SOURCE_PATH   :=$(picolib.SOURCE_PATH)/picolib-libgloss

$(eval $(call Package,picolib))
$(eval $(call template,picolib,target))
$(eval $(call template,picolib-libgloss-nano,target))

picolib.CFLAGS_FOR_TARGET           = -flto -ffat-lto-objects -fuse-linker-plugin
picolib.LDFLAGS_FOR_TARGET          = -flto -ffat-lto-objects -fuse-linker-plugin

picolib.ADDITIONAL_MAKE_TARGET   =installdirs

picolib-both.MESONFLAGS            += --buildtype=minsize

picolib.MESONFLAGS            +=	\
                                          $(picolib-both.MESONFLAGS) \
                                          -Dformat-default=integer \
                                          -Dio-float-exact=false \
                                          -Dformat-default=integer \
                                          -Dthread-local-storage=false

picolib-libgloss-nano.ENVIRONMENT   += \
                                          CC=$(CROSS_COMPILE)gcc \
                                          AS=$(CROSS_COMPILE)as

picolib-libgloss-nano.MESONFLAGS          += \
                                          $(picolib-both.CONFIGUREFLAGS) \
                                          --libdir=$(TARGET_NONUSR_PREFIX)

picolib.multilib.check: picolib.install
	$(done)

### depencie on static_gcc.issue: making "gcc.clean" let newlib to be rebuild but did not run this target
### "picolib.issue" removes these directories again.
%.picolib.pathes.check: gcc.issue
	@mkdir -p $(SYSROOT_TARGET)/$(TARGET_NONUSR_PREFIX)/lib/{thumb,fpu,armv6-m,armv7-m,armv7e-m,cpu-init}
	@mkdir -p $(SYSROOT_TARGET)/$(TARGET_NONUSR_PREFIX)/lib/armv7e-m/{softfp,fpu}
	@mkdir -p $(SYSROOT_TARGET)/$(TARGET_PREFIX)/include
	$(done)

picolib.preconfigure: gcc.issue
picolib.sourcebase: picolib.scm_sourcebase
picolib.sourcetree: picolib.sourcebase_patched
picolib.install: picolib.meson
picolib.postcheck:   picolib.multilib.check
picolib.meson: picolib.picolib.pathes.check ninja.issue
# picolib.cmi_make_additional_target
picolib.meson: texinfo.issue

picolib-libgloss-nano.sourcebase:    picolib.sourcebase
### picolib-libgloss-nano needs libc/picolib headers
picolib-libgloss-nano.preconfigure:   picolib.issue
picolib-libgloss-nano.issue:         picolib-libgloss-nano.meson

picolib.issue: picolib.skeleton
	@mkdir -p $(SYSROOT_TARGET)/$(TARGET_PREFIX)/include
	$(done)

### picolib-libgloss doe not have any headers
picolib-libgloss-nano.issue: picolib-libgloss-nano.skeleton
	@mkdir -p $(SYSROOT_TARGET)/$(TARGET_NONUSR_PREFIX)/lib
	$(done)

picolib_libc.issue: picolib.issue
	$(done)

# When GCC compiles from scratch, it need Libc-Headers for target. 
# Just copy all headers Meson has to be run to generate an (probably wrong)
# picolibc.h which also must be copied to the targets headers.
picolib_libc_headers.issue: picolib.sourcetree meson.issue
	@mkdir -p $(SYSROOT_TARGET)/$(TARGET_PREFIX)/include
	@cp -rf $(SOURCE_PATH)/$(picolib.SOURCE_PATH)/libc/include/* \
		$(SYSROOT_TARGET)/$(TARGET_PREFIX)/include
	@cd $(SOURCE_PATH)/$(picolib.SOURCE_PATH); \
		meson $(BUILD_PATH)/picolib_libc_headers-$(picolib.VERSION) &> $(LOG_PATH)/picolib_libc_headers_meson.log
	@cp $(BUILD_PATH)/picolib_libc_headers-$(picolib.VERSION)/picolibc.h \
		$(SYSROOT_TARGET)/$(TARGET_PREFIX)/include
	$(done)


#---fin------------------------------------------------------------------------
