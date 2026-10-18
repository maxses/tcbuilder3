#------------------------------------------------------------------------------
#
#  \brief   ZLlib package recipe for tcbuilder
#
#           URL: https://www.zlib.net/
#
#           * can not be build out of source tree; sources have to be copied
#           * configure shows error but library gets compiled
#           * configure quite trivial, does not support host,build etc
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


### It does not copy the pc file. We make that in "copy_pc.hook".

zlib.VERSION						=1.3.2
zlib.ARCHIVE_FILE					=zlib-$(zlib.VERSION).tar.gz
zlib.ARCHIVE_URL					=http://zlib.net//$(zlib.ARCHIVE_FILE)
zlib.ENTRY_PATH					=zlib-$(zlib.VERSION)
zlib.SOURCE_PATH					=zlib-$(zlib.VERSION)
zlib.CONFIGUREFLAGS				= \
										$(target.CONFIGUREFLAGS)
zlib.CMAKE_ARGS					= \
								-DCMAKE_INSTALL_PREFIX=$(TARGET_NONUSR_PATH) \
								-DCMAKE_INSTALL_LIBDIR=lib \
								-DCMAKE_C_COMPILER_WORKS=1 \
								-DCMAKE_CXX_COMPILER_WORKS=1 \
								-DENABLE_EXPORTS=0 \
								-DCMAKE_SYSTEM_PROCESSOR=arm \
								-DCMAKE_SHARED_LIBRARY_LINK_C_FLAGS="" \
								-DCMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS="" \
								$(target.CMAKE_ARGS) \
								$(default.CMAKE_ARGS)

zlib.ENVIRONMENT					=$(target.ENVIRONMENT)


$(eval $(call template,zlib-host,host))

zlib-host.VERSION             =$(zlib.VERSION)
zlib-host.CMAKE_ARGS				= \
										-DCMAKE_INSTALL_PREFIX=$(HOST_PREFIX) \
										-DCMAKE_INSTALL_LIBDIR=lib
zlib-host.SOURCE_PATH				=$(zlib.SOURCE_PATH)

PACKAGES                      += zlib zlib-host


zlib.sourcebase: zlib.archive_sourcebase
zlib.install: zlib.cmake_install
zlib.cmake_configure: gcc.issue

zlib-host.sourcebase: zlib.sourcebase

### Still true 20171008
#%.zlib.copy_pc.hook: %.install
#		@mkdir -p $(TARGET_PKG_CONFIG_PATH)
#		@cd $(BUILD_PATH)/$*-$($*.VERSION); cp $*.pc $(TARGET_PKG_CONFIG_FILE)
#		$(silentDone)

# zlib.zlib.copy_pc.hook
zlib.issue: zlib.cmake
	$(done)

zlib-host.issue: zlib-host.cmake
	$(done)


#---fin------------------------------------------------------------------------
