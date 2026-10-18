#------------------------------------------------------------------------------
#
#  \brief   help2man package recipe for tcbuilder
#
#           URL: http://ftpmirror.gnu.org/help2man
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


help2man.VERSION         =1.49.3
help2man.ARCHIVE_FILE    =help2man-$(help2man.VERSION).tar.xz
help2man.ARCHIVE_URL     =http://ftpmirror.gnu.org/help2man/$(help2man.ARCHIVE_FILE)
help2man.SOURCE_PATH     =help2man-$(help2man.VERSION)

$(eval $(call Package,help2man))
$(eval $(call template,help2man,host))

### help2man does not depend on anything from the toolchain, not even binutils
help2man.sourcebase: help2man.archive_sourcebase
help2man.sourcetree: help2man.sourcebase_patched
help2man.install: help2man.cmi

help2man.issue: help2man.skeleton
	$(done)


#---fin------------------------------------------------------------------------
