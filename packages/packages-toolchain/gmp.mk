#------------------------------------------------------------------------------
#
#  \brief   Gmp recipe for tcbuilder
#
#           URL: https://gmplib.org/
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


gmp.VERSION                   = 6.3.0
gmp.BASE_VERSION              = 6.3.0
gmp.ARCHIVE_FILE              = gmp-$(gmp.VERSION).tar.bz2
gmp.ARCHIVE_URL               = $(GNU_MIRROR)/gmp/$(gmp.ARCHIVE_FILE)
gmp.SOURCE_PATH               = gmp-$(gmp.BASE_VERSION)
gmp.SCOPE                     = local

# target "check" does not work with '-flto'
gmp.ADDITIONAL_MAKE_TARGET      = check
gmp.CONFIGUREFLAGS              += \
                                --enable-shared \
                                --enable-static

# Configure will fail with GCC15 because it defaults to defaults to -std=gnu23
# https://gmplib.org/list-archives/gmp-bugs/2024-November/005550.html
gmp.CFLAGS_FOR_HOST             += -std=c11

$(eval $(call Package,gmp))
$(eval $(call template,gmp,host))


gmp.sourcebase:     gmp.archive_sourcebase
gmp.sourcetree:     gmp.sourcebase_patched
gmp.build:          gmp.cmi_make_additional_target
gmp.install:        gmp.cmi gmp.remove_la
gmp.cmi_configure:  m4.issue


gmp.issue: gmp.skeleton
	$(done)


#---fin------------------------------------------------------------------------
