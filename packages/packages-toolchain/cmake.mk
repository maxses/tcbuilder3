#-----------------------------------------------------------------------------
#
#  \brief   CMake recipe for tcbuilder
#
#           URL: https://cmake.org/download/
#           Native only
#
#  \author  Maximilian Seesslen <m@seesslen.net>
#  \date    <20160626> file created
#
#-----------------------------------------------------------------------------


cmake_host.VERSION                    =	4.4.4
cmake_host.ARCHIVE_FILE               =	cmake-$(cmake_host.VERSION).tar.gz
cmake_host.ARCHIVE_URL                =	https://cmake.org/files/v4.4/$(cmake_host.ARCHIVE_FILE)
cmake_host.SOURCE_PATH                =	cmake-$(cmake_host.VERSION)

$(eval $(call Package, cmake_host))
$(eval $(call template, cmake_host, host))

$(eval $(call useOwnLd, cmake_host))
$(eval $(call useOwnLdNative, cmake_host))


# OPENSSL is needed for receiving files with help of libcurl, "https"
# https is at least needed in xbmc for receiving third party source archives
# openssl from TCB can not be used at the moment because on hosts sysroot the
# nativ gcc/stdc++ installation is missing. Package "libssl-dev" on host is
# needed.

cmake_host.CONFIGUREFLAGS             = \
                                       LDFLAGS="$(cmake_host.LDFLAGS)" \
                                       CFLAGS="$(cmake_host.CFLAGS)" \
                                       CXXFLAGS="$(cmake_host.CXXFLAGS)" \
                                       --prefix=$(HOST_PREFIX) \
                                       --parallel=16 \
                                       -- -DCMAKE_USE_OPENSSL=ON -DCMAKE_SYSROOT=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX) -DCMAKE_FIND_ROOT_PATH=$(INSTALLROOT_HOST)$(HOST_NONUSR_PREFIX)

#cmake_host.ENVIRONMENT                += \
#                                        $(host.ENVIRONMENT)
cmake_host.DESTDIR                  = $(host.DESTDIR)

cmake_host.cmi_configure: openssl-host.issue libidn.issue


cmake_host.sourcebase: cmake_host.archive_sourcebase
cmake_host.sourcetree: cmake_host.sourcebase_patched
cmake_host.install: cmake_host.cmi
cmake_host.cmi_configure: libcxx.issue

# %.cmake_predepend: cmake_host.issue

cmake_host.issue: cmake_host.skeleton
	$(done)


#---fin------------------------------------------------------------------------
