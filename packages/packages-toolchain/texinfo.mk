#------------------------------------------------------------------------------
#
#  \brief   Texinfo recipe for tcbuilder
#
#           URL: http://ftp.wrz.de/pub/gnu/texinfo
#           nwelib-nano wants it
#
#  \author  Maximilian Seesslen <src@seesslen.net>
#  \date    <20170222> file created
#
#------------------------------------------------------------------------------


texinfo.VERSION         = 7.3
texinfo.ARCHIVE_FILE    = texinfo-$(texinfo.VERSION).tar.xz
texinfo.ARCHIVE_URL     = $(GNU_MIRROR)/texinfo/$(texinfo.ARCHIVE_FILE)
texinfo.SOURCE_PATH     = texinfo-$(texinfo.VERSION)

$(eval $(call Package,texinfo))
$(eval $(call template,texinfo,host))

texinfo.ENVIRONMENT         += \
                                 $(host.ENVIRONMENT_PERL) \
                                 PERL_EXT_CPPFLAGS="-I$(HOST_PATH)/lib/perl5/$(perl.SVERSION)/x86_64-linux/CORE"
# texinfo.CONFIGUREFLAGS		 = --verbose

texinfo.sourcebase: texinfo.archive_sourcebase
texinfo.sourcetree: texinfo.sourcebase_patched
texinfo.cmi: text-unidecode.issue
texinfo.install: texinfo.cmi

texinfo.issue: texinfo.skeleton
	$(done)


#---fin------------------------------------------------------------------------
