#------------------------------------------------------------------------------
#
# \brief		revision control handling for tcbuilder
#
#				can handle/checkout git, svnm cvs and bazaar repositories.
#
# \author	Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#------------------------------------------------------------------------------


vpath		%.scm_sourcebase				$(GENERIC_DONE_PATH)
vpath		%.scm_sourcebase_patched	$(GENERIC_DONE_PATH)
vpath		%.scm_obtain					$(GENERIC_DONE_PATH)

.SUFFIXES: .scm_sourcebase .scm_obtain

scm.HOSTCHECK_FILE				= /usr/bin/git
scm.HOSTCHECK_FILE_PACKAGE		= git
GIT_SM								= "&& git submodule init && git submodule update"
hostcheck: scm.hostcheck

%.scm_obtain: %.init
	$(call lHint,scm: $($*.SCM_URL))
	@scm=$($*.SCM_TOOL); \
		case $$scm in \
			git) command="git clone $($*.SCM_URL) $($*.SOURCE_PATH) $(GIT_SM)" ;; \
			hg) command="hg clone $($*.SCM_URL) $($*.SOURCE_PATH)" ;; \
			svn) command="svn co $($*.SCM_URL) $($*.SOURCE_PATH)" ;; \
			cvs) command="cvs checkout $($*.SCM_URL) $($*.SOURCE_PATH)" ;; \
			*) $(call lsErrorExit,unknown scm type '$$scm' $*) ;; \
		esac; \
		[ -e $(DOWNLOADS_PATH)/$($*.SOURCE_PATH) ] || ( cd $(DOWNLOADS_PATH); \
		     cnt=0; received=0; \
		     while [ $$cnt -lt 3 ] && [ $$received -eq 0 ]; do \
			   cnt=$$((cnt+1));$${command} $(LOG_REDIRECT) && received=1 || sleep 2; \
		     done; \
		     [ $$received -eq 1 ] || $(call dumpAndFail,Could not configure,"$(LOG_FILE)"); \
		     )
	@[ -z "$($*.VERSION)" ] || ( \
	scm=$($*.SCM_TOOL); \
		case $$scm in \
			git) command0="git clean -d -x -f -f"; command1="git submodule init"; command2="git submodule update --recursive"; command3="git checkout -f $($*.VERSION)" ;; \
			hg) command0="echo"; command1="hg checkout $($*.VERSION)"; command2="echo"; command3="echo" ;; \
			*) $(call lsErrorExit,unknown scm type '$$scm' $*) ;; \
		esac; \
                (cd $(DOWNLOADS_PATH)/$($*.SOURCE_PATH); $${command3}; $${command0}; if [ -z "$($*.SCM_IGNORE_SUBMODULES)" ]; then \
			$${command1} ; \
			$${command2}  ; \
                        else echo "Ignoring submodules"; fi ) $(ADD_LOG_REDIRECT) \
	)
	$(silentGenericDone)


%.scm_sourcebase_patched: %.scm_sourcebase
	$(call lHint,Patching SCM Sourcetree)
	@[ -e "$(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.patched" ] || \
		for patchfile in $(sort $(wildcard $($*.MAKE_PATH)/$($*.SOURCE_PATH)$($*.PATCH_POSTFIX)/*.patch)); do \
				$(call lsHint,Apply patch file $$(basename $$patchfile)); \
				cd $(SOURCE_PATH)/$($*.SOURCE_PATH); git am $(PWD)/$${patchfile} $(ADD_LOG_REDIRECT); \
		done
	@#$(LOG_REDIRECT)
	@touch $(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.patched
	$(silentGenericDone)


%.scm_sourcebase: %.scm_obtain
	$(call lHint,Coping scm directory: $($*.SOURCE_PATH))
	@[ -e "$(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.archive" ] || \
	    ( rm -rf "$(SOURCE_PATH)/$($*.SOURCE_PATH)"; cp -r $(DOWNLOADS_PATH)/$($*.SOURCE_PATH) $(SOURCE_PATH) )
	$(silentGenericDone)


#---fin------------------------------------------------------------------------
