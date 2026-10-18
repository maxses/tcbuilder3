#------------------------------------------------------------------------------
#
#  \brief   isl library package recipe for tcbuilder
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20130403> file created
#
#------------------------------------------------------------------------------


isl.VERSION                   =0.28
isl.ARCHIVE_FILE              =isl-$(isl.VERSION).tar.gz
isl.ARCHIVE_URL               =https://libisl.sourceforge.io/$(isl.ARCHIVE_FILE)
isl.SOURCE_PATH               =isl-$(isl.VERSION)
isl.SCOPE                     =local

$(eval $(call Package,isl))
$(eval $(call template,isl,host))


# target "check" does not work with '-flto'
isl.ADDITIONAL_MAKE_TARGET    =check
isl.CONFIGUREFLAGS            += \
											--enable-shared \
											--enable-static

isl.ENVIRONMENT                 += \
											$(host.ENVIRONMENT_PERL) \
											$(host.ENVIRONMENT_AUTOTOOLS)

isl.CPPFLAGS_FOR_HOST			=-I$(SYSROOT_HOST)$(HOST_PREFIX)/include
isl.LDFLAGS_FOR_HOST			=-L$(SYSROOT_HOST)$(HOST_PREFIX)/lib


isl.sourcebase:     isl.archive_sourcebase
isl.sourcetree:     isl.sourcebase_patched
isl.build:          isl.cmi_make_additional_target
isl.install:        isl.cmi
isl.cmi_configure:  m4.issue gmp.issue


isl.issue: isl.skeleton
	$(done)


#---fin------------------------------------------------------------------------
