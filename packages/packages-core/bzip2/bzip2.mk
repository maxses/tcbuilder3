#------------------------------------------------------------------------------
#
#  \brief   bzip2 recipe for tcbuilder
#
#           URL: https://sourceware.org/pub/bzip2
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


bzip2.VERSION						= 1.0.8
bzip2.ARCHIVE_FILE				= bzip2-$(bzip2.VERSION).tar.gz
bzip2.ARCHIVE_URL					= https://sourceware.org/pub/bzip2/$(bzip2.ARCHIVE_FILE)
bzip2.ENTRY_PATH					= bzip2-$(bzip2.VERSION)
bzip2.SOURCE_PATH					= bzip2-$(bzip2.VERSION)
bzip2.PKG_CONFIG_LIBNAME		= bz2
#bzip2.CONFIGUREFLAGS			= \
#										$(target.CONFIGUREFLAGS) \
#										--prefix=$(TARGET_NONUSR_PREFIX)
bzip2.ENVIRONMENT					= $(target.ENVIRONMENT)
bzip2-host.SOURCE_PATH			= $(bzip2.SOURCE_PATH)

$(eval $(call Package,bzip2))
$(eval $(call template,bzip2-host,host))

#bzip2-host.ENVIRONMENT				+= \
#					PKG_CONFIG_SYSROOT_DIR=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) \
#					PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH)
bzip2-host.PKG_CONFIG_LIBNAME		= bzip2

bzip2-host.ENVIRONMENT				+= \
										PREFIX=$(HOST_USR_PREFIX) \
										SYSROOT=$(SYSROOT_HOST) \

### need % method to get $(do_export) work
bzip2.sourcebase: bzip2.archive_sourcebase

# bzip2.sourcetree: bzip2.sourcetree_in_build

bzip2-host.sourcetree: bzip2.sourcetree

%.bzip2.custom_build: %.sourcetree
	$(call lHint,copy bzip2 sources)
	@rm -rf $(BUILD_PATH)/$*-$($*.VERSION); \
		cp -R $(SOURCE_PATH)/$($*.SOURCE_PATH) $(BUILD_PATH)/$*-$($*.VERSION)
	$(call lHint,Building bzip2 distclean)
	@#sed -i \
	#	 -e "s|^CC=.*|CC=$(CC_FOR_TARGET)|g" \
	#	 -e "s|^AR=.*|AR=$(AR_FOR_TARGET)|g" \
	#	 -e "s|^RANLIB=.*|RANLIB=$(RANLIB_FOR_TARGET)|g" \
	#	 -e "s|^PREFIX=.*|PREFIX=$(SYSROOT_TARGET)/$(TARGET_NONUSR_PREFIX)|g" \
	#	 $(BUILD_PATH)/$*-$($*.VERSION)/Makefile
	@#sed -i -e "s|^CC=.*|CC=$(CC_FOR_TARGET)|g" \
	#	 $(BUILD_PATH)/$*-$($*.VERSION)/Makefile-libbz2_so
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) distclean $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make_distclean.log
	$(call lHint,Building bzip2 Makefile-libbz2_so)
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) -f Makefile-libbz2_so $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make_libbz2.log
	$(call lHint,Building bzip2 clean)
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) clean $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make_clean.log
	$(call lHint,Building bzip2 make)
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) libbz2.a bzip2 bzip2recover $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make.log
	$(silentDone)


%.bzip2.custom_install: %.bzip2.custom_build
	$(call lHint,Building bzip2 install)
	@cd $(BUILD_PATH)/$*-$($*.VERSION); $(do_export) $(MAKE) install \
				PREFIX=$${SYSROOT}/usr $(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_make_install.log
	@$(do_export) cp -a $(BUILD_PATH)/$*-$($*.VERSION)/lib*.so.* $${SYSROOT}$${PREFIX}/lib
	@$(do_export) rm -f $${SYSROOT}$${PREFIX}/lib/libbz2.so
	@$(do_export) ln -s libbz2.so.1.0 $${SYSROOT}$${PREFIX}/lib/libbz2.so
	$(silentDone)


bzip2.issue: bzip2.bzip2.custom_install bzip2.pkg-config_file
	$(done)

bzip2-host.issue: bzip2-host.bzip2.custom_install bzip2-host.pkg-config_file
	$(done)

bzip2-host.veryclean: bzip2.veryclean

#bzip2-host.issue: bzip2-host.cmi
#	$(done)


#---fin------------------------------------------------------------------------
