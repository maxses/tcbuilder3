#------------------------------------------------------------------------------
#
#  \brief   GCC recipe for tcbuilder3
#
#           The different stages static_gcc/minimal_gcc/gcc are not needed any 
#           more
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


gcc.VERSION             = releases/gcc-16.2.0
gcc.PATCH_POSTFIX       = -16
gcc.SCM_TOOL            = git
gcc.SCM_URL             = https://gcc.gnu.org/git/gcc.git

gcc.SOURCE_PATH         = gcc-mainline
$(eval $(call Package,gcc))
$(eval $(call template,gcc,cross))
$(eval $(call useOwnLd, gcc))
$(eval $(call useOwnLdTarget, gcc))
$(eval $(call useOwnLdNative, gcc))
$(eval $(call template, libcxx, host))
$(eval $(call useOwnLdNative, libcxx))

# libgomp, libatomic, libitm, libsanitizer: only available for native build
gcc.BASE_CONFIGUREFLAGS            = 	\
                                 $(cross.CONFIGUREFLAGS) \
                                 $(gcc.MULTILIB) \
                                 --disable-libatomic \
                                 --disable-libgomp \
                                 --disable-libitm \
                                 --disable-libsanitizer \
                                 --with-isl \
                                 --enable-nls \
                                 --disable-vtable-verify \
                                 --disable-checking \
                                 --disable-stage1-checking
                                 
#                                 --cache-file=$(BUILD_PATH)/tcb-config-gcc.cache
#                                 build_configargs="--cache-file=$(BUILD_PATH)/tcb-config-gcc-build.cache" \
#                                 host_configargs="--cache-file=$(BUILD_PATH)/tcb-config-gcc-host.cache" \
#                                 target_configargs="--cache-file=tcb-config-gcc-target.cache"


### --with-system-zlib: It is already compiled
gcc.CONFIGUREFLAGS            += 	\
                                 $(gcc.BASE_CONFIGUREFLAGS) \
                                 --enable-languages=c,c++ \
                                 --enable-bootstrap=no \
                                 --enable-libssp \
                                 --with-system-zlib \
                                 --enable-shared \
                                 --enable-host-shared \
                                 --enable-lto \
                                 --enable-plugin \
                                 --enable-liboffloadmic=target \
                                 --enable-threads \
                                 --disable-bootstrap


#------Targets----------------------------------


gcc.init: glibc_native.issue libtool.issue linux_headers-native.issue
gcc.cmi_configure: flex.issue gawk.issue

gcc.limits_fix.hook: gcc.install gcc.cmi_make_install
		@[ -e "$(gcc.LIMITS_PATH)/limits_org.h" ] || cp "$(gcc.LIMITS_PATH)/limits.h" "$(gcc.LIMITS_PATH)/limits_org.h"
		@rm -f "$(gcc.LIMITS_PATH)/limits.h"
		@cat "$(OPWD)/data/limits_header.h" >> "$(gcc.LIMITS_PATH)/limits.h"
		@cat "$(gcc.LIMITS_PATH)/limits_org.h" >> "$(gcc.LIMITS_PATH)/limits.h"
		@cat "$(OPWD)/data/limits_footer.h" >> "$(gcc.LIMITS_PATH)/limits.h"
		$(silentDone)

gcc.dir_patch_org.hook: gcc.sourcetree
		@cd $(SOURCE_PATH)/$(gcc.SOURCE_PATH); \
		for file in \
		$$(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h); \
		do \
		  cp -u $$file{,.orig}; \
		sed -e 's@/lib\(64\)\?\(32\)\?/ld@$(HOST_PREFIX)&@g' \
		-e 's@/usr@$(HOST_PREFIX)@g' $$file.orig > $$file; \
		echo "#undef STANDARD_STARTFILE_PREFIX_1" >> $$file; \
		echo "#undef STANDARD_STARTFILE_PREFIX_2" >> $$file; \
		echo "#define STANDARD_STARTFILE_PREFIX_1 \"$(HOST_PREFIX)/lib/\"" >> $$file; \
		echo "#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $$file; \
		touch $$file.orig; \
		done
		$(silentDone)


#------Rules------------------------------------

gcc.preconfigure:         mpc.issue mpfr.issue gmp.issue binutils.issue isl.issue
gcc.prebuild:            zlib-host.issue

gcc.sourcebase:                 gcc.scm_sourcebase
gcc.sourcetree:                 gcc.sourcebase_patched
gcc.preconfigure:               mpc.issue mpfr.issue gmp.issue binutils.issue isl.issue
gcc.cmi_make:                   libc_headers.issue
gcc.cmi_make:                   libc_headers.issue

#-- We need to copy libstdc++ from host to target sysroot
gcc.issue: gcc.cmi gcc.postcheck gcc.skeleton
	@cp $(SYSROOT_HOST)/$(HOST_PREFIX)/lib/$(TARGET)/lib/libstdc++* \
		$(SYSROOT_TARGET)/$(TARGET_PREFIX)/lib
	@cp $(SYSROOT_HOST)/$(HOST_PREFIX)/lib/$(TARGET)/lib/libsupc++* \
			$(SYSROOT_TARGET)/$(TARGET_PREFIX)/lib
	@cp $(SYSROOT_HOST)/$(HOST_PREFIX)/lib/$(TARGET)/lib/libssp* \
			$(SYSROOT_TARGET)/$(TARGET_PREFIX)/lib
	@### Not available for multilib e.g. stm32
	@cp $(SYSROOT_HOST)/$(HOST_PREFIX)/lib/$(TARGET)/lib/libgcc* \
			$(SYSROOT_TARGET)/$(TARGET_PREFIX)/lib &> /dev/null || true
	$(done)


