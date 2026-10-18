#------------------------------------------------------------------------------
#
# \brief      Builds the linux kernel
#
# \author     Maximilian Seesslen <src@seesslen.net>
#
#------------------------------------------------------------------------------


linux.VERSION							?=v7.2.10
linux.SCM_TOOL							?=git
linux.PATCH_POSTFIX					?=-7.2
linux.PROVIDER							?=mainline
linux.SOURCE_PATH						?=linux-$(linux.PROVIDER)
linux.SCM_URL							?=https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

linux.NO_CONFIGURE					?=yes
linux.MAKE_ARGS						?=ARCH=$(SIMPLE_TARGET)
linux.MAKE_TARGET						?=sunxi4.conf
linux.ENVIRONMENT						=$(cross.ENVIRONMENT) \
											ARCH_CPPFLAGS=-I$(INSTALLROOT_TARGET)$(TARGET_PREFIX)/include

linux_headers.VERSION				=$(linux.VERSION)
linux_headers.PROVIDER				=$(linux.PROVIDER)
linux_headers.SOURCE_PATH			=$(linux.SOURCE_PATH)
linux_headers.NO_CONFIGURE			= yes
linux_headers.NO_MAKE_INSTALL		= yes
linux_headers.MAKE_TARGET			= headers_install
linux_headers.ENVIRONMENT			=	$(cross.ENVIRONMENT)

linux_headers_native.VERSION				=$(linux.VERSION)
linux_headers_native.PROVIDER				=$(linux.PROVIDER)
linux_headers_native.SOURCE_PATH			=$(linux.SOURCE_PATH)
linux_headers_native.NO_CONFIGURE		= yes
linux_headers_native.NO_MAKE_INSTALL	= yes
linux_headers_native.MAKE_TARGET			= headers_install
linux_headers_native.ENVIRONMENT			=	$(cross.ENVIRONMENT)

$(eval $(call Package,linux))
$(eval $(call Package,linux_headers))

# We have no configure, we have no working build directory
# INSTALL_HDR_PATH: include is added automatically
linux_headers.MAKE_ARGS			= -C $(SOURCE_PATH)/$(linux.SOURCE_PATH) \
												ARCH=$(SIMPLE_TARGET) \
												CROSS_COMPILE=$(TARGET)- \
												INSTALL_HDR_PATH=$(INSTALLROOT_TARGET)$(TARGET_PREFIX)

linux_headers-native.VERSION				=$(linux.VERSION)
linux_headers-native.PROVIDER				=$(linux.PROVIDER)
linux_headers-native.SOURCE_PATH			=$(linux.SOURCE_PATH)
linux_headers-native.NO_CONFIGURE			= yes
linux_headers-native.NO_MAKE_INSTALL			= yes
linux_headers-native.MAKE_TARGET			= headers_install
linux_headers-native.ENVIRONMENT			=	$(host.ENVIRONMENT)
linux_headers-native.MAKE_ARGS			= -C $(SOURCE_PATH)/$(linux.SOURCE_PATH) \
						   INSTALL_HDR_PATH=$(INSTALLROOT_HOST)$(HOST_PREFIX)

linux.preconfigure: ncurses-host.issue
linux.sourcebase: linux.scm_sourcebase
linux.sourcetree: linux.scm_sourcebase_patched
DATESTR										=$(shell date +%Y%m%d_%H%M%S)
# %.linux_config.hook: toolchain.issue

%.linux_config.hook: %.sourcetree linux_headers.issue
		@mkdir -p $(BUILD_PATH)/$($*.SOURCE_PATH)
		@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); $(MAKE) ARCH=$(SIMPLE_TARGET) mrproper $(LOG_REDIRECT)
		@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); $(do_export) $(MAKE) ARCH=$(SIMPLE_TARGET) CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD_PATH)/$($*.SOURCE_PATH) $($*.KERNEL_CONFIG) $(LOG_REDIRECT)
		@cd $(BUILD_PATH)/$($*.SOURCE_PATH); sed -i -e's/.*CONFIG_RTL8192CU_SW.*/# CONFIG_RTL8192CU_SW is not set/g' .config
		$(done)

%.linux_menuconfig.hook: %.linux_config.hook ncurses-host.issue
		@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); $(do_export) $(MAKE) ARCH=$(SIMPLE_TARGET) CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD_PATH)/$($*.SOURCE_PATH) menuconfig
		@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); $(do_export) $(MAKE) ARCH=$(SIMPLE_TARGET) CROSS_COMPILE=$(CROSS_COMPILE) O=$(BUILD_PATH)/$($*.SOURCE_PATH) savedefconfig
		@cp $(BUILD_PATH)/$($*.SOURCE_PATH)/defconfig $(SOURCE_PATH)/$($*.SOURCE_PATH)/arch/arm/configs/$(linux.KERNEL_CONFIG)
		@opwd=$$PWD; cd $(SOURCE_PATH)/$($*.SOURCE_PATH); git diff --quiet arch/arm/configs/$(linux.KERNEL_CONFIG) && echo "No config change" || \
			( git add arch/arm/configs/$(linux.KERNEL_CONFIG); \
			rm -f *.patch; \
			git commit -m "updated $(linux.KERNEL_CONFIG) $(DATESTR)"; \
			num=$$(ls -A $$opwd/$($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX) | wc -l); \
			echo "NUM: $$num"; \
			git format-patch --start-number=$$num -1; \
			mkdir -p $$opwd/$($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX); \
			ls *.patch; echo %%% $$opwd/$($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX); \
			mv *.patch $$opwd/$($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX) )

