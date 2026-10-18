#------------------------------------------------------------------------------
#
#  \brief   Libjaylink recipe for tcbuilder
#
#           Not used at the moment. Its shipped in the OpenOCD repo as git 
#				submodule.
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20151208> file created
#
#------------------------------------------------------------------------------


libjaylink.VERSION						= 0.5.0
libjaylink.SCM_TOOL						= git
libjaylink.SCM_URL						= https://repo.or.cz/libjaylink.git
libjaylink.SOURCE_PATH					= libjaylink-mainline

libjaylink.sourcebase: libjaylink.scm_sourcebase
libjaylink.sourcetree: libjaylink.sourcebase_patched
libjaylink.cmi_configure: automake.issue
libjaylink.cmi_configure: python-host.issue libusb-host.issue pkg-config.issue
libjaylink.install: libjaylink.cmi
libjaylink.cmi_configure: libjaylink.autoreconf

libjaylink.CONFIGUREFLAGS				=	$(host.CONFIGUREFLAGS)
libjaylink.ENVIRONMENT					=	$(host.ENVIRONMENT) \
													$(host.ENVIRONMENT_AUTOTOOLS) \
													$(host.ENVIRONMENT_AUTOMAKE) \
													$(host.ENVIRONMENT_PERL)
libjaylink.DESTDIR						=	$(host.DESTDIR)

# libjaylink.bootstrap: libtool.issue automake.issue

# openocd.test:
# 	echo "PKG_CONFIG_PATH=$(HOST_PREFIX)/lib/pkgconfig"
#  openocd.test

libjaylink.issue: libjaylink.skeleton
	$(done)


#---fin------------------------------------------------------------------------
