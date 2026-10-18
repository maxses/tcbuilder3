#------------------------------------------------------------------------------
#
# \brief    handles archives in tcbuilder3
#
#           Receives archive files from www and extract them.
#
# \author   Maximilian Seesslen <src@seesslen.net>
# \date     <20130403> file created
#
#-----------------------------|---------------------------------------------V1-


vpath %.archive_obtain			$(GENERIC_DONE_PATH)
vpath %.archive_sourcebase		$(GENERIC_DONE_PATH)
vpath %.installer_sourcebase	$(GENERIC_DONE_PATH)

# -t: retries, -T: timeout for connect, read etc., 10s actual to low
# -t5: broke on clean checkout with tcbuilder3
WGETFLAGS	=-t30 -T20

%.archive_obtain: %.init
	$(call lHint,receiving archive: $($*.ARCHIVE_FILE))
	@mkdir -p $(DOWNLOADS_PATH)
	@if [ ! -e $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE).done ]; then \
		rm -f $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE); \
		cnt=0; received=0; \
		while [ $$cnt -lt 3 ] && [ $$received -eq 0 ]; do \
		cnt=$$((cnt+1));wget $(WGETFLAGS) "$($*.ARCHIVE_URL)" -O $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE) -o $(LOG_PATH)/$*-wget.log && received=1 || sleep 1; \
		done; \
		[ $$received -eq 1 ] || rm -f $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE); \
	fi
	@[ -e "$(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE)" ] || $(call lsHint,Could not receive file)
	@[ -e "$(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE)" ] || $(call lsErrorExit,file $($*.ARCHIVE_URL))
	@touch $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE).done
	$(genericDone)


%.archive_sourcebase: %.archive_obtain
	$(call lHint,extracting archive: $($*.ARCHIVE_FILE))
	@ [ ! -z "$($*.SOURCE_PATH)" ] || $(call lsErrorExit,SOURCE_PATH not set for recipe)
	@[ -e "$(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.archive" ] || \
	( rm -rf "$(SOURCE_PATH)/$($*.SOURCE_PATH)"; \
		suffix=$(suffix $($*.ARCHIVE_FILE)); \
		if [ "$$suffix" = ".zip" ]; then unzip -o $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE) -d $(SOURCE_PATH) \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_unzip.log; else \
			case $$suffix in \
				.bz2) par="j" ;; \
				.gz) par="z" ;; \
				.xz) par="J" ;; \
				.tgz) par="z" ;; \
				*) $(call lsErrorExit,unknown archive type $$suffix) ;; \
			esac; \
			[ -e $(SOURCE_PATH)/$($*.SOURCE_PATH) ] || tar -x$${par}f $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE) -C $(SOURCE_PATH); \
		fi \
	)
	@touch $(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.archive
	$(genericDone)


%.installer_sourcebase: %.archive_obtain
	$(call lHint,extracting archive: $($*.ARCHIVE_FILE))
	@ [ ! -z "$($*.SOURCE_PATH)" ] || $(call lsErrorExit,SOURCE_PATH not set for recipe)
	@[ -e "$(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.installer" ] || \
	( rm -rf "$(SOURCE_PATH)/$($*.SOURCE_PATH)"; \
		suffix=$(suffix $($*.ARCHIVE_FILE)); \
		cd $(SOURCE_PATH); \
		[ -e $($*.SOURCE_PATH) ] || sh $(DOWNLOADS_PATH)/$($*.ARCHIVE_FILE) $($*.INSTALLER_ARGS) \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_installer.log \
	)
	@touch $(SOURCE_PATH)/$($*.SOURCE_PATH)/tcbuilder3.installer
	$(genericDone)


#---fin------------------------------------------------------------------------
