#------------------------------------------------------------------------------
#
#  \brief   Flex recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20240505> file created
#
#------------------------------------------------------------------------------


flex.VERSION				  = v2.6.4
flex.SCM_TOOL             = git
flex.SCM_URL              = https://github.com/westes/flex
flex.SOURCE_PATH          = flex-mainline

$(eval $(call template,flex,host))

# _lt_pkgdatadir: Force libtool files from sysroot.
flex.ENVIRONMENT          +=	 \
                                 $(host.ENVIRONMENT_AUTOTOOLS) \
                                 $(host.ENVIRONMENT_AUTOMAKE) \
                                 $(host.ENVIRONMENT_PERL) \
 				_lt_pkgdatadir=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share/libtool

flex.cmi_configure: $(AUTOTOOLS)
flex.sourcebase: flex.scm_sourcebase
flex.sourcetree: flex.sourcebase_patched
flex.autoreconf: $(AUTOTOOLS) gettext.issue
# texinfo is needed to provide 'makeinfo'
flex.cmi_configure: flex.autoreconf pkg-config.issue texinfo.issue help2man.issue

flex.issue: flex.cmi
	$(done)


#---fin------------------------------------------------------------------------
