#------------------------------------------------------------------------------
#
#  \brief   Libidn recipe for tcbuilder
#
#           URL: https://www.gnu.org/software/libidn/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20260626> File created
#
#------------------------------------------------------------------------------


libidn.VERSION                   = 2.3.8
libidn.BASE_VERSION              = 2.3.8
libidn.ARCHIVE_FILE              = libidn2-v$(libidn.VERSION)-src.tar.gz
libidn.ARCHIVE_URL               = $(GNU_MIRROR)/libidn/$(libidn.ARCHIVE_FILE)
libidn.SOURCE_PATH               = libidn2-v$(libidn.BASE_VERSION)
libidn.SCOPE                     = local

# target "check" does not work with '-flto'
# libidn.ADDITIONAL_MAKE_TARGET      = check
libidn.CONFIGUREFLAGS              += \
				$(host.CONFIGUREFLAGS) \
                                --enable-shared \
                                --enable-static

# Configure will fail with GCC15 because it defaults to defaults to -std=gnu23
# https://gmplib.org/list-archives/gmp-bugs/2024-November/005550.html
# libidn.CFLAGS_FOR_HOST             += -std=c11

$(eval $(call Package,libidn))
$(eval $(call template,libidn,host))
$(eval $(call useOwnLdNative, libidn))

libidn.CONFIGUREFLAGS              += \
                                --enable-shared \
                                --enable-static

libidn.ENVIRONMENT                 += \
                                $(host.ENVIRONMENT_AUTOTOOLS) \
                                $(host.ENVIRONMENT_AUTOMAKE) \
                                $(host.ENVIRONMENT_PERL) \
				_lt_pkgdatadir=$(INSTALLROOT_HOST)$(HOST_USR_PREFIX)/share/libtool


# LD_FLAGS_x are not applied
libidn.CFLAGS_FOR_HOST             += $(useOwnLdNative.FLAGS)

libidn.sourcebase:     libidn.archive_sourcebase
libidn.sourcetree:     libidn.sourcebase_patched
libidn.install:        libidn.cmi
libidn.cmi_configure:  libidn.bootstrap libidn.precheck glibc_native.issue
libidn.bootstrap:      $(AUTOTOOLS) gettext.issue gengetopt.issue gperf.issue


libidn.issue: libidn.skeleton libidn.cmi
	$(RUN_LDCONFIG)
	$(done)

libidn.precheck:
	@# Meanwhile its inatalled in sysroot
	@#if [ ! -e "/usr/bin/gengetopt" ]; then echo "Libidn: Error: please install gengetopt. Can not generate it at the moment."; exit 1; fi
	$(genericDone)


#---fin------------------------------------------------------------------------
