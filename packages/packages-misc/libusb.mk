#------------------------------------------------------------------------------
#
#  \brief   libusb library package recipe for tcbuilder
#
#           ...
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


libusb.VERSION							=	v1.0.30
libusb.SCM_TOOL						=	git
libusb.SOURCE_PATH					=	libusb-mainline
libusb.SCM_URL							=	https://github.com/libusb/libusb.git
libusb.CONFIGUREFLAGS				=	$(target.CONFIGUREFLAGS) \
												--disable-udev
libusb.ENVIRONMENT					=	$(target.ENVIRONMENT)

$(eval $(call template,libusb-host,host))

libusb-host.CONFIGUREFLAGS				+= $(host.CONFIGUREFLAGS)\
													--disable-udev

foo_lt= \
							 AC_MACRODIR=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share/autoconf \
							 AC_CONFIG_AUXDIR=/root \
							_lt_pkgdatadir=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share/libtool \
							_lt_datadir=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share

libusb-host.ENVIRONMENT					+= \
							 $(host.ENVIRONMENT_PERL) \
							 $(host.ENVIRONMENT_AUTOTOOLS) \
							 $(host.ENVIRONMENT_AUTOMAKE) \
							 $(no-foo_lt) \
							_lt_pkgdatadir=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share/libtool

libusb-host.CONFIGURELFAGS			+=


libusb-host.SOURCE_PATH					=$(libusb.SOURCE_PATH)
libusb-host.VERSION                 =$(libusb.VERSION)

libusb-host.AUTOGEN_ARGS                 = \
                                                   --with-sysroot=/root \
                                                   --with-libtool-sysroot=/root
libusb-host.BOOTSTRAP_COMMAND				= bootstrap.sh
libusb-host.BOOTSTRAP_ARGS				= LIBTOOL=/bin/test
libusb-host.BOOTSTRAP_ENVIRONMENT			= $(libusb-host.ENVIRONMENT)

PACKAGES                          += libusb libusb-host

libusb.sourcebase: libusb.scm_sourcebase

#libusb.cmi_configure: libusb.autogen
# libusb.cmi_configure: libusb.bootstrap

libusb-host.sourcebase: libusb.sourcebase
libusb-host.veryclean: libusb.veryclean

libusb.autogen: libusb.sourcebase

libusb-host.cmi_configure: libusb-host.autogen
# libusb-host.cmi_configure: libusb-host.bootstrap

libusb-host.autogen: m4.issue gettext.issue

libusb.issue: libusb.cmi
	$(done)

libusb-host.issue: libusb-host.cmi
	$(done)


#---fin------------------------------------------------------------------------
