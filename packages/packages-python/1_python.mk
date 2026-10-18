#------------------------------------------------------------------------------
#
#  \brief   Python package recipe for tcbuilder
#
#           The additional module directory "/usr/lib/python3/dist-packages" is 
#           an debian specific thing. The file "site.py" is patched for this 
#           behaviour.
#           TCB will just use default behaviour.
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#-----------------------------|------------------------------------------------


vpath %.hostpython	$(DONE_PATH)

python.VERSION						=	3.15.0
python.MAJOR_VERSION				=	3.15
python3.MAJOR_VERSION         =	$(python.MAJOR_VERSION)
python.MAJOR_VERSION_INCLUDE	=	$(python.MAJOR_VERSION)
python3.MAJOR_VERSION_INCLUDE	=	$(python.MAJOR_VERSION)
python.ARCHIVE_FILE				=	Python-$(python.VERSION).tar.xz
python.ARCHIVE_URL				=	http://www.python.org/ftp/python/$(python.VERSION)/$(python.ARCHIVE_FILE)
python.ENTRY_PATH					=	Python-$(python.VERSION)
python.SOURCE_PATH				=	Python-$(python.VERSION)
#-- disbale-ipv6: Fatal: You must get working getaddrinfo() function. or you \
#-- can specify "--disable-ipv6".
python.CONFIGUREFLAGS			=	$(target.CONFIGUREFLAGS) \
											--enable-shared \
											--enable-optimizations \
											--enable-unicode=ucs4 \
											--enable-zlib \
											--disable-zstd \
											--disable-ipv6

python.ENVIRONMENT				=	$(target.ENVIRONMENT)
#-- LD_LIBRARY_PATH: avoid using the systems libpython; even calling the tcb
#-- host python will result in unndefined references; run python and check
#-- version
python.ENVIRONMENT				+=	\
											HOSTPYTHON=$(B)/hostpython \
											HOSTPGEN=$(B)/Parser/hostpgen \
											BLDSHARED="$(TARGET)-gcc -shared" \
											CROSS_COMPILE=$(TARGET)- \
											CROSS_COMPILE_TARGET=yes \
											HOSTARCH=$(TARGET) \
											BUILDARCH=$(BUILD) \
											LD_LIBRARY_PATH=$(SYSROOT_HOST)$(HOST_PREFIX)/lib

$(eval $(call useOwnLdNative, python-host))

python-host.VERSION				=	$(python.VERSION)
python-host.SOURCE_PATH			=	$(python.SOURCE_PATH)

# Used in "configure":
python-host.CFLAGS_FOR_HOST		+=   --sysroot=$(SYSROOT_HOST)$(HOST_NONUSR_PREFIX) \
					    -Wl,--sysroot=$(SYSROOT_HOST)$(HOST_NONUSR_PREFIX) \

python-host.LDFLAGS_FOR_HOST		+=   --sysroot=$(SYSROOT_HOST)$(HOST_NONUSR_PREFIX) \
					    -Wl,--sysroot=$(SYSROOT_HOST)$(HOST_NONUSR_PREFIX) \


$(eval $(call template,python-host,host))

# PKG_CONFIG: This is needed to avoid usage of local pkg-config. It may find 
# hosts packages but then apply sysroot pointing to non-existant libraries.
python-host.ENVIRONMENT		+=	\
                                   PKG_CONFIG_SYSROOT_DIR=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) \
                                   PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
                                   PKG_CONFIG=$(HOST_PKG_CONFIG) \
                                   PATH="$(HOSTTOOLS_BIN_PATH):${PATH}"

# --enable-shared: Needed by QtCreator to load its modules. libpythonX.so needed.
python-host.CONFIGUREFLAGS		+=	\
                                   --enable-shared

python3-host.PYTHONBIN			=	$(SYSROOT_HOST)$(HOST_PREFIX)/bin/python3
python3-host.PYTHONHOME			=	$(SYSROOT_HOST)$(HOST_PREFIX)

$(eval $(call Package,python))
$(eval $(call Package,python-host))


python.sourcebase: python.archive_sourcebase
python.sourcetree: python.sourcebase_patched
python.cmi_configure: python.python3-hostpython.hostpython python.config_site.hook
python.cmi_configure: openssl.issue sqlite.issue
python-host.sourcebase: python.sourcebase
python-host.sourcetree: python.sourcebase_patched
python-host.veryclean: python.veryclean
python.cmi_make_install: python.lsb_release.hook

python-host.cmi_configure: zlib-host.issue
python3-host.issue: python-host.issue
	$(silentDone)

python-host.cmi_make:    lzma-host.issue bzip2-host.issue zstd_native.issue \
			readline.issue ncurses-host.issue libffi-host.issue

