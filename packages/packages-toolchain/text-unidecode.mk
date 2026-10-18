#------------------------------------------------------------------------------
#
#  \brief   Text-Unidecode recipe for tcbuilder
#
#           Newlib-nano wants it
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


text-unidecode.VERSION         =1.30
text-unidecode.ARCHIVE_FILE    =Text-Unidecode-$(text-unidecode.VERSION).tar.gz
text-unidecode.ARCHIVE_URL     =https://cpan.metacpan.org/authors/id/S/SB/SBURKE/$(text-unidecode.ARCHIVE_FILE)
text-unidecode.SOURCE_PATH     =Text-Unidecode-$(text-unidecode.VERSION)

$(eval $(call Package,text-unidecode))

text-unidecode.CONFIGUREFLAGS      = $(host.CONFIGUREFLAGS)
text-unidecode.ENVIRONMENT         = $(host.ENVIRONMENT)

text-unidecode.sourcebase: text-unidecode.archive_sourcebase
text-unidecode.sourcetree: text-unidecode.sourcebase_patched
text-unidecode.install: text-unidecode.text-unidecode_install.hook

%.text-unidecode_install.hook: %.sourcetree
	@rm -rf $(BUILD_PATH)/$*-$($*.VERSION)
	@cp -R $(SOURCE_PATH)/$($*.SOURCE_PATH) $(BUILD_PATH)/$*-$($*.VERSION)
	@cd $(BUILD_PATH)/$*-$($*.VERSION); \
		$(do_export) perl Makefile.PL PREFIX=/usr $(LOG_REDIRECT); \
		$(do_export) $(MAKE) PREFIX=/usr $(LOG_REDIRECT);
	@cd $(BUILD_PATH)/$*-$($*.VERSION); \
		$(do_export) $(MAKE) install PREFIX=/usr DESTDIR=$(INSTALLROOT_HOST) $(LOG_REDIRECT)
	@#perl Makefile.PL DESTDIR=$PWD/install PREFIX=/foooo
	$(done)

text-unidecode.issue: text-unidecode.skeleton
	$(done)


#---fin------------------------------------------------------------------------
