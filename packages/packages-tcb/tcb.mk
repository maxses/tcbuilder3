#------------------------------------------------------------------------------
#
#  \brief   Some pseudo make targets for tcbuilder
#
#           e.g. target for toolchain
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


tcb.issue: gcc.issue hello_world.issue libc.issue gdb.issue mkspecs.issue cmake_scripts.issue pkg-config.issue readme.issue
	$(done)


toolchain.issue: gcc.issue hello_world.issue libc.issue gdb.issue mkspecs.issue cmake_scripts.issue ccache.issue pkg-config.issue relocate.issue
	@echo "### Hint:  To install the toolchain as a link to the build directories run:"
	@echo "###        sudo ln -s $(ROOTFS_PATH)$(OPT_PATH)$(PREFIX) /opt/tcb-$(TCB_TARGET_PLATFORM)"
	$(done)

os_base.issue:	linux.issue u-boot.issue busybox.issue
	@echo -n
	$(done)

symlink.issue: toolchain.issue
	@rm -f "/opt/tcb-$(TCB_TARGET_PLATFORM)" || true
	@ln -s "$(ROOTFS_PATH)$(OPT_PATH)" "/opt/tcb-$(TCB_TARGET_PLATFORM)" || echo "Could not make symlink. Ignoring."
	$(done)


toolchain: toolchain.issue
	$(done)


#---fin------------------------------------------------------------------------
