#------------------------------------------------------------------------------
#
#  \brief   Asciidoc recipe for tcbuilder
#
#           The readme target wants it
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


asciidoc.VERSION         =10.2.1
asciidoc.ARCHIVE_FILE    =asciidoc-$(asciidoc.VERSION).tar.gz
asciidoc.ARCHIVE_URL     =https://github.com/asciidoc-py/asciidoc-py/releases/download/$(asciidoc.VERSION)/$(asciidoc.ARCHIVE_FILE)
asciidoc.SOURCE_PATH     =asciidoc-$(asciidoc.VERSION)

python3-asciidoc-host.ENVIRONMENT         = $(host.ENVIRONMENT) \
						PYTHONPATH=$(SYSROOT_HOST)$(HOST_PREFIX)/lib/python$(python.MAJOR_VERSION)/site-packages


asciidoc.sourcebase: asciidoc.archive_sourcebase

python3-asciidoc-host.python_custombuild.hook: python3-setuptools-host.issue
python3-asciidoc-host.python_custombuild.hook: python3-pip-host.issue
python3-asciidoc-host.veryclean: asciidoc.veryclean


# $(eval $(call pythonPackage,asciidoc,2))
# $(eval $(call pythonPackageHost,asciidoc,2))
# $(eval $(call pythonPackageHost,asciidoc,3))


%.python3-asciidoc-host.issue: python3-pip-host.sourcebase python3-setuptools-host.issue python3-host.issue asciidoc.sourcetree
	$(call lHint,Building $*)
	$(call lHint,$(SOURCE_PATH)/$($*.SOURCE_PATH))
	$(call lHint,$(python3-host.PYTHONBIN))
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
		$(do_export) LANG="" export \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_export.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
		$(do_export) \
		$(python3-host.PYTHONBIN) setup.py clean \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_customclean.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
		$(do_export) LANG="" $(python3-host.PYTHONBIN) setup.py build \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_custombuild.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
		$(do_export) LANG="" $(python3-host.PYTHONBIN) setup.py install \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_custominstall.log
	$(call lHint,Done)
	$(done)


# python3-asciidoc-host.issue: python3-asciidoc-host.python3-asciidoc-host.issue

python3-asciidoc-host.issue: asciidoc.python3-asciidoc-host.issue
	$(call lHint,Done)
	$(done)


#---fin------------------------------------------------------------------------