#--- libstdc++ ----------------------------------

# There are some race conditions when building libstdc++-v3 directly.
# (binary gcc/xgcc missing).
# The make targets have to be created in this order:
#     configure-stage1-gcc
#     all-stage1-gcc
#     all-target-libgcc
#     configure-target
#     all-target-libstdc++-v3
#     install-target-libstdc++-v3

libcxx.CONFIGUREFLAGS	= \
            $(host.CONFIGUREFLAGS) \
            --disable-multilib \
            --enable-languages=c++ \
            --enable-shared \
            --disable-plugin \
            --disable-libatomic \
            --enable-threads \
            --without-zstd \
				--disable-checking \
				--disable-stage1-checking

libcxx.DESTDIR	=        $(host.DESTDIR)

#libcxx.ENVIRONMENT	+=  \
#                        DESTDIR="$(INSTALLROOT_HOST)" \
#			LDFLAGS="$(useOwnLdNative.FLAGS)" \
#			LDFLAGS_FOR_BUILD="$(useOwnLdNative.FLAGS)" \
#			CFLAGS="$(useOwnLdNative.FLAGS)" \
#			CFLAGS_FOR_BUILD="$(useOwnLdNative.FLAGS)" \
#			CXXFLAGS="$(useOwnLdNative.FLAGS)" \
#			CXXFLAGS_FOR_BUILD="$(useOwnLdNative.FLAGS)"

libcxx.VERSION             = $(gcc.VERSION)

libcxx.sourcetree:         gcc.sourcetree
libcxx.veryclean:          gcc.veryclean
libcxx.cmi_configure:      linux_headers-native.issue
libcxx.SOURCE_PATH         =	$(gcc.SOURCE_PATH)
libcxx.NO_MAKE_INSTALL     = yes
libcxx.ADDITIONAL_MAKE_INSTALL_TARGETS	    = install-target-libstdc++-v3

libcxx.MAKE_TARGET               = configure-stage1-gcc

libcxx.cmi_make_install:   libcxx.libcxx_stages.custom_step

# zstd_native.issue needs cmake which needs libcxx
%.libcxx_stages.custom_step: libcxx.cmi_make
	@# libisl may not get updated
	$(RUN_LDCONFIG)
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) export &> exports.log
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) all-stage1-gcc &> make_all-stage1-gcc.log
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) all-target-libgcc &> make_all-target-libgcc.log
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) configure-target &> make_configure-target.log
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) all-target-libstdc++-v3 &> make_all-target-libstdc++-v3.log
	$(done)

libcxx.MAKE_INSTALL_TARGETS = install-target-libstdc++-v3

libcxx.issue: libcxx.cmi
	$(RUN_LDCONFIG)
	$(done)
	
libcxx.cmi_configure: mpc.issue mpfr.issue gmp.issue glibc_native.issue

# texinfo is needed to provide 'makeinfo'
libcxx.cmi_configure: texinfo.issue

#--- native-gcc --------------------------------------------------------------

gcc_native.SOURCE_PATH     	=	$(gcc.SOURCE_PATH)/libstdc++-v3
gcc_native.VERSION      		=	$(gcc.VERSION)
gcc_native.ENVIRONMENT      =	 DESTDIR="$(INSTALLROOT_HOST)" \
										 LD_LIBRARY_PATH="$(SYSROOT_HOST)$(HOST_NONUSR_PREFIX)/usr/lib64"

gcc_native.CPPFLAGS			=	-I$(SYSROOT_HOST)/$(HOST_PREFIX)/include
gcc_native.CFLAGS			=	-I$(SYSROOT_HOST)/$(HOST_PREFIX)/include
gcc_native.CXXFLAGS			=	-I$(SYSROOT_HOST)/$(HOST_PREFIX)/include -fpermissive
gcc_native.CONFIGUREFLAGS	=	--prefix=$(HOST_PREFIX) \
										--with-gmp=$(SYSROOT_HOST)/$(HOST_PREFIX) \
										--with-mpfr=$(SYSROOT_HOST)/$(HOST_PREFIX) \
										--with-mpc=$(SYSROOT_HOST)/$(HOST_PREFIX) \
										--with-libtool-sysroot=$(SYSROOT_HOST)/$(HOST_NONUSR_PREFIX) \
										--with-sysroot=$(SYSROOT_HOST) \
										--with-build-sysroot=$(SYSROOT_HOST) \
										--enable-checking=no \
										--enable-languages=c,c++ \
										--build=x86_64-linux-gnu \
										--host=x86_64-linux-gnu \
										--target=x86_64-linux-gnu \
										--disable-multilib

gcc_native.issue: gcc_native.cmi
	$(node)


#---fin------------------------------------------------------------------------
