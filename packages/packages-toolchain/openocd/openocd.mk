#------------------------------------------------------------------------------
#
#  \brief   OpenOCD recipe for tcbuilder
#
#           URL: https://openocd.org/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20151208> file created
#
#------------------------------------------------------------------------------


openocd.VERSION						= v0.12.0
openocd.SCM_TOOL						= git
openocd.SCM_URL						= https://github.com/openocd-org/openocd.git
# [20261014]: Submodule "gitlab.zapb.de/libjaylink/libjaylink.git" dead
# There is a patch included to change submodules URL. "bootstrap" 
# will download submodules afterwards.
openocd.SCM_IGNORE_SUBMODULES		= yes
openocd.SOURCE_PATH					= openocd-$(openocd.VERSION)

$(eval $(call Package,openocd))
$(eval $(call template,openocd,host))
$(eval $(call useOwnLdNative, openocd))


# $(host.CONFIGUREFLAGS)

openocd.CONFIGUREFLAGS			+=  \
					--enable-stlink \
					--enable-dummy \
					--disable-rlink \
					--disable-usbprog

#					--enable-pc-files \
#					--with-pkg-config-libdir=$(HOST_PKG_CONFIG_PATH) \
#					--with-pkg-config



# 						    CFLAGS="$(useOwnLdNative.FLAGS)" \

#  $(host.ENVIRONMENT)
openocd.PATH 					= /home/user/obj/tcbuilder3-3.0.1/rootfs-stm32-x86_64/opt/tcb-3.0.1-stm32-x86_64/usr/bin
openocd.ENVIRONMENT				+= \
										$(host.ENVIRONMENT_AUTOTOOLS) \
										$(host.ENVIRONMENT_AUTOMAKE) \
										$(host.ENVIRONMENT_PERL) \
						    PKG_CONFIG_SYSROOT_DIR=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) \
						    PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
						    pkgauxdir=$(HOST_PKG_CONFIG_PATH)/usr/share/libtool/build-aux \
						    pkgdatadir=/asdölkasöldk \
						    LIBTOOL=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/usr/bin/libtool \
						    LIBTOOLIZE=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)/usr/bin/libtoolize \
						    _LT_PATH_MAGIC=xaa \
						    LT_SYS_LIBRARY_PATH=/home/user \
						    _lt_pkgdatadir=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share/libtool \
						    AC_CONFIG_MACRO_DIRS=/root


# 						    LIBTOOL=/bin/test

openocd.DESTDIR               = $(host.DESTDIR)

openocd.BOOTSTRAP_ENVIRONMENT	=	$(openocd.ENVIRONMENT)

### openocd does not depend on anything from the toolchain, not even binutils
openocd.sourcebase: openocd.scm_sourcebase
openocd.sourcetree: openocd.sourcebase_patched
openocd.cmi_configure: automake.issue 

# openocd.autoreconf

openocd.cmi_configure: openocd.bootstrap
# openocd.autoreconf
openocd.autoreconf: $(AUTOTOOLS)

# openocd.cmi_configure: automake.issue openocd.autoconf2
# openocd.autoreconf
openocd.cmi_configure: python-host.issue libusb-host.issue pkg-config.issue
# openocd.bootstrap
openocd.install: openocd.cmi
openocd.bootstrap: $(AUTOTOOLS)

openocd.issue: openocd.skeleton
	$(done)


#---fin------------------------------------------------------------------------
