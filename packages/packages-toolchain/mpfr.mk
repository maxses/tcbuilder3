#------------------------------------------------------------------------------
#
#  \brief   Mpfr recipe for tcbuilder
#
#           URL: https://www.mpfr.org/mpfr-current/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


mpfr.VERSION                   = 4.2.2
mpfr.ARCHIVE_FILE              = mpfr-$(mpfr.VERSION).tar.xz
mpfr.ARCHIVE_URL               = http://www.mpfr.org/mpfr-current/$(mpfr.ARCHIVE_FILE)
mpfr.SOURCE_PATH               = mpfr-$(mpfr.VERSION)
mpfr.SCOPE                     = local

$(eval $(call template,mpfr,host))

mpfr.CONFIGUREFLAGS            += \
											--enable-shared \
											--enable-static

#                                 -libdir=$(INSTALLROOT)$(PREFIX)/lib

mpfr.ENVIRONMENT               += \
											$(host.ENVIRONMENT_PERL)

$(eval $(call Package,mpfr))

mpfr.sourcebase:     mpfr.archive_sourcebase
mpfr.sourcetree:     mpfr.sourcebase_patched
mpfr.preconfigure:    gmp.issue texinfo.issue
mpfr.install:        mpfr.cmi mpfr.remove_la


mpfr.issue: mpfr.skeleton
	$(done)


#---fin------------------------------------------------------------------------
