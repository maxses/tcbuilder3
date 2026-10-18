#------------------------------------------------------------------------------
#
# \brief		handles patching of sourcetrees in tcbuilder
#
#				automaatically applies patches to sourcetrees.
#
# \author	Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


#------Pathes-----------------------------------

vpath		%.sourcebase_patched    	$(GENERIC_DONE_PATH)


#------Targets----------------------------------

path := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
cwd  := $(shell pwd)

# || $(call lsWarn,Patch was not applicable)
### Can not show basename of patchfile at the moment for some reason.
%.sourcebase_patched: %.sourcebase
	$(call lHint,Patching Sourcetree)
	$(call lHint,   $($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX))
	@#echo Apply patches from $($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX)$
	@[ -e "$(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.patched" ] || \
		for patchfile in $(sort $(wildcard $($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX)/*.patch)); do \
				$(call lsHint,Apply patch file $$(basename $$patchfile)); \
				patch -d $(SOURCE_PATH)/$($*.SOURCE_PATH) --forward -p1 < $${patchfile} $(ADD_LOG_REDIRECT); \
		done
	@#$(LOG_REDIRECT)
	@touch $(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.patched
	$(silentGenericDone)


#------Rules------------------------------------

%.sourcetree: %.sourcebase_patched


#---fin------------------------------------------------------------------------