### Need u-boot-tools for mkimage in order to creat uImage. Kernel build directly needs it.
%.linux_make.hook: %.linux_config.hook lzop-host.issue u-boot-tools.issue
		@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); $(MAKE) ARCH=$(SIMPLE_TARGET) mrproper $(LOG_REDIRECT)
		@cp $(BUILD_PATH)/$($*.SOURCE_PATH)/.config $(BUILD_PATH)/$($*.SOURCE_PATH)/.config_edited
		# @cd $(BUILD_PATH)/$($*.SOURCE_PATH); $(do_export) $(MAKE) ARCH=$(SIMPLE_TARGET) CROSS_COMPILE=$(CROSS_COMPILE) mrproper $(ADD_LOG_REDIRECT)
		@cd $(BUILD_PATH)/$($*.SOURCE_PATH); $(do_export) $(MAKE) ARCH=$(SIMPLE_TARGET) CROSS_COMPILE=$(CROSS_COMPILE) $(ADD_LOG_REDIRECT)
		$(call lHint,Building the dtb for $*)
		@cd $(BUILD_PATH)/$($*.SOURCE_PATH); $(do_export) $(MAKE) ARCH=$(SIMPLE_TARGET) CROSS_COMPILE=$(CROSS_COMPILE) uImage LOADADDR=${LOADADDR} $(ADD_LOG_REDIRECT)
		@cd $(BUILD_PATH)/$($*.SOURCE_PATH); mkdir -p $(SYSROOT_TARGET); PATH="$(CROSSTOOLS_BIN_PREFIX):$$PATH:$($*.PATH)" $(MAKE) INSTALL_MOD_PATH=$(SYSROOT_TARGET) ARCH=$(SIMPLE_TARGET) CROSS_COMPILE=$(CROSS_COMPILE) modules_install $(ADD_LOG_REDIRECT)
		$(done)


linux_headers.cmi_predepend: linux.sourcetree
linux_headers-native.cmi_predepend: linux.sourcetree


%.linux_uImage.hook: %.linux_make.hook
		$(call lHint,Building the dtb for $*)
		@cd $(BUILD_PATH)/$($*.SOURCE_PATH); cp arch/arm/boot/uImage ./uImage-$(TCB_TARGET_PLATFORM)
		@[ -z "$($*.DEVICETREE)" ] || (cd $(BUILD_PATH)/$($*.SOURCE_PATH); cp arch/$(SIMPLE_TARGET)/boot/dts/$($*.DEVICETREE).dtb ./dtb-$(TCB_TARGET_PLATFORM))
		@rm -f /srv/tftp/$(USER)/dtb-$(TCB_TARGET_PLATFORM)
		@rm -f /srv/tftp/$(USER)/uImage-$(TCB_TARGET_PLATFORM)
		@rm -f /srv/tftp/$(USER)/zImage-$(TCB_TARGET_PLATFORM)
		@[ -e "/srv/tftp/$(USER)" ] && ln -s $(BUILD_PATH)/$($*.SOURCE_PATH)/uImage-$(TCB_TARGET_PLATFORM) /srv/tftp/$(USER)/uImage-$(TCB_TARGET_PLATFORM) || true
		@[ -e "/srv/tftp/$(USER)" ] && ln -s $(BUILD_PATH)/$($*.SOURCE_PATH)/arch/arm/boot/zImage /srv/tftp/$(USER)/zImage-$(TCB_TARGET_PLATFORM) || true
		@[ -e "/srv/tftp/$(USER)" ] && ln -s $(BUILD_PATH)/$($*.SOURCE_PATH)/arch/arm/boot/dts/$($*.DTB_FILENAME) /srv/tftp/$(USER)/dtb-$(TCB_TARGET_PLATFORM) || true
		@mkdir -p $(SYSROOT_TARGET)/boot
		@cp $(BUILD_PATH)/$($*.SOURCE_PATH)/arch/arm/boot/zImage $(SYSROOT_TARGET)/boot/zImage-$(TCB_TARGET_PLATFORM)
		@cp $(BUILD_PATH)/$($*.SOURCE_PATH)/arch/arm/boot/dts/$($*.DTB_FILENAME) $(SYSROOT_TARGET)/boot/dtb-$(TCB_TARGET_PLATFORM)
		$(done)


#%.dtc.issue: %.linux_config.hook is not enough!
%.dtc.issue: %.linux_make.hook
		$(call lHint,DTC $*)
		@cd $(BUILD_PATH)/$($*.SOURCE_PATH)/scripts/dtc; $(MAKE) dtc $(LOG_REDIRECT)
		@cd $(BUILD_PATH)/$($*.SOURCE_PATH)/scripts/dtc; cp dtc $(SYSROOT_HOST)$(HOST_PREFIX)
		$(done)


linux.issue: linux.linux_make.hook linux.linux_uImage.hook
	$(done)


linux_headers.issue: linux_headers.cmi_make
	$(done)

linux_headers.cmi_make: rsync.issue

# before starting linux_headers-native, finish linux_headers first. Its operating on sources
linux_headers-native.cmi_make: linux_headers.cmi_make
linux_headers-native.issue: linux_headers-native.cmi_make
	$(done)
	
linux_headers-native.veryclean: linux.veryclean


#---fin------------------------------------------------------------------------
