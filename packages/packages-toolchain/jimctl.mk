#------------------------------------------------------------------------------
#
#  \brief   Jimctl recipe for tcbuilder
#
#           Not used at the moment. Its shipped in the OpenOCD repo as git 
#				submodule.
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261014> file created
#
#------------------------------------------------------------------------------


# Current version is 0.84. But openocd 0.12.0 needs "currentScriptObj".
# jimctl.VERSION							= 0.82
# jimctl.VERSION							= 5bac7c99ad65864c87da513e22e2f01703fa4e03
jimctl.VERSION							= 1933e5457b9512d39ebbe11ed32578aada149f49
jimctl.SCM_TOOL						= git
jimctl.SCM_URL							= https://github.com/msteveb/jimtcl.git
jimctl.SOURCE_PATH					= jimctl-mainline

jimctl.sourcebase: jimctl.scm_sourcebase
jimctl.sourcetree: jimctl.sourcebase_patched
jimctl.cmi_configure: automake.issue
jimctl.cmi_configure: python-host.issue libusb-host.issue pkg-config.issue
jimctl.install: jimctl.cmi
# jimctl.cmi_configure: jimctl.autoreconf

jimctl.CONFIGUREFLAGS				=	--prefix=/usr
# $(host.CONFIGUREFLAGS)
jimctl.ENVIRONMENT					=	$(host.ENVIRONMENT) \
													$(host.ENVIRONMENT_AUTOTOOLS) \
													$(host.ENVIRONMENT_AUTOMAKE) \
													$(host.ENVIRONMENT_PERL)
jimctl.DESTDIR						=	$(host.DESTDIR)

# jimctl.bootstrap: libtool.issue automake.issue

# openocd.test:
# 	echo "PKG_CONFIG_PATH=$(HOST_PREFIX)/lib/pkgconfig"
#  openocd.test

jimctl.issue: jimctl.skeleton
	$(done)


#---fin------------------------------------------------------------------------
