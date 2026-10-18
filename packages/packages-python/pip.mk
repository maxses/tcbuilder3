#------------------------------------------------------------------------------
#
#  \brief   pip recipe for tcbuilder
#
#           Pip needs pip to install pip.
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20230130> file created
#
#-----------------------------|------------------------------------------------


python3-pip-host.VERSION					= 23.3.2
python3-pip-host.ARCHIVE_FILE				= pip-$(python3-pip-host.VERSION).tar.gz
python3-pip-host.ARCHIVE_URL				= https://github.com/pypa/pip/archive/refs/tags/$(python3-pip-host.VERSION).tar.gz
# https://files.pythonhosted.org/packages/b5/16/5e24bf63cff51dcc169f43bd43b86b005c49941e09cc3482a5b370db239e/pip-23.0.tar.gz
python3-pip-host.SOURCE_PATH				= pip-$(python3-pip-host.VERSION)
python3-pip-host.ENVIRONMENT				= PYTHONHOME=$(SYSROOT_HOST)$(HOST_PREFIX)
python3-pip-host.PYTHONBIN					= $(SYSROOT_HOST)$(HOST_PREFIX)/bin/python3

python3-pip-host.sourcebase: python3-pip-host.archive_sourcebase

%.python3-pip-host.issue: python3-pip-host.sourcebase python3-setuptools-host.issue python3-host.issue
	$(call lHint,Building $*)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$(do_export) LANG="" export \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_export.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$(do_export) \
			$($*.PYTHONBIN) setup.py clean \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_customclean.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$(do_export) LANG="" $($*.PYTHONBIN) setup.py build \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_custombuild.log
	$(call lHint,Done)
	$(done)


python3-pip-host.issue: python3-pip-host.python3-pip-host.issue
	$(call lHint,Done)
	$(done)


#---fin------------------------------------------------------------------------
