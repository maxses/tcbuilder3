#------------------------------------------------------------------------------
#
#  \brief   ZStd package recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20240505> file created
#
#------------------------------------------------------------------------------


zstd.VERSION					= v1.5.7
zstd.SCM_TOOL              = git
zstd.SCM_URL               = https://github.com/facebook/zstd.git
zstd.SOURCE_PATH           = zstd-mainline

$(eval $(call template,zstd_native,host))

zstd_native.VERSION			= $(zstd.VERSION)
zstd_native.SOURCE_PATH		= $(zstd.SOURCE_PATH)


# In this scxenario, the argument with the build path is the destination for
# created Makefiles. The camke skeleton will further add an argument with 
# the soure directory which will be ignored
zstd_native.CMAKE_ARGS        =	$(host.CMAKE_ARGS) \
                              -S$(SOURCE_PATH)/$($*.SOURCE_PATH)/build/cmake \
                              $(BUILD_PATH)/$*-$($*.VERSION)

zstd.sourcebase: zstd.scm_sourcebase
zstd.sourcetree: zstd.sourcebase_patched

zstd_native.sourcetree: zstd.sourcetree

zstd_native.cmake_make: glibc_native.issue
zstd_native.issue: zstd_native.cmake
	$(done)

zstd_native.veryclean: zstd.veryclean


#---fin------------------------------------------------------------------------
