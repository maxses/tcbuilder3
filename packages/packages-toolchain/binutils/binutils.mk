#-----------------------------------------------------------------------------
#
#  \brief   Binutils recipe for tcbuilder
#
#           URL: https://www.gnu.org/software/binutils/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#-----------------------------------------------------------------------------


# binutils >=2.44 - Unknown destination type (ARM/Thumb) und dangerous/unsupported relocation
# https://www.mikrocontroller.net/topic/577596
# https://community.arm.com/support-forums/f/compilers-and-libraries-forum/57077/binutils-2-44-and-gcc-15-1-0---dangerous-relocation-unsupported-relocation-error-when-trying-to-build-u-boot
#
# Discussion about LTO and missing symbols:
#    https://github.com/riscv-collab/riscv-gnu-toolchain/issues/758

binutils.VERSION                 =	binutils-2_47
binutils.SCM_TOOL                =	git
binutils.SCM_URL                 =	https://sourceware.org/git/binutils-gdb.git
binutils.SOURCE_PATH             =	binutils-mainline
$(eval $(call Package, binutils))
$(eval $(call useOwnLd, binutils))
$(eval $(call template,binutils,cross))

binutils.CONFIGUREFLAGS             += --enable-bootstrap=no \
                                        --enable-plugins \
													 --enable-lto \
													 --enable-compressed-debug-sections=all \
													 --disable-gdb \
													 $(gcc.MULTILIB) \
													 --with-system-readline

# 													 --enable-gold

binutils.ENVIRONMENT                += $(host.ENVIRONMENT_PERL)

binutils.PRECEDENT_TARGET                = -C gold yyscript.h


binutils.sourcebase: binutils.scm_sourcebase
binutils.sourcetree: binutils.sourcebase_patched
binutils.install: binutils.cmi
binutils.cmi_configure: libtool.issue bison.issue gmp.issue mpfr.issue zstd_native.issue
# ncurses-host: libtinfo is needed in smi/configure
binutils.cmi_configure: elfutils.issue glibc_native.issue ncurses-host.issue
# binutils.autoreconf
# binutils.cmi_make: binutils.cmi_make_precedent_target
# binutils.cmi_make: binutils.binutils.yyscript.hook
binutils.cmi_make: texinfo.issue binutils.ldconfig2.custom_step
binutils.cmi_make: binutils.binutils.ldlex.hook binutils.binutils.doc.hook

$(eval $(call useOwnLd, binutils))
# $(eval $(call useOwnLdTarget, binutils))
$(eval $(call useOwnLdNative, binutils))

binutils.ldconfig2.custom_step: binutils.cmi_configure
	@#echo "$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/lib" > $(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/etc/ld.so.conf
	@#echo "$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/usr/lib" >> $(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/etc/ld.so.conf
	@#$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/sbin/ldconfig
	$(silentDone)

# -C gold yyscript.c

# Compile these files via bison manually
# It has to be compiled in the build path and copied to the source path
%.binutils.yyscript.hook: binutils.cmi_configure
	$(call lHint,Start compiling yyscript for $*)
	@rm -f $(SOURCE_PATH)/$($*.SOURCE_PATH)/gold/yyscript.[c,h]; ( \
	cd $(BUILD_PATH)/$*-$($*.VERSION); \
	$(MAKE) configure-gold; \
	cd $(BUILD_PATH)/$*-$($*.VERSION); \
	$(MAKE) -C gold yyscript.h; \
	mv gold/yyscript.[c,h] $(SOURCE_PATH)/$($*.SOURCE_PATH)/gold \
	) $(LOG_REDIRECT)
	$(silentDone)

# issue of binutils 2.40: folder gas/doc in build directory may not exist when
# it want wo install files there
%.binutils.doc.hook: binutils.cmi_configure
	@mkdir -p $(BUILD_PATH)/$*-$($*.VERSION)/gas/doc
	$(silentDone)

%.binutils.ldlex.hook: binutils.cmi_configure
	@#rm -f $(SOURCE_PATH)/$($*.SOURCE_PATH)/ld/ldlex.c
	@#touch $(SOURCE_PATH)/$($*.SOURCE_PATH)/ld/ldlex.l
	@touch $(SOURCE_PATH)/$($*.SOURCE_PATH)/ld/ldgram.y
	$(silentDone)

binutils.issue: binutils.skeleton
	@# Show interpreter for debug issues
	@# patchelf $(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX)/usr/bin/arm-none-eabi/arm-none-eabi-ld
	@#		--print-interpreter
	$(done)


#---fin------------------------------------------------------------------------
