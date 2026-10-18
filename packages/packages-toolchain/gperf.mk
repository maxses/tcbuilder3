#------------------------------------------------------------------------------
#
#  \brief   Gperf recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20261017> file created
#
#------------------------------------------------------------------------------


gperf.VERSION                   = 3.3
gperf.ARCHIVE_FILE              = gperf-$(gperf.VERSION).tar.gz
gperf.ARCHIVE_URL               = https://ftp.gnu.org/gnu/gperf/$(gperf.ARCHIVE_FILE)
gperf.SOURCE_PATH               = gperf-$(gperf.VERSION)
gperf.SCOPE                     = local


# Do not assume there is already a cusmtom libc compilation. Maybe build a second stage later.
# $(eval $(call useOwnLdNative, gperf))

# gperf.CONFIGUREFLAGS				=	--fuck $(host.CONFIGUREFLAGS)
gperf.CONFIGUREFLAGS					+=	$(host.CONFIGUREFLAGS) \
		--with-mpfr
gperf.ENVIRONMENT                 +=	$(host.ENVIRONMENT)
gperf.DESTDIR                     =	$(host.DESTDIR)


gperf.sourcebase:     gperf.archive_sourcebase
gperf.sourcetree:     gperf.sourcebase_patched
gperf.cmi_configure:  mpfr.issue


gperf.issue: gperf.cmi
	$(done)


#---fin------------------------------------------------------------------------
