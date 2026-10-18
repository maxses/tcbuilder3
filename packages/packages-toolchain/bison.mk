#------------------------------------------------------------------------------
#
#  \brief   Bison recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


bison.VERSION         = 3.8.2
bison.ARCHIVE_FILE    = bison-$(bison.VERSION).tar.xz
bison.ARCHIVE_URL     = $(GNU_MIRROR)/bison//$(bison.ARCHIVE_FILE)
bison.SOURCE_PATH     = bison-$(bison.VERSION)

$(eval $(call Package,bison))
$(eval $(call template,bison,host))

bison.sourcebase: bison.archive_sourcebase
bison.sourcetree: bison.sourcebase_patched
bison.install: bison.cmi
bison.cmi_configure: m4.issue

bison.issue: bison.skeleton
	$(done)


#---fin------------------------------------------------------------------------
