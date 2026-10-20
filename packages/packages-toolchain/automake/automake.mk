#------------------------------------------------------------------------------
#
#  \brief   Automake recipe for tcbuilder
#
#           URL: http://ftpmirror.gnu.org/automake/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


automake.VERSION         =1.19
automake.BASE_VERSION    =1.19
automake.ARCHIVE_FILE    =automake-$(automake.VERSION).tar.xz
automake.ARCHIVE_URL     =https://ftpmirror.gnu.org/automake/$(automake.ARCHIVE_FILE)
automake.SOURCE_PATH     =automake-$(automake.VERSION)


$(eval $(call Package,automake))
$(eval $(call template,automake,host))

automake.ENVIRONMENT         += $(host.ENVIRONMENT_AUTOTOOLS) \
											PERL5LIB=$(HOST_PATH)/share/texinfo:$(HOST_PATH)/share/texinfo/lib/libintl-perl/lib$\
												:$(HOST_PATH)/share/texinfo/lib/Unicode-EastAsianWidth/lib$\
												:$(HOST_PATH)/share/automake-$(automake.BASE_VERSION)$\
												:$(HOST_PATH)/share/autoconf$\
												:$(HOST_PATH)/lib/perl5/5.36.0

# Yes, ACLOCAL comes via automake

host.ENVIRONMENT_AUTOMAKE     = PERL5LIB=$(HOST_PATH)/share/automake-$(automake.BASE_VERSION) \
										 AUTOMAKE_UNINSTALLED=yes \
										 AUTOMAKE_LIBDIR=$(HOST_PATH)/share/automake-$(automake.BASE_VERSION) \
										 ACLOCAL_AUTOMAKE_DIR=$(HOST_PATH)/share/aclocal-$(automake.BASE_VERSION) \
										 ACLOCAL_PATH=$(HOST_PATH)/share/aclocal-$(automake.BASE_VERSION):$(HOST_PATH)/share/aclocal \
										 ACLOCAL_AUTOMAKE_DIR=$(HOST_PATH)/share/aclocal-$(automake.BASE_VERSION)


automake.sourcebase: automake.archive_sourcebase
automake.sourcetree: automake.sourcebase_patched
automake.install: automake.cmi
automake.cmi_configure: m4.issue autoconf.issue

automake.issue: automake.skeleton
	$(done)


#---fin------------------------------------------------------------------------
