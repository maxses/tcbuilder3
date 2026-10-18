#------------------------------------------------------------------------------
#
# \brief		Creates release archive of toolchain and target rootfs of tcbuilder
#
# \author	Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


vpath		%.archive_obtain		$(DONE_PATH) $(GENERIC_DONE_PATH)
vpath		%.archive_sourcebase		$(DONE_PATH) $(GENERIC_DONE_PATH)


.PHONY: release.issue


DATECODE	=   $(shell date "+%Y%m%d")
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

%.release.issue: $(TCB_TARGET_PLATFORM).issue meta.issue readme.issue
	$(call lHint,Creating release archive)
	@cd $(ROOTFS_PATH)/$(OPT_PATH); cd ..; \
	PBZIP2="$$(which pbzip2|true)"; if [ -e "$$PBZIP2" ]; then \
		tar -c --use-compress-program=pbzip2 -f $(WORKPLACE)/tcbuilder3-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)-$(RELEASE)-$(DATECODE).tbz .; \
	else \
		tar -cjf $(WORKPLACE)/tcbuilder3-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)-$(RELEASE)-$(DATECODE).tbz .; \
	fi
	$(done)


%.release_downloads.issue: $(TCB_TARGET_PLATFORM).issue meta.issue
	$(call lHint,Creating release downloads archive)
	@cd $(DOWNLOADS_PATH); cd ..; \
	PBZIP2="$$(which pbzip2 || echo -n)"; if [ -e "$$PBZIP2" ]; then \
		tar -c --use-compress-program=pbzip2 -f $(WORKPLACE)/tcbuilder3_downloads-$(RELEASE)-$(DATECODE).tbz $$(basename "$(DOWNLOADS_PATH)"); \
	else \
		tar -cjf $(WORKPLACE)/tcbuilder3_downloads-$(RELEASE)-$(DATECODE).tbz $$(basename "$(DOWNLOADS_PATH)"); \
	fi
	$(done)


%.install_release.issue:
	$(call lHint,Install release archive)
	@mkdir -p $(ROOTFS_PATH)/$(OPT_PATH)
	@cd $(ROOTFS_PATH)/$(OPT_PATH); cd ..;tar -xjf $(WORKPLACE)/tcbuilder3-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)-$(RELEASE)-$(INSTALL_DATECODE).tbz .
	@cd $(ROOTFS_PATH)/$(OPT_PATH); cd ..;cp $(README) $(WORKPLACE)/tcbuilder3-$(TCB_TARGET_PLATFORM)-$(LOCAL_TUNE)-$(RELEASE)-$(INSTALL_DATECODE).html .
	$(done)


release.issue: release.release.issue
	$(done)


release_downloads.issue: release_downloads.release_downloads.issue
	$(done)


install_release.issue: install_release.install_release.issue
	$(done)


#---fin------------------------------------------------------------------------
