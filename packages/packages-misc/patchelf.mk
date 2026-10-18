#------------------------------------------------------------------------------
#
#  \brief   patchelf package recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261017> file created
#
#------------------------------------------------------------------------------


patchelf.VERSION					= 0.19.2
patchelf.SCM_TOOL              = git
patchelf.SCM_URL               = https://github.com/NixOS/patchelf.git
patchelf.SOURCE_PATH           = patchelf-mainline

$(eval $(call template,patchelf_native,host))

patchelf_native.VERSION			= $(patchelf.VERSION)
patchelf_native.SOURCE_PATH		= $(patchelf.SOURCE_PATH)

patchelf_native.CONFIGUREFLAGS 	+= --disabled-shared


patchelf.sourcebase: patchelf.scm_sourcebase
patchelf.sourcetree: patchelf.sourcebase_patched

patchelf_native.sourcetree: patchelf.sourcetree

patchelf_native.cmake_make: glibc_native.issue
patchelf_native.issue: patchelf_native.cmake
	$(done)

patchelf_native.veryclean: patchelf.veryclean


#---fin------------------------------------------------------------------------
