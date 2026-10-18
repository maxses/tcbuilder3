#------------------------------------------------------------------------------
#
#  \brief   GDB recipe for tcbuilder
#
#           Python support is needed for qtcreator.
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


gdb.VERSION          =  gdb-18.1-release
gdb.SCM_TOOL         =  git
gdb.SCM_URL          =  https://sourceware.org/git/binutils-gdb.git
gdb.SOURCE_PATH      =  gdb-mainline
gdb-target.SOURCE_PATH  =gdb-mainline

# $(eval $(call template,gdb,cross))
$(eval $(call Package,gdb))
$(eval $(call template,gdb-target,taget))
$(eval $(call useOwnLdNative, gdb))
$(eval $(call useOwnLd, gdb-target))

# --with-expat: Expat is neccessary for openocd.
# --with-system-readline: Its already installed
gdb.CONFIGUREFLAGS      += $(cross.CONFIGUREFLAGS) \
                             --with-expat \
                             --with-libexpat-prefix=$(HOST_PREFIX) \
                             --with-python=python$(python.MAJOR_VERSION) \
                             --disable-threading \
                             --with-sysroot=$(INSTALLROOT_HOST)$(TARGET_NONUSR_PREFIX) \
                             --with-system-readline

gdb.DESTDIR          = $(cross.DESTDIR)

# On Debian the files /usr/include/ncursesw/* are symlinked to equivalent /usr/include/*
gdb.CPPFLAGS               += \
                        -I$(SYSROOT_HOST)$(HOST_PREFIX)/include/ncursesw

# LDFLAGS: Would be better to fix gdb/configure.ac to let configure find library python3.6m
gdb.ENVIRONMENT         += \
                        $(cross.ENVIRONMENT) \
								LD_LIBRARY_PATH="$(SYSROOT_HOST)$(HOST_PREFIX)/lib" \
                        LIBRARY_PATH="$(SYSROOT_HOST)$(HOST_PREFIX)/lib" \
								$(host.ENVIRONMENT_PERL) \
								$(python3-host.ENVIRONMENT_HOST) \
								PYTHONLIBS=$(SYSROOT_HOST)$(HOST_PREFIX)/lib/python$(python3.MAJOR_VERSION) \
								PYTHONPATH=$(SYSROOT_HOST)$(HOST_PREFIX) \
								PYTHONHOME=$(SYSROOT_HOST)$(HOST_PREFIX):$(SYSROOT_HOST)$(HOST_PREFIX)/lib

gdb-target.ENVIRONMENT     += \
										LD_LIBRARY_PATH="$(SYSROOT_HOST)$(HOST_PREFIX)/lib"

gdb.PYTHON_VERSION_SPLITTED     = $(subst ., ,$(python.VERSION))
gdb.PYTHON_MAJOR_VERSION     =$(word 1, $(gdb.PYTHON_VERSION_SPLITTED)).$(word 2, $(gdb.PYTHON_VERSION_SPLITTED))

gdb.CFLAGS_FOR_HOST            +=-Wl,--copy-dt-needed-entries
gdb.LDFLAGS_FOR_HOST            +=-Wl,--copy-dt-needed-entries


ifeq (gdb,gdb)
   $(eval $(call useOwnLd, gdb))
else
   gdb.ENVIRONMENT      += \
                        LDFLAGS="-L$(SYSROOT_HOST)$(HOST_PREFIX)/lib"
endif


### gdb does not depend on anything from the toolchain, not even binutils
gdb.sourcebase: gdb.scm_sourcebase
gdb.sourcetree: gdb.sourcebase_patched
# libtinfo-host comes with ncurses-host
gdb.cmi_configure: python-host.issue host_expat.issue ncurses-host.issue 
gdb.cmi_configure: mpfr.issue texinfo.issue isl.issue glibc_native.issue libcxx.issue
gdb.cmi_configure: elfutils.issue readline.issue

gdb.install: gdb.cmi
gdb.cmi_make: bison.issue gdb.gdb.ldgram.hook gawkSysRooted.issue

gdb-target.sourcetree: gdb.sourcetree
gdb-target.install: gdb-target.cmi
gdb-target.cmi_configure: ncurses.issue asciidoc.issue texinfo.issue


### Fixes #202:
### PYthon does not find Gdb-python-modules when relocated. This workaround installs symlink.
gdb.pythonlink.hook: gdb.skeleton
	@rm -f $(INSTALLROOT_HOST)$(HOST_PREFIX)/lib/python$(gdb.PYTHON_MAJOR_VERSION)/gdb
	@ln -s ../../share/gdb/python/gdb $(INSTALLROOT_HOST)$(HOST_PREFIX)/lib/python$(gdb.PYTHON_MAJOR_VERSION)/gdb
	$(done)

%.gdb.ldgram.hook: gdb.cmi_configure
	@touch $(SOURCE_PATH)/$($*.SOURCE_PATH)/ld/ldgram.y
	$(silentDone)


gdb.issue: gdb.skeleton gdb.pythonlink.hook
	@$(INSTALLROOT_HOST)$(HOST_PREFIX)/bin/$(TARGET)/$(TARGET)-gdb --configuration | grep with-python >/dev/null || ( echo "Error: gdb has no python support."; exit 22 )
	$(done)

gdb-target.issue: gdb-target.skeleton
	$(done)


#---fin------------------------------------------------------------------------
