#------------------------------------------------------------------------------
#
#  \brief   Readme recipe for tcbuilder
#
#           Just creates the readme html file for the archive/release
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


README							=$(ROOTFS_PATH)$(OPT_PATH)/../readme-tcb-$(RELEASE)$(TCB_TAG).html
SELF_DIR							:= "$(PWD)/$(dir $(lastword $(MAKEFILE_LIST)))"

readme.ENVIRONMENT				= $(host.ENVIRONMENT) \
			PYTHONPATH=$(SYSROOT_HOST)$(HOST_PREFIX)/lib/python$(python.MAJOR_VERSION)/site-packages


readme.issue: python3-asciidoc-host.issue
	@export $(readme.ENVIRONMENT); asciidoc -o $(README) \
		$(SELF_DIR)files/tcbuilder_usage.txt
	$(done)


#---fin------------------------------------------------------------------------
