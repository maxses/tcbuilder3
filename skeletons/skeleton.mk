#------------------------------------------------------------------------------
#
# \brief		defines basic depency skeleton of an issue in tcbuilder3
#
#				See skeleton documentation for further information.
#
# \author	Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


vpath		setup_generic       $(GENERIC_DONE_PATH)
vpath		precondition        $(GENERIC_DONE_PATH)
vpath		%.precondition      $(GENERIC_DONE_PATH)
vpath		%.init              $(GENERIC_DONE_PATH)
vpath		%.obtain            $(GENERIC_DONE_PATH)
vpath		%.sourcebase        $(GENERIC_DONE_PATH)
vpath		%.sourcetree        $(GENERIC_DONE_PATH)
vpath		%.precheck          $(GENERIC_DONE_PATH)
vpath		%.version_checkpoint $(GENERIC_DONE_PATH)
vpath		%.version_checkpoint_source $(GENERIC_DONE_PATH)
vpath		%.package_start     $(GENERIC_DONE_PATH)
vpath		%.issue             $(GENERIC_DONE_PATH)
vpath		%.issue             $(DONE_PATH)

vpath		setup_build         $(DONE_PATH)
vpath		%.version_checkpoint_build		$(DONE_PATH)
vpath		%.preconfigure      $(DONE_PATH)
vpath		%.prebuild          $(DONE_PATH)
vpath		%.configure         $(DONE_PATH)
vpath		%.build             $(DONE_PATH)
vpath		%.install           $(DONE_PATH)
vpath		%.postcheck         $(DONE_PATH)
vpath		%.package           $(DONE_PATH)
vpath		%.issue             $(DONE_PATH)
vpath		%.check             $(DONE_PATH)
vpath		%.target            $(DONE_PATH)
vpath		%.skeleton          $(DONE_PATH)
vpath		%.hook              $(DONE_PATH)
vpath		%.hook              $(GENERIC_DONE_PATH)

# User targets
vpath		%.build             $(DONE_PATH)
vpath		%.config            $(DONE_PATH)
vpath		%.make              $(DONE_PATH)
vpath		%.predepend         $(DONE_PATH)


#--- Avoid until we find the neccessarity
# vpath		%.custom_predepend  $(DONE_PATH)
# vpath		%.custom_config     $(DONE_PATH)
# vpath		%.custom_configure  $(DONE_PATH)
# vpath		%.custom_make       $(DONE_PATH)

setup_generic:
	$(DBG_PRINT)
	@mkdir -p $(GENERIC_LOG_PATH)
	@mkdir -p $(DOWNLOADS_PATH)
	@mkdir -p $(SOURCE_PATH)
	@mkdir -p $(GENERIC_DONE_PATH)
	$(silentGenericDone)

setup_build:
	$(DBG_PRINT)
	@mkdir -p $(LOG_PATH)
	@mkdir -p $(BUILD_PATH)
	@mkdir -p $(ROOTFS_PATH)
	@mkdir -p $(DONE_PATH)
	@mkdir -p $(SYSROOT_HOST)$(HOST_PREFIX)/bin
	@mkdir -p $(SYSROOT_TARGET)$(TARGET_PREFIX)/bin
	@mkdir -p $(SYSROOT_HOST)$(HOST_NONUSR_PREFIX)/bin
	@mkdir -p $(SYSROOT_TARGET)$(TARGET_NONUSR_PREFIX)/bin
	@mkdir -p $(SYSROOT_HOST)$(HOST_PREFIX)/lib
	@mkdir -p $(SYSROOT_TARGET)$(TARGET_PREFIX)/lib
	@mkdir -p $(SYSROOT_HOST)$(HOST_NONUSR_PREFIX)/lib
	@mkdir -p $(SYSROOT_TARGET)$(TARGET_NONUSR_PREFIX)/lib
	$(silentDone)

precondition: setup_generic
	$(DBG_PRINT)
	$(silentGenericDone)

%.version_checkpoint_source: precondition
	$(DBG_PRINT)
	$(silentGenericDone)

%.version_checkpoint_build: setup_build
	$(DBG_PRINT)
	@# remove all other version checkpoints; all other would be needed to rebuild
	@# Tags can contain slashes '/'
	@a="$*"; mkdir -p $(DONE_PATH)/$$(dirname $$a); \
			rm -rf $(DONE_PATH)/$${a%%.*}.*.version_checkpoint_build
	$(silentDone)

%.init: precondition
	$(DBG_PRINT)
	$(silentGenericDone)

%.obtain: %.init
	$(DBG_PRINT)
	$(silentGenericDone)

%.sourcebase: %.obtain
	$(DBG_PRINT)
	$(silentGenericDone)

%.sourcetree: %.sourcebase
	$(DBG_PRINT)
	$(silentGenericDone)

%.precheck: %.sourcetree
	$(silentGenericDone)

%.preconfigure: %.precheck setup_build
	$(silentDone)

%.prebuild: %.configure
	$(silentDone)

%.configure: %.preconfigure
	$(silentDone)

%.build: %.prebuild
	$(silentDone)

%.install: %.build
	$(silentDone)

%.postcheck: %.install
	$(silentDone)

%.skeleton: %.postcheck
	$(silentDone)

# %.issue: %.postcheck

## %.issue: %.postcheck
##	$(silentDone)

# %.package: %.issue
# $(silentDone)

#define __PACKAGE
#
#$(1).init:		$($(1).VERSION).version_checkpoint
#$(1).package_start: precondition
#	echo "Package start; DP: $(GENERIC_DONE_PATH)
#	@echo done >> "$(GENERIC_DONE_PATH)/$@"
#
#endef


#binutils.init:		$(binutils.VERSION).version_checkpoint
#binutils.package_start: precondition
#	echo "Package start; DP: $(GENERIC_DONE_PATH)
#	mkdir -p $(GENERIC_DONE_PATH)
#	@echo done >> "$(GENERIC_DONE_PATH)/$@"


#---fin------------------------------------------------------------------------
