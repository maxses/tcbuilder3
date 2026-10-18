#-----------------------------------------------------------------------------
#
#  \brief   Meson recipe for tcbuilder
#
#           https://github.com/mesonbuild
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261013> file created
#
#-----------------------------------------------------------------------------


meson.VERSION                 =	1.12.1
meson.SCM_TOOL                =	git
meson.SCM_URL                 =	https://github.com/mesonbuild/meson.git
meson.SOURCE_PATH             =	meson-$(meson.VERSION)
python3-meson-host.ENVIRONMENT         = $(host.ENVIRONMENT) \
						PYTHONPATH=$(SYSROOT_HOST)$(HOST_PREFIX)/lib/python$(python.MAJOR_VERSION)/site-packages


meson.sourcebase: meson.scm_sourcebase
meson.sourcetree: meson.sourcebase_patched

python3-meson-host.python_custombuild.hook: python3-setuptools-host.issue
python3-meson-host.python_custombuild.hook: python3-pip-host.issue
python3-meson-host.veryclean: meson.veryclean

# $(eval $(call pythonPackageHost,meson,3))

%.python3-meson-host.issue: python3-pip-host.sourcebase python3-setuptools-host.issue python3-host.issue meson.sourcetree
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


meson.issue: meson.python3-meson-host.issue
	$(done)


#---fin------------------------------------------------------------------------
