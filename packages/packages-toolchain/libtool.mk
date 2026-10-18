#------------------------------------------------------------------------------
#
#  \brief   Libtool recipe for tcbuilder
#
#           URL: https://www.gnu.org/software/libtool/
#                https://mirrors.kernel.org/gnu/libtool/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


libtool.VERSION         =	2.6.2
libtool.ARCHIVE_FILE    =	libtool-$(libtool.VERSION).tar.gz
libtool.ARCHIVE_URL     =	$(GNU_MIRROR)/libtool/$(libtool.ARCHIVE_FILE)
libtool.SOURCE_PATH     =	libtool-$(libtool.VERSION)

libtdl.SOURCE_PATH		=	$(libtool.SOURCE_PATH)

$(eval $(call Package,libtool))
$(eval $(call Package,libtdl))


$(eval $(call template,libtool,host))
$(eval $(call template,libtdl,host))

libtool.CONFIGUREFLAGS      += \
										--enable-dlopen

# 										--disable-libtool-lock

libtdl.CONFIGUREFLAGS      += \
										--enable-ltdl-install \
										--enable-dlopen

libtdl.ENVIRONMENT         +=


### libtool does not depend on anything from the toolchain, not even binutils
### But it wants help2man
libtool.cmi_make:	help2man.issue
libtool.sourcebase: libtool.archive_sourcebase
libtool.sourcetree: libtool.sourcebase_patched
libtool.install: libtool.cmi
libtool.cmi_configure: m4.issue

libtdl.sourcetree: libtool.sourcebase_patched
libtdl.install: libtdl.cmi

# _lt_pkgdatadir can be set to override local libtool directory. But in that
# case libtool expects the directory "m4" to be available there.
# OpenOBC has to use this workaround or it would strugle with hosts libtool version
libtool.issue: libtool.skeleton
	@cp -rf $(SOURCE_PATH)/$(libtool.SOURCE_PATH)/m4 \
		$(SYSROOT_HOST)/$(HOST_USR_PREFIX)/share/libtool
	$(done)

libtdl.issue: libtdl.skeleton
	$(done)


#---fin------------------------------------------------------------------------
