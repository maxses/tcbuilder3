#------------------------------------------------------------------------------
#
#  \brief   Core Makefile for tcbuilder3
#
#           This Makefile is the start.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     20150901 File created
#
#------------------------------------------------------------------------------


-include $(HOME)/.tcbuilder3.mk
-include tcbuilder3.mk

SHELL                           = /bin/bash -e -u

vpath %.mk tools targets

.DEFAULT_:
	$(call lError,Dont know how to create $@)
	$(call lError,Input Files: $% $< $? $^ $+ $| $* fin)
	@exit 22

# %::


### Caution: "generic" does not work. Just use empty string "" if you want to
### produce generic code.
ifdef LOCAL_OPTIMIZATION
$(warn asdasdasd)
BUILD_ARCHFLAGS            +=-march=$(LOCAL_OPTIMIZATION)
HOST_ARCHFLAGS             +=-march=$(LOCAL_OPTIMIZATION)
endif


### Platforms
ifndef TCB_TARGET_PLATFORM
   # Thats ok if you just want to run "clean", "rebuild" etc
   $(error "Platform was not set. I need a platform to set pathes. (try TCB_TARGET_PLATFORM=local)")
else
   include platforms/$(TCB_TARGET_PLATFORM).mk
endif


### Scripts
include $(shell ls skeletons/*.mk)


define Package
# $(1).MAKE_PATH:=$(CURDIR)
$(1).MAKE_PATH:=$(dir $(lastword $(MAKEFILE_LIST)))
PACKAGES += $(1)
endef


### Packages

include $(shell ls packages/*/*/*.mk)
include $(shell ls packages/*/*.mk)
# include $(shell ls doc/*.mk)

$(info ### Target: $(MAKECMDGOALS))
$(info ### Packages: $(PACKAGES))

$(info ### Libc: $(LIBC_PROVIDER))
ifeq ($(DEVELOP_MODE),)
$(info ### Develop Mode: No)
else
$(info ### Develop Mode: Yes)
endif

ifeq ("$(LIBC_PROVIDER)", "")
   $(error No libc provider was specified. If you really dont want a libc on your platform choose a dummy target.)
endif

### lHint does not work very well; The make target is not printed and so the
### output is more confusing then helping.
### Use lfHint instead.
###
### %:package_start is not used any more. Too much problems when you did not
### add your target to PACKAGE
define PACKAGE_template =
 $(1).package_start:  precondition
	@echo done >> "$(GENERIC_DONE_PATH)/$$@"
	echo "Precondition"

 $(1).init:      $(subst /,-,$1.$($(1).VERSION).version_checkpoint_source)
 $(1).prebuild:  $(subst /,-,$1.$($(1).VERSION).version_checkpoint_build)
 ALL_OBJS   += $$($(1)_OBJS)
endef

$(foreach package,$(PACKAGES),$(eval $(call PACKAGE_template,$(package))))

obtainall: $(patsubst %,%.sourcebase,$(PACKAGES))
	@for package in $(PACKAGES); do $(call lsHint,Source received for: $$package); done


### Architecture

.PHONY: all

all: tcb.issue
	$(call lHint,"-")
	$(call lHint,"done")
	@


#---fin------------------------------------------------------------------------
