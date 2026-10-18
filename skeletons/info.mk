#------------------------------------------------------------------------------
#
# \brief    Some information handling for tcbuilder
#
#           Just print some info.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


vpath		%.pkginfo		$(DONE_PATH) $(GENERIC_DONE_PATH)

.PHONY: info
info:
	@echo "TCB_TARGET_PLATFORM:$(TCB_TARGET_PLATFORM)"
	@echo "Linux Url:          $(linux.SCM_URL)"
	@echo "Compile-Threads:    $(THREADS)"
	@echo "MAKEFLAGS:          $(MAKEFLAGS)"
	@echo "MAKE:               $(MAKE)"
	@echo "TARGET:             $(TARGET)"
	@echo "TARGET_PREFIX:      $(TARGET_PREFIX)"
	@echo "PREFIX:             $(PREFIX)"
	@echo "HOST_PREFIX:        $(HOST_PREFIX)"
	@echo "LIBC:               $(LIBC)"
	@echo "Tune:               $(LOCAL_TUNE)"
	@echo "DONE_PATH:          $(DONE_PATH)"
	@echo "BUILD_ARCHFLAGS:    $(BUILD_ARCHFLAGS)"
	@echo "TARGET_ARCHFLAGS:   $(TARGET_ARCHFLAGS)"
	@echo "LDFLAGS_FOR_TARGET: $(LDFLAGS_FOR_TARGET)"
	@echo "PATH:               $(PATH)"
	@echo "ROOTFS_PATH         $(ROOTFS_PATH)"
	@echo "x-PATH:             $(ROOTFS_PATH)$(PREFIX)/bin"
	@echo "SYSROOT_HOST:       $(SYSROOT_HOST)"
	@echo "SYSROOT_TARGET:     $(SYSROOT_TARGET)"
	@echo "INSTALLROOT_HOST:   $(INSTALLROOT_HOST)"
	@echo "INSTALLROOT_TARGET: $(INSTALLROOT_TARGET)"
	@echo "GIT_SHA:            $(shell git rev-parse HEAD)"
	@echo "LOCAL_OPTIMIZATION: $(LOCAL_OPTIMIZATION)"

info_script:
	@echo "TCB_TARGET_PLATFORM=$(TCB_TARGET_PLATFORM)" > $(INFO_SCRIPT)
	@echo "TARGET=$(TARGET)" >> $(INFO_SCRIPT)
	@echo "TARGET_PREFIX=$(TARGET_PREFIX)" >> $(INFO_SCRIPT)
	@echo "HOST_PREFIX=$(HOST_PREFIX)" >> $(INFO_SCRIPT)
	@echo "ROOTFS_PATH=$(ROOTFS_PATH)" >> $(INFO_SCRIPT)
	@echo "SYSROOT_TARGET=$(SYSROOT_TARGET)" >> $(INFO_SCRIPT)
	@echo "SYSROOT_HOST=$(SYSROOT_HOST)" >> $(INFO_SCRIPT)
	@echo "INSTALLROOT_TARGET=$(INSTALLROOT_TARGET)" >> $(INFO_SCRIPT)
	@echo "INSTALLROOT_HOST=$(INSTALLROOT_HOST)" >> $(INFO_SCRIPT)
	@echo "CROSS_COMPILE=$(CROSS_COMPILE)" >> $(INFO_SCRIPT)
	@echo "CROSSTOOLS_BIN_PREFIX=$(CROSSTOOLS_BIN_PREFIX)" >> $(INFO_SCRIPT)
	@echo "MULTILIB_LIST=$(MULTILIB_LIST)" >> $(INFO_SCRIPT)
	@echo "NO_SYSCALLS=$(NO_SYSCALLS)" >> $(INFO_SCRIPT)


.PHONY: %.info
%.info:
	@echo "ENVIRONMENT:   $($*.ENVIRONMENT)"
	$(do_export) bash

PKGINFO_PATH                        =$(INSTALLROOT_HOST)$(HOST_PREFIX)/share/tcbuilder3/pkginfo

%.pkginfo:
	@mkdir -p $(PKGINFO_PATH)
	@echo "Package: $*" >> $(PKGINFO_PATH)/$*.txt
	@echo "Version: $($*.VERSION)" >> $(PKGINFO_PATH)/$*.txt
	@echo "" >> $(PKGINFO_PATH)/$*.txt
	@echo "Configure arguments:" >> $(PKGINFO_PATH)/$*.txt
	@echo "$($*.CONFIGUREFLAGS) $(CONFIGUREFLAGS)" >> $(PKGINFO_PATH)/$*.txt
	@echo "" >> $(PKGINFO_PATH)/$*.txt
	@echo "CMake Args" >> $(PKGINFO_PATH)/$*.txt
	@echo "$($*.CMAKE_ARGS)" >> $(PKGINFO_PATH)/$*.txt
	@echo "" >> $(PKGINFO_PATH)/$*.txt
	@$(do_export)  declare -x >> $(PKGINFO_PATH)/$*.txt
	@echo "" >> $(PKGINFO_PATH)/$*.txt
	@echo "#--fin.---------" >> $(PKGINFO_PATH)/$*.txt
	@$(silentDone)


.PHONY: subinfo
subinfo:
	@echo
	@echo
	@echo "---------------"
	$(MAKE) info $(MAKEARGS)
	@echo "---------------"
	$(do_export) $(MAKE) $(SUB_MAKEFLAGS) $($*.MAKE_TARGET) $($*.MAKE_ARGS) info
	$(do_export) bash
	@echo "---------------"
	make info $(MAKEARGS)


#---fin------------------------------------------------------------------------
