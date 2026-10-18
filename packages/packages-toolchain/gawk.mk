#------------------------------------------------------------------------------
#
#  \brief   Gawk recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


# 5.4.1 has problems generation code for GCC
gawk.VERSION                   = 5.3.2
gawk.ARCHIVE_FILE              = gawk-$(gawk.VERSION).tar.xz
gawk.ARCHIVE_URL               = https://ftp.gnu.org/gnu/gawk/$(gawk.ARCHIVE_FILE)
gawk.SOURCE_PATH               = gawk-$(gawk.VERSION)
gawk.SCOPE                     = local


# Do not assume there is already a cusmtom libc compilation. Maybe build a second stage later.
# $(eval $(call useOwnLdNative, gawk))
$(eval $(call useOwnLdNative, gawkSysRooted))

# gawk.CONFIGUREFLAGS				=	--fuck $(host.CONFIGUREFLAGS)
gawk.CONFIGUREFLAGS					+=	$(host.CONFIGUREFLAGS) \
		--with-mpfr
gawk.ENVIRONMENT                 +=	$(host.ENVIRONMENT)
gawk.DESTDIR                     =	$(host.DESTDIR)

gawkSysRooted.CONFIGUREFLAGS		+=	$(gawk.CONFIGUREFLAGS)
gawkSysRooted.ENVIRONMENT        +=	$(gawk.ENVIRONMENT)
gawkSysRooted.SOURCE_PATH        = $(gawk.SOURCE_PATH)
gawkSysRooted.VERSION				= $(gawk.VERSION)
gawkSysRooted.DESTDIR            = $(gawk.DESTDIR)

gawk.sourcebase:     gawk.archive_sourcebase
gawk.sourcetree:     gawk.sourcebase_patched
gawk.cmi_configure:  mpfr.issue

gawkSysRooted.sourcetree:     gawk.sourcetree


gawk.issue: gawk.cmi
	$(done)

gawkSysRooted.issue: gawkSysRooted.cmi
	$(done)

gawkSysRooted.cmi_configure: glibc_native.issue
gawkSysRooted.veryclean: gawk.veryclean


#---fin------------------------------------------------------------------------
