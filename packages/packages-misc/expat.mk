#------------------------------------------------------------------------------
#
#  \brief   Libexpat recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


expat.VERSION							=	R_2_9_0
expat.SCM_TOOL							=	git
expat.SCM_URL							=	https://github.com/libexpat/libexpat.git
expat.SOURCE_PATH					   = expat-mainline
expat.SUBDIR							=	expat

# Target version not needed at the moment.

host_expat.SUBDIR						=	expat
host_expat.CMAKE_ARGS				= $(host.CMAKE_ARGS)
host_expat.VERSION					= $(expat.VERSION)
host_expat.SOURCE_PATH				= $(expat.SOURCE_PATH)

expat.ENVIRONMENT                =	$(target.ENVIRONMENT)

PACKAGES                      += expat host_expat


$(eval $(call template,host_expat,host))

expat.sourcebase: expat.scm_sourcebase

host_expat.sourcetree: expat.sourcetree

expat.issue: expat.cmake
	$(done)

host_expat.issue: host_expat.cmake
	$(done)


#---fin------------------------------------------------------------------------
