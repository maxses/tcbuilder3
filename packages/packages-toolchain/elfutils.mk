#------------------------------------------------------------------------------
#
#  \brief   Elfutils recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20240505> file created
#
#------------------------------------------------------------------------------


elfutils.VERSION					= elfutils-0.196
elfutils.SCM_TOOL             = git
elfutils.SCM_URL              = git://sourceware.org/git/elfutils.git
elfutils.SOURCE_PATH          = elfutils-mainline

$(eval $(call template,elfutils,host))
$(eval $(call useOwnLdNative, elfutils))
$(eval $(call useOwnLdNative, elfutils))

# --without-bzlib : Could be available on host machine but not on 
# --without-lzma
elfutils.CONFIGUREFLAGS       +=	 \
                                 --enable-maintainer-mode \
                                 --disable-debuginfod \
                                 --enable-libdebuginfod=dummy \
                                 --disable-symbol-versioning \
                                 --without-bzlib \
                                 --without-lzma
                                 
elfutils.ENVIRONMENT          +=	 \
                                 $(host.ENVIRONMENT_AUTOTOOLS) \
                                 $(host.ENVIRONMENT_AUTOMAKE) \
                                 $(host.ENVIRONMENT_PERL) \
                                 PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
                                 PKG_CONFIG=$(TARGET_PKG_CONFIG_RUNTIME)

elfutils.CFLAGS_FOR_HOST      += -std=gnu11 -Wno-implicit-function-declaration


elfutils.sourcebase: elfutils.scm_sourcebase
elfutils.sourcetree: elfutils.sourcebase_patched

# There is no 'configure' per default
elfutils.cmi_configure: elfutils.autoreconf zlib-host.issue
elfutils.autoreconf: gettext.issue flex.issue
elfutils.autoreconf: autoconf.issue automake.issue
elfutils.autoreconf: pkg-config.issue zstd_native.issue

elfutils.issue: elfutils.cmi
	$(done)


#---fin------------------------------------------------------------------------
