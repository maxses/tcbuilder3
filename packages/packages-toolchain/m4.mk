#------------------------------------------------------------------------------
#
#  \brief   M4 recipe for tcbuilder
#
#           URL: http://ftp.wrz.de/pub/gnu/m4
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


m4.VERSION         = 1.4.21
m4.ARCHIVE_FILE    = m4-$(m4.VERSION).tar.xz
m4.ARCHIVE_URL     = $(GNU_MIRROR)/m4/$(m4.ARCHIVE_FILE)
m4.SOURCE_PATH     = m4-$(m4.VERSION)

$(eval $(call Package,m4))
$(eval $(call template,m4,host))

m4.sourcebase: m4.archive_sourcebase
m4.sourcetree: m4.sourcebase_patched
m4.install: m4.cmi

m4.issue: m4.skeleton
	$(done)


#---fin------------------------------------------------------------------------
