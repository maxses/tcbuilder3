#------------------------------------------------------------------------------
#
# \brief    "done"-file handling for tcbuilder
#
#           done-files are created whe an make-target/issue was finished. They
#           represent the target of an make rule since most rules dont "produce"
#           a single object file.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


#-----------------------------------------------
#
# Cleaning rules can be applied global for all packages or for each package.
# e.g. "<package>.clean" vs. "clean".
#
# rebuild:      only "done"-entries and logs are removed
# clean:        all "done"-entries, logs and the build directory are cleaned
#               This is quite enough for a package.
# verylean:     Also removes the sorcetree.
#               If used global the rootfs also gets deleted
# absoluteclean:The Archive(s) get removed. You usually don't want to do that.
#               If used global the complete workplace directory is cleaned.
#
#-----------------------------------------------


vpath		%.done			$(DONE_PATH) $(GENERIC_DONE_PATH)

define writeDone
		@opath="$1"; if [ -z "$$opath" ]; then opath="$(DONE_PATH)"; fi; echo done >> "$$opath/$@";
endef

define writeCustomDone
		@echo done >> "$(DONE_PATH)/$1";
endef

### As long as the generic depencie graph does not work (probably will never
### work) we must not use "$(GENERIC_DONE_PATH)". Every time a configuration
### touches the generic done files it destroys the complete done-status of
### other configurations.
define writeGenericDone
		@opath="$1"; if [ -z "$$opath" ]; then opath="$(GENERIC_DONE_PATH)"; fi;\
		mkdir -p "$$(dirname $$opath/$@)"; echo done >> "$$opath/$@";
endef

define done
   $(call writeDone,$1)
   $(call lHint,Done)
endef

define genericDone
   $(call writeGenericDone,$1)
   $(call lHint,Done)
endef

define silentDone
   $(call writeDone,$1)
endef

define silentGenericDone
   $(call writeGenericDone,$1)
endef


.PHONY: rebuild clean veryclean absoluteclean


rebuild:
	@rm -f $(LOG_PATH)/*
	@rm -f $(DONE_PATH)/*

%.rebuild:
	@rm -f $(LOG_PATH)/$*.*
	@rm -rf $(DONE_PATH)/$*.*

clean: rebuild
	@rm -Rf $(BUILD_PATH)/*


%.clean: %.rebuild
	@rm -Rf $(BUILD_PATH)/$*-$($*.VERSION)


veryclean: clean
	@rm -Rf $(ROOTFS_PATH)/*
	@rm -Rf $(SOURCE_PATH)/*


%.veryclean: %.clean
	@[ -z "$($*.SOURCE_PATH)" ] || rm -Rf $(SOURCE_PATH)/$($*.SOURCE_PATH)
	@rm -rf $(GENERIC_DONE_PATH)/$*.*


absoluteclean:
	@rm -Rf $(WORKPLACE)/*


%.absoluteclean: %.clean
	@rm -Rf $(DOWNLOADS_PATH)/$*-$($*.VERSION)


#---fin------------------------------------------------------------------------
