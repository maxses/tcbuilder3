#------------------------------------------------------------------------------
#
#  \brief   Autoconf recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


autoconf.VERSION         = 2.73
autoconf.ARCHIVE_FILE    = autoconf-$(autoconf.VERSION).tar.xz
autoconf.ARCHIVE_URL     = $(GNU_MIRROR)/autoconf/$(autoconf.ARCHIVE_FILE)
autoconf.SOURCE_PATH     = autoconf-$(autoconf.VERSION)

$(eval $(call Package,autoconf))
$(eval $(call template,autoconf,host))

host.ENVIRONMENT_AUTOTOOLS		= \
											AUTOM4TE=$(HOST_PATH)/bin/autom4te \
											AUTOCONF=$(HOST_PATH)/bin/autoconf \
											AUTOHEADER=$(HOST_PATH)/bin/autoheader \
											AC_MACRODIR=$(HOST_PATH)/share/autoconf \
											trailer_m4=$(HOST_PATH)/share/autoconf/autoconf/trailer.m4 \
											autom4te_perllibdir=$(HOST_PATH)/share/autoconf

autoconf.ENVIRONMENT				+= \
											$(host.ENVIRONMENT_AUTOTOOLS)

autoconf.sourcebase: autoconf.archive_sourcebase
autoconf.sourcetree: autoconf.sourcebase_patched
autoconf.install: autoconf.cmi
autoconf.cmi_configure: m4.issue

autoconf.issue: autoconf.skeleton
	@if [ ! -e "$(HOST_PATH)/share/autoconf/autom4te.cfg.org" ]; then \
		cp $(HOST_PATH)/share/autoconf/autom4te.cfg \
			$(HOST_PATH)/share/autoconf/autom4te.cfg.org; \
		fi
	@sed -i "s|'$(HOST_PREFIX)/share|'$(HOST_PATH)/share|g" \
		$(HOST_PATH)/share/autoconf/autom4te.cfg
	$(done)


#---fin------------------------------------------------------------------------
