#-----------------------------------------------------------------------------
#
#  \brief   CCache recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20150928> file created
#
#-----------------------------------------------------------------------------


ccache.VERSION                    =	4.14.1
ccache.ARCHIVE_FILE               =	ccache-$(ccache.VERSION).tar.gz
ccache.ARCHIVE_URL                =	https://github.com/ccache/ccache/releases/download/v$(ccache.VERSION)/$(ccache.ARCHIVE_FILE)
ccache.SOURCE_PATH                =	ccache-$(ccache.VERSION)


$(eval $(call template,ccache,cross))

ccache.CONFIGUREFLAGS             += \
                                        --enable-bootstrap=no \
                                        \
                                        \
                                        $(gcc.MULTILIB)

ccache.CMAKE_ARGS						+= \
													 -DREDIS_STORAGE_BACKEND=OFF

$(eval $(call Package,ccache))


ccache.sourcebase: ccache.archive_sourcebase
ccache.sourcetree: ccache.sourcebase_patched
ccache.install: ccache.cmake
# ccache.cmi_configure: libtool.issue


ccache.issue: ccache.skeleton
	$(done)


#---fin------------------------------------------------------------------------