python-host.cmi_make_install: python-host.update_ldconfig.hook

# Updating ldconfig is needed or bzip2 or ffi might not be found and modules are
# not created correctly.
python-host.update_ldconfig.hook: python-host.cmi_make
	$(call lHint, Updating ldconfig)
	$(RUN_LDCONFIG)
	$(done)

#-- First we have to compile host binaries.
%.python3-hostpython.hostpython: %.cmi_predepend
	$(call lHint, Parser)
	@mkdir -p $(B)
	@# distclean breaks, clean neccessary because cross-compiled files have to be removed
	@cd $(B); [ ! -e "Makefile" ] || $(MAKE) clean \
		$(REDIRECTION_STATEMENT) $(LOG_PATH)/python_hostpython_clean.log
	@cd $(B); rm -f python Parser/pegen; $(SOURCE_PATH)/$(python.SOURCE_PATH)/configure \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/python_hostpython_config.log
	@#cd $(B); $(MAKE) python Parser/pegen CROSS_COMPILE_TARGET=no \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/python_hostpython_make.log
	@cd $(B); $(MAKE) python CROSS_COMPILE_TARGET=no \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/python_hostpython_make.log
	$(call lHint, copying)
	@cd $(B); mv python hostpython
	@#cd $(B); mv Parser/pegen Parser/hostpgen
	@# Lib/test/data/* needed for distclean
	@cd $(B); mkdir -p Lib/test/data; echo "max" > Lib/test/data/max
	$(call lHint, distclean)
	@cd $(B); $(MAKE) distclean \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/python_hostpython_distclean.log
	$(silentDone)


#-- This fixes "configure: error: set ac_cv_file__dev_ptmx to yes/no in your \
#-- CONFIG_SITE file when cross compiling" with 2.7.5
python.config_site.hook: python.cmi_predepend
	@echo -e "ac_cv_file__dev_ptmx=no\nac_cv_file__dev_ptc=no\n" > $(SOURCE_PATH)/$(python.SOURCE_PATH)/config.site
	$(silentDone)

python.lsb_release.hook:
	@mkdir -p $(INSTALLROOT_HOST)$(HOST_PREFIX)/bin
	@echo -e "#!/bin/bash\necho tcbuilder3\n" > $(INSTALLROOT_HOST)$(HOST_PREFIX)/bin/lsb_release
	$(silentDone)

python.issue: python.cmi
	$(done)

python3.issue: python.issue
	$(done)


python-host.issue: python-host.cmi patchelf_native.issue
	@[ -e "$(HBP)/$(HOST)-python$(python.MAJOR_VERSION)-config" ] || \
		ln -s python$(python.MAJOR_VERSION)-config $(HBP)/$(HOST)-python$(python.MAJOR_VERSION)-config
	@# It can not be started when the host python has different version.
	@# Adjust the library path in the elf file. But the own interpreter (linker loader)
	@# might not exist yet.
	@$(HOSTTOOLS_BIN_PATH)/patchelf \
					--set-rpath $(INSTALLROOT_HOST)$(HOST_PREFIX)/lib \
					$(INSTALLROOT_HOST)$(HOST_PREFIX)/bin/python3
	$(done)

python-host.cmi_configure: openssl-host.issue


# Param 1: Raw package name; e.g. setuptools
# Param 2: Python version; 2 or 3
define pythonPackage
python$(2)-$(1).ENTRY_PATH			=$(1)-$($(1).VERSION)
python$(2)-$(1).SOURCE_PATH			?=$(1)-$($(1).VERSION)

python$(2)-$(1).CONFIGUREFLAGS			= $(target.CONFIGUREFLAGS)
python$(2)-$(1).PYTHON_MAJOR_VERSION	= $(2)
python$(2)-$(1).PYTHON					= python$(2)
python$(2)-$(1).PYTHON_VERSION			= $(python$(2).MAJOR_VERSION)
python$(2)-$(1).INSTALL_PREFIX				=$(SYSROOT_TARGET)$(TARGET_PREFIX)
python$(2)-$(1).CFLAGS_FOR_TARGET			?= Fuckup
python$(2)-$(1).ENVIRONMENT				=	$$(target.ENVIRONMENT) \
														LANG="" \
										QEMU_SET_ENV=PYTHONPATH=$(SYSROOT_TARGET)$(TARGET_PREFIX)/lib/python$(python$(2).MAJOR_VERSION),LD_LIBRARY_PATH=$(SYSROOT_TARGET)$(TARGET_PREFIX)/lib \
										LD_LIBRARY_PATH=$(SYSROOT_TARGET)$(TARGET_PREFIX)/lib \
										PYTHON=/fooo/bar \
										PYTHONEXECUTABLE=/foo/bar

