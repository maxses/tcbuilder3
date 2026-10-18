#------------------------------------------------------------------------------
#
#  \brief   Gettext recipe for tcbuilder
#
#           URL: http://ftpmirror.gnu.org/gettext
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


gettext.VERSION         = 1.0
gettext.ARCHIVE_FILE    = gettext-$(gettext.VERSION).tar.xz
gettext.ARCHIVE_URL     = $(GNU_MIRROR)/gettext/$(gettext.ARCHIVE_FILE)
gettext.SOURCE_PATH     = gettext-$(gettext.VERSION)

$(eval $(call Package,gettext))


gettext.CONFIGUREFLAGS      = $(host.CONFIGUREFLAGS)
gettext.ENVIRONMENT         = $(host.ENVIRONMENT)
gettext.DESTDIR             = $(host.DESTDIR)


gettext.sourcebase: gettext.archive_sourcebase
gettext.sourcetree: gettext.sourcebase_patched
gettext.install: gettext.cmi

gettext.issue: gettext.skeleton
	$(done)


#---fin------------------------------------------------------------------------
