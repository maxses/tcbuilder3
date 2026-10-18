#------------------------------------------------------------------------------
#
#  \brief   Install the relocate script
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20230609> file created
#
#------------------------------------------------------------------------------


MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

relocate.issue: patchelf_native.issue
	@mkdir -p $(SYSROOT_HOST)
	@cp $(MAKEFILE_DIR)/files/relocate.sh $(SYSROOT_HOST)
	$(done)


#---fin------------------------------------------------------------------------