python$(2)-$(1).ENVIRONMENT_INSTALL			= \
										PYTHONLIBS=$(SYSROOT_TARGET)$(TARGET_PREFIX)/lib/python$(python$(2).MAJOR_VERSION) \
										PYTHONPATH=$(SYSROOT_TARGET)$(TARGET_PREFIX) \
										PYTHONHOME=$(SYSROOT_TARGET)$(TARGET_PREFIX)

python$(2)-$(1).python_custombuild.hook: qemu.issue
# just in case aou are using host to install
python$(2)-$(1).python_custombuild.hook: python2-host.issue

python$(2)-$(1).PYTHONBIN_TARGET			=	$(QEMU) \
											$(SYSROOT_TARGET)$(TARGET_PREFIX)/bin/python$(2)
python$(2)-$(1).PYTHONBIN					= python2
python$(2)-$(1).PYTHONBIN_HOST			=	\
											$(SYSROOT_HOST)$(HOST_PREFIX)/bin/python$(2)
python$(2)-$(1).ENVIRONMENT_HOST			= \
										PYTHONLIBS=$(SYSROOT_HOST)$(HOST_PREFIX)/lib/python$(python$(2).MAJOR_VERSION) \
										PYTHONPATH=$(SYSROOT_HOST)$(HOST_PREFIX) \
										PYTHONHOME=$(SYSROOT_HOST)$(HOST_PREFIX)

python$(2)-$(1): python$(2)-$(1).python_custombuild.hook

python$(2)-$(1).python_custombuild.hook: $(1).sourcebase python$(2).issue
python$(2)-$(1).veryclean: $(1).veryclean
python$(2)-$(1).issue: python$(2)-$(1).python_custombuild.hook

python$(2)-$(1).issue:
	$(call writeCustomDone,python$(2)-$(1).issue)
	$(call lHint,Done)

endef

define pythonPackageHost
python$(2)-$(1)-host.ENTRY_PATH			=$(1)-$($(1).VERSION)
python$(2)-$(1)-host.SOURCE_PATH			?=$(1)-$($(1).VERSION)

python$(2)-$(1)-host.CONFIGUREFLAGS			= $(host.CONFIGUREFLAGS)
python$(2)-$(1)-host.PYTHON_MAJOR_VERSION	= $(2)
python$(2)-$(1)-host.INSTALL_PREFIX				=$(SYSROOT_HOST)$(HOST_PREFIX)
python$(2)-$(1)-host.ENVIRONMENT				= \
							$(host.ENVIRONMENT) LANG="" \
							PYTHONLIBS=$(SYSROOT_HOST)$(HOST_PREFIX)/lib/python$(python$(2).MAJOR_VERSION) \
							PYTHONPATH=$(SYSROOT_HOST)$(HOST_PREFIX)
python$(2)-$(1)-host.PYTHONLIBS				= \
							$(SYSROOT_HOST)$(HOST_PREFIX)/lib/python$(python$(2).MAJOR_VERSION)
python$(2)-$(1)-host.PYTHONBIN_TARGET		=	python$(2)
python$(2)-$(1)-host.PYTHONBIN				= $(python$(2)-host.PYTHONBIN)
python$(2)-$(1)-host.PYTHONHOME				= $(python$(2)-host.PYTHONHOME)
python$(2)-$(1)-host: python$(2)-$(1).python_custombuild.hook

python$(2)-$(1)-host.python_custombuild.hook: $(1).sourcebase python$(2)-host.issue python$(2)-pip-host.issue
python$(2)-$(1)-host.issue: python$(2)-$(1)-host.python_custombuild.hook

python$(2)-$(1)-host.issue:
	$(call writeCustomDone,python$(2)-$(1)-host.issue)
	$(call lHint,Done)

endef


%.python_custombuild.hook:
	$(call lHint,Building $*)
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$(do_export) LANG="" export \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_export.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$(do_export) \
			$($*.PYTHONBIN_TARGET) setup.py clean \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_customclean.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$(do_export) LANG="" $($*.PYTHONBIN_TARGET) setup.py build \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_custombuild.log
	@#echo "$(do_export) cp -rf build/lib/* $($*.PYTHONLIBS)"
	@$(do_export) $($*.PYTHONBIN) -m pip install $(SOURCE_PATH)/$($*.SOURCE_PATH) \
			$(REDIRECTION_STATEMENT) $(LOG_PATH)/$*_install.log
	@cd $(SOURCE_PATH)/$($*.SOURCE_PATH); \
			$(do_export) /usr/bin/cp -rf build/lib/* $$PYTHONLIBS
	$(call lHint,Done)
	$(done)


#---fin------------------------------------------------------------------------
