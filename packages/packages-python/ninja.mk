#------------------------------------------------------------------------------
#
#  \brief   Ninja-build recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261017> file created
#
#------------------------------------------------------------------------------


ninja.VERSION			= v1.13.2
ninja.SCM_TOOL			= git
ninja.SCM_URL			= https://github.com/ninja-build/ninja.git
ninja.SOURCE_PATH		= ninja-$(ninja.VERSION)
ninja.CMAKE_ARGS     = $(host.CMAKE_ARGS)

$(eval $(call template, ninja, host))
$(eval $(call useOwnLdNative, ninja))

ninja.DESTDIR        = $(host.DESTDIR)
ninja.ENVIRONMENT        = $(host.ENVIRONMENT)

ninja.sourcebase: ninja.scm_sourcebase
ninja.cmake_configure: cmake_host.issue

ninja.issue: ninja.cmake
	$(done)


#---fin------------------------------------------------------------------------
