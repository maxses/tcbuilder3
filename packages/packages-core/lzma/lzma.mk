#------------------------------------------------------------------------------
#
#  \brief   Lzma/xv recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261017> file created
#
#------------------------------------------------------------------------------


lzma.VERSION							= v5.8.4
lzma.SCM_TOOL							= git
lzma.SCM_URL							= https://github.com/tukaani-project/xz.git
lzma.SOURCE_PATH				    	= lzma-mainline
# lzma.CONFIGUREFLAGS				 	= $(target.CONFIGUREFLAGS) \
#  											--enable-shared
# lzma.ENVIRONMENT					 	= $(target.ENVIRONMENT)

# lzma-host.CONFIGUREFLAGS			= $(host.CONFIGUREFLAGS) \
#											--enable-shared
lzma-host.SOURCE_PATH				= $(lzma.SOURCE_PATH)
lzma-host.AUTOGEN_ARGS				= --no-po4a

$(eval $(call template,lzma-host,host))
# useOwnLdNative: The tool xz is also created which should not use hosts liblzma.
$(eval $(call useOwnLdNative, lzma-host))


lzma-host.ENVIRONMENT				+=	$(host.ENVIRONMENT) \
												$(host.ENVIRONMENT_AUTOTOOLS) \
												$(host.ENVIRONMENT_AUTOMAKE) \
												$(host.ENVIRONMENT_PERL) \
							LIBTOOL=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/usr/bin/libtool \
                                                	LIBTOOLIZE=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/usr/bin/libtoolize \
							_lt_pkgdatadir=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share/libtool

lzma-host.CONFIGUREFLAGS			+= --enable-liblzma

lzma.sourcebase: lzma.scm_sourcebase
lzma-host.sourcebase: lzma.sourcebase


lzma.issue: lzma.cmi
	$(done)

lzma-host.cmi_configure: lzma-host.autogen
# gettext: autopoint needed
lzma-host.autogen: gettext.issue
lzma-host.install: lzma-host.cmi
lzma-host.veryclean: lzma.veryclean

lzma-host.issue: lzma-host.skeleton lzma-host.cmi_make_install
	$(RUN_LDCONFIG)
	$(done)


#---fin------------------------------------------------------------------------
